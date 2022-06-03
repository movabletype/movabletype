use 5.008001; # sane UTF-8 support
use strict;
use warnings;
package YAML::Tiny; # git description: v1.72-7-g8682f63
# XXX-INGY is 5.8.1 too old/broken for utf8?
# XXX-XDG Lancaster consensus was that it was sufficient until
# proven otherwise

our $VERSION = '1.73';

#####################################################################
# The YAML::Tiny API.
#
# These are the currently documented API functions/methods and
# exports:

use Exporter;
our @ISA       = qw{ Exporter  };
our @EXPORT    = qw{ Load Dump };
our @EXPORT_OK = qw{ LoadFile DumpFile freeze thaw };

###
# Functional/Export API:

sub Dump {
    return YAML::Tiny->new(@_)->_dump_string;
}

# XXX-INGY Returning last document seems a bad behavior.
# XXX-XDG I think first would seem more natural, but I don't know
# that it's worth changing now
sub Load {
    my $self = YAML::Tiny->_load_string(@_);
    if ( wantarray ) {
        return @$self;
    } else {
        # To match YAML.pm, return the last document
        return $self->[-1];
    }
}

# XXX-INGY Do we really need freeze and thaw?
# XXX-XDG I don't think so.  I'd support deprecating them.
BEGIN {
    *freeze = \&Dump;
    *thaw   = \&Load;
}

sub DumpFile {
    my $file = shift;
    return YAML::Tiny->new(@_)->_dump_file($file);
}

sub LoadFile {
    my $file = shift;
    my $self = YAML::Tiny->_load_file($file);
    if ( wantarray ) {
        return @$self;
    } else {
        # Return only the last document to match YAML.pm,
        return $self->[-1];
    }
}


###
# Object Oriented API:

# Create an empty YAML::Tiny object
# XXX-INGY Why do we use ARRAY object?
# NOTE: I get it now, but I think it's confusing and not needed.
# Will change it on a branch later, for review.
#
# XXX-XDG I don't support changing it yet.  It's a very well-documented
# "API" of YAML::Tiny.  I'd support deprecating it, but Adam suggested
# we not change it until YAML.pm's own OO API is established so that
# users only have one API change to digest, not two
sub new {
    my $class = shift;
    bless [ @_ ], $class;
}

# XXX-INGY It probably doesn't matter, and it's probably too late to
# change, but 'read/write' are the wrong names. Read and Write
# are actions that take data from storage to memory
# characters/strings. These take the data to/from storage to native
# Perl objects, which the terms dump and load are meant. As long as
# this is a legacy quirk to YAML::Tiny it's ok, but I'd prefer not
# to add new {read,write}_* methods to this API.

sub read_string {
    my $self = shift;
    $self->_load_string(@_);
}

sub write_string {
    my $self = shift;
    $self->_dump_string(@_);
}

sub read {
    my $self = shift;
    $self->_load_file(@_);
}

sub write {
    my $self = shift;
    $self->_dump_file(@_);
}




#####################################################################
# Constants

# Printed form of the unprintable characters in the lowest range
# of ASCII characters, listed by ASCII ordinal position.
my @UNPRINTABLE = qw(
    0    x01  x02  x03  x04  x05  x06  a
    b    t    n    v    f    r    x0E  x0F
    x10  x11  x12  x13  x14  x15  x16  x17
    x18  x19  x1A  e    x1C  x1D  x1E  x1F
);

# Printable characters for escapes
my %UNESCAPES = (
    0 => "\x00", z => "\x00", N    => "\x85",
    a => "\x07", b => "\x08", t    => "\x09",
    n => "\x0a", v => "\x0b", f    => "\x0c",
    r => "\x0d", e => "\x1b", '\\' => '\\',
);

# XXX-INGY
# I(ngy) need to decide if these values should be quoted in
# YAML::Tiny or not. Probably yes.

# These 3 values have special meaning when unquoted and using the
# default YAML schema. They need quotes if they are strings.
my %QUOTE = map { $_ => 1 } qw{
    null true false
};

# The commented out form is simpler, but overloaded the Perl regex
# engine due to recursion and backtracking problems on strings
# larger than 32,000ish characters. Keep it for reference purposes.
# qr/\"((?:\\.|[^\"])*)\"/
my $re_capture_double_quoted = qr/\"([^\\"]*(?:\\.[^\\"]*)*)\"/;
my $re_capture_single_quoted = qr/\'([^\']*(?:\'\'[^\']*)*)\'/;
# unquoted re gets trailing space that needs to be stripped
my $re_capture_unquoted_key  = qr/([^:]+(?::+\S(?:[^:]*|.*?(?=:)))*)(?=\s*\:(?:\s+|$))/;
my $re_trailing_comment      = qr/(?:\s+\#.*)?/;
my $re_key_value_separator   = qr/\s*:(?:\s+(?:\#.*)?|$)/;





#####################################################################
# YAML::Tiny Implementation.
#
# These are the private methods that do all the work. They may change
# at any time.


###
# Loader functions:

# Create an object from a file
sub _load_file {
    my $class = ref $_[0] ? ref shift : shift;

    # Check the file
    my $file = shift or $class->_error( 'You did not specify a file name' );
    $class->_error( "File '$file' does not exist" )
        unless -e $file;
    $class->_error( "'$file' is a directory, not a file" )
        unless -f _;
    $class->_error( "Insufficient permissions to read '$file'" )
        unless -r _;

    # Open unbuffered with strict UTF-8 decoding and no translation layers
    open( my $fh, "<:unix:encoding(UTF-8)", $file );
    unless ( $fh ) {
        $class->_error("Failed to open file '$file': $!");
    }

    # flock if available (or warn if not possible for OS-specific reasons)
    if ( _can_flock() ) {
        flock( $fh, Fcntl::LOCK_SH() )
            or warn "Couldn't lock '$file' for reading: $!";
    }

    # slurp the contents
    my $contents = eval {
        use warnings FATAL => 'utf8';
        local $/;
        <$fh>
    };
    if ( my $err = $@ ) {
        $class->_error("Error reading from file '$file': $err");
    }

    # close the file (release the lock)
    unless ( close $fh ) {
        $class->_error("Failed to close file '$file': $!");
    }

    $class->_load_string( $contents );
}

# Create an object from a string
sub _load_string {
    my $class  = ref $_[0] ? ref shift : shift;
    my $self   = bless [], $class;
    my $string = $_[0];
    eval {
        unless ( defined $string ) {
            die \"Did not provide a string to load";
        }

        # Check if Perl has it marked as characters, but it's internally
        # inconsistent.  E.g. maybe latin1 got read on a :utf8 layer
        if ( utf8::is_utf8($string) && ! utf8::valid($string) ) {
            die \<<'...';
Read an invalid UTF-8 string (maybe mixed UTF-8 and 8-bit character set).
Did you decode with lax ":utf8" instead of strict ":encoding(UTF-8)"?
...
        }

        # Ensure Unicode character semantics, even for 0x80-0xff
        utf8::upgrade($string);

        # Check for and strip any leading UTF-8 BOM
        $string =~ s/^\x{FEFF}//;

        # Check for some special cases
        return $self unless length $string;

        # Split the file into lines
        my @lines = grep { ! /^\s*(?:\#.*)?\z/ }
                split /(?:\015{1,2}\012|\015|\012)/, $string;

        # Strip the initial YAML header
        @lines and $lines[0] =~ /^\%YAML[: ][\d\.]+.*\z/ and shift @lines;

        # A nibbling parser
        my $in_document = 0;
        while ( @lines ) {
            # Do we have a document header?
            if ( $lines[0] =~ /^---\s*(?:(.+)\s*)?\z/ ) {
                # Handle scalar documents
                shift @lines;
                if ( defined $1 and $1 !~ /^(?:\#.+|\%YAML[: ][\d\.]+)\z/ ) {
                    push @$self,
                        $self->_load_scalar( "$1", [ undef ], \@lines );
                    next;
                }
                $in_document = 1;
            }

            if ( ! @lines or $lines[0] =~ /^(?:---|\.\.\.)/ ) {
                # A naked document
                push @$self, undef;
                while ( @lines and $lines[0] !~ /^---/ ) {
                    shift @lines;
                }
                $in_document = 0;

            # XXX The final '-+$' is to look for -- which ends up being an
            # error later.
            } elsif ( ! $in_document && @$self ) {
                # only the first document can be explicit
                die \"YAML::Tiny failed to classify the line '$lines[0]'";
            } elsif ( $lines[0] =~ /^\s*\-(?:\s|$|-+$)/ ) {
                # An array at the root
                my $document = [ ];
                push @$self, $document;
                $self->_load_array( $document, [ 0 ], \@lines );

            } elsif ( $lines[0] =~ /^(\s*)\S/ ) {
                # A hash at the root
                my $document = { };
                push @$self, $document;
                $self->_load_hash( $document, [ length($1) ], \@lines );

            } else {
                # Shouldn't get here.  @lines have whitespace-only lines
                # stripped, and previous match is a line with any
                # non-whitespace.  So this clause should only be reachable via
                # a perlbug where \s is not symmetric with \S

                # uncoverable statement
                die \"YAML::Tiny failed to classify the line '$lines[0]'";
            }
        }
    };
    my $err = $@;
    if ( ref $err eq 'SCALAR' ) {
        $self->_error(${$err});
    } elsif ( $err ) {
        $self->_error($err);
    }

    return $self;
}

sub _unquote_single {
    my ($self, $string) = @_;
    return '' unless length $string;
    $string =~ s/\'\'/\'/g;
    return $string;
}

sub _unquote_double {
    my ($self, $string) = @_;
    return '' unless length $string;
    $string =~ s/\\"/"/g;
    $string =~
        s{\\([Nnever\\fartz0b]|x([0-9a-fA-F]{2}))}
         {(length($1)>1)?pack("H2",$2):$UNESCAPES{$1}}gex;
    return $string;
}

# Load a YAML scalar string to the actual Perl scalar
sub _load_scalar {
    my ($self, $string, $indent, $lines) = @_;

    # Trim trailing whitespace
    $string =~ s/\s*\z//;

    # Explitic null/undef
    return undef if $string eq '~';

    # Single quote
    if ( $string =~ /^$re_capture_single_quoted$re_trailing_comment\z/ ) {
        return $self->_unquote_single($1);
    }

    # Double quote.
    if ( $string =~ /^$re_capture_double_quoted$re_trailing_comment\z/ ) {
        return $self->_unquote_double($1);
    }

    # Special cases
    if ( $string =~ /^[\'\"!&]/ ) {
        die \"YAML::Tiny does not support a feature in line '$string'";
    }
    return {} if $string =~ /^{}(?:\s+\#.*)?\z/;
    return [] if $string =~ /^\[\](?:\s+\#.*)?\z/;

    # Regular unquoted string
    if ( $string !~ /^[>|]/ ) {
        die \"YAML::Tiny found illegal characters in plain scalar: '$string'"
            if $string =~ /^(?:-(?:\s|$)|[\@\%\`])/ or
                $string =~ /:(?:\s|$)/;
        $string =~ s/\s+#.*\z//;
        return $string;
    }

    # Error
    die \"YAML::Tiny failed to find multi-line scalar content" unless @$lines;

    # Check the indent depth
    $lines->[0]   =~ /^(\s*)/;
    $indent->[-1] = length("$1");
    if ( defined $indent->[-2] and $indent->[-1] <= $indent->[-2] ) {
        die \"YAML::Tiny found bad indenting in line '$lines->[0]'";
    }

    # Pull the lines
    my @multiline = ();
    while ( @$lines ) {
        $lines->[0] =~ /^(\s*)/;
        last unless length($1) >= $indent->[-1];
        push @multiline, substr(shift(@$lines), $indent->[-1]);
    }

    my $j = (substr($string, 0, 1) eq '>') ? ' ' : "\n";
    my $t = (substr($string, 1, 1) eq '-') ? ''  : "\n";
    return join( $j, @multiline ) . $t;
}

# Load an array
sub _load_array {
    my ($self, $array, $indent, $lines) = @_;

    while ( @$lines ) {
        # Check for a new document
        if ( $lines->[0] =~ /^(?:---|\.\.\.)/ ) {
            while ( @$lines and $lines->[0] !~ /^---/ ) {
                shift @$lines;
            }
            return 1;
        }

        # Check the indent level
        $lines->[0] =~ /^(\s*)/;
        if ( length($1) < $indent->[-1] ) {
            return 1;
        } elsif ( length($1) > $indent->[-1] ) {
            die \"YAML::Tiny found bad indenting in line '$lines->[0]'";
        }

        if ( $lines->[0] =~ /^(\s*\-\s+)[^\'\"]\S*\s*:(?:\s+|$)/ ) {
            # Inline nested hash
            my $indent2 = length("$1");
            $lines->[0] =~ s/-/ /;
            push @$array, { };
            $self->_load_hash( $array->[-1], [ @$indent, $indent2 ], $lines );

        } elsif ( $lines->[0] =~ /^\s*\-\s*\z/ ) {
            shift @$lines;
            unless ( @$lines ) {
                push @$array, undef;
                return 1;
            }
            if ( $lines->[0] =~ /^(\s*)\-/ ) {
                my $indent2 = length("$1");
                if ( $indent->[-1] == $indent2 ) {
                    # Null array entry
                    push @$array, undef;
                } else {
                    # Naked indenter
                    push @$array, [ ];
                    $self->_load_array(
                        $array->[-1], [ @$indent, $indent2 ], $lines
                    );
                }

            } elsif ( $lines->[0] =~ /^(\s*)\S/ ) {
                push @$array, { };
                $self->_load_hash(
                    $array->[-1], [ @$indent, length("$1") ], $lines
                );

            } else {
                die \"YAML::Tiny failed to classify line '$lines->[0]'";
            }

        } elsif ( $lines->[0] =~ /^\s*\-(\s*)(.+?)\s*\z/ ) {
            # Array entry with a value
            shift @$lines;
            push @$array, $self->_load_scalar(
                "$2", [ @$indent, undef ], $lines
            );

        } elsif ( defined $indent->[-2] and $indent->[-1] == $indent->[-2] ) {
            # This is probably a structure like the following...
            # ---
            # foo:
            # - list
            # bar: value
            #
            # ... so lets return and let the hash parser handle it
            return 1;

        } else {
            die \"YAML::Tiny failed to classify line '$lines->[0]'";
        }
    }

    return 1;
}

# Load a hash
sub _load_hash {
    my ($self, $hash, $indent, $lines) = @_;

    while ( @$lines ) {
        # Check for a new document
        if ( $lines->[0] =~ /^(?:---|\.\.\.)/ ) {
            while ( @$lines and $lines->[0] !~ /^---/ ) {
                shift @$lines;
            }
            return 1;
        }

        # Check the indent level
        $lines->[0] =~ /^(\s*)/;
        if ( length($1) < $indent->[-1] ) {
            return 1;
        } elsif ( length($1) > $indent->[-1] ) {
            die \"YAML::Tiny found bad indenting in line '$lines->[0]'";
        }

        # Find the key
        my $key;

        # Quoted keys
        if ( $lines->[0] =~
            s/^\s*$re_capture_single_quoted$re_key_value_separator//
        ) {
            $key = $self->_unquote_single($1);
        }
        elsif ( $lines->[0] =~
            s/^\s*$re_capture_double_quoted$re_key_value_separator//
        ) {
            $key = $self->_unquote_double($1);
        }
        elsif ( $lines->[0] =~
            s/^\s*$re_capture_unquoted_key$re_key_value_separator//
        ) {
            $key = $1;
            $key =~ s/\s+$//;
        }
        elsif ( $lines->[0] =~ /^\s*\?/ ) {
            die \"YAML::Tiny does not support a feature in line '$lines->[0]'";
        }
        else {
            die \"YAML::Tiny failed to classify line '$lines->[0]'";
        }

        if ( exists $hash->{$key} ) {
            warn "YAML::Tiny found a duplicate key '$key' in line '$lines->[0]'";
        }

        # Do we have a value?
        if ( length $lines->[0] ) {
            # Yes
            $hash->{$key} = $self->_load_scalar(
                shift(@$lines), [ @$indent, undef ], $lines
            );
        } else {
            # An indent
            shift @$lines;
            unless ( @$lines ) {
                $hash->{$key} = undef;
                return 1;
            }
            if ( $lines->[0] =~ /^(\s*)-/ ) {
                $hash->{$key} = [];
                $self->_load_array(
                    $hash->{$key}, [ @$indent, length($1) ], $lines
                );
            } elsif ( $lines->[0] =~ /^(\s*)./ ) {
                my $indent2 = length("$1");
                if ( $indent->[-1] >= $indent2 ) {
                    # Null hash entry
                    $hash->{$key} = undef;
                } else {
                    $hash->{$key} = {};
                    $self->_load_hash(
                        $hash->{$key}, [ @$indent, length($1) ], $lines
                    );
                }
            }
        }
    }

    return 1;
}


###
# Dumper functions:

# Save an object to a file
sub _dump_file {
    my $self = shift;

    require Fcntl;

    # Check the file
    my $file = shift or $self->_error( 'You did not specify a file name' );

    my $fh;
    # flock if available (or warn if not possible for OS-specific reasons)
    if ( _can_flock() ) {
        # Open without truncation (truncate comes after lock)
        my $flags = Fcntl::O_WRONLY()|Fcntl::O_CREAT();
        sysopen( $fh, $file, $flags )
            or $self->_error("Failed to open file '$file' for writing: $!");

        # Use no translation and strict UTF-8
        binmode( $fh, ":raw:encoding(UTF-8)");

        flock( $fh, Fcntl::LOCK_EX() )
            or warn "Couldn't lock '$file' for reading: $!";

        # truncate and spew contents
        truncate $fh, 0;
        seek $fh, 0, 0;
    }
    else {
        open $fh, ">:unix:encoding(UTF-8)", $file;
    }

    # serialize and spew to the handle
    print {$fh} $self->_dump_string;

    # close the file (release the lock)
    unless ( close $fh ) {
        $self->_error("Failed to close file '$file': $!");
    }

    return 1;
}

# Save an object to a string
sub _dump_string {
    my $self = shift;
    return '' unless ref $self && @$self;

    # Iterate over the documents
    my $indent = 0;
    my @lines  = ();

    eval {
        foreach my $cursor ( @$self ) {
            push @lines, '---';

            # An empty document
            if ( ! defined $cursor ) {
                # Do nothing

            # A scalar document
            } elsif ( ! ref $cursor ) {
                $lines[-1] .= ' ' . $self->_dump_scalar( $cursor );

            # A list at the root
            } elsif ( ref $cursor eq 'ARRAY' ) {
                unless ( @$cursor ) {
                    $lines[-1] .= ' []';
                    next;
                }
                push @lines, $self->_dump_array( $cursor, $indent, {} );

            # A hash at the root
            } elsif ( ref $cursor eq 'HASH' ) {
                unless ( %$cursor ) {
                    $lines[-1] .= ' {}';
                    next;
                }
                push @lines, $self->_dump_hash( $cursor, $indent, {} );

            } else {
                die \("Cannot serialize " . ref($cursor));
            }
        }
    };
    if ( ref $@ eq 'SCALAR' ) {
        $self->_error(${$@});
    } elsif ( $@ ) {
        $self->_error($@);
    }

    join '', map { "$_\n" } @lines;
}

sub _has_internal_string_value {
    my $value = shift;
    my $b_obj = B::svref_2object(\$value);  # for round trip problem
    return $b_obj->FLAGS & B::SVf_POK();
}

sub _dump_scalar {
    my $string = $_[1];
    my $is_key = $_[2];
    # Check this before checking length or it winds up looking like a string!
    my $has_string_flag = _has_internal_string_value($string);
    return '~'  unless defined $string;
    return "''" unless length  $string;
    if (Scalar::Util::looks_like_number($string)) {
        # keys and values that have been used as strings get quoted
        if ( $is_key || $has_string_flag ) {
            return qq['$string'];
        }
        else {
            return $string;
        }
    }
    if ( $string =~ /[\x00-\x09\x0b-\x0d\x0e-\x1f\x7f-\x9f\'\n]/ ) {
        $string =~ s/\\/\\\\/g;
        $string =~ s/"/\\"/g;
        $string =~ s/\n/\\n/g;
        $string =~ s/[\x85]/\\N/g;
        $string =~ s/([\x00-\x1f])/\\$UNPRINTABLE[ord($1)]/g;
        $string =~ s/([\x7f-\x9f])/'\x' . sprintf("%X",ord($1))/ge;
        return qq|"$string"|;
    }
    if ( $string =~ /(?:^[~!@#%&*|>?:,'"`{}\[\]]|^-+$|\s|:\z)/ or
        $QUOTE{$string}
    ) {
        return "'$string'";
    }
    return $string;
}

sub _dump_array {
    my ($self, $array, $indent, $seen) = @_;
    if ( $seen->{refaddr($array)}++ ) {
        die \"YAML::Tiny does not support circular references";
    }
    my @lines  = ();
    foreach my $el ( @$array ) {
        my $line = ('  ' x $indent) . '-';
        my $type = ref $el;
        if ( ! $type ) {
            $line .= ' ' . $self->_dump_scalar( $el );
            push @lines, $line;

        } elsif ( $type eq 'ARRAY' ) {
            if ( @$el ) {
                push @lines, $line;
                push @lines, $self->_dump_array( $el, $indent + 1, $seen );
            } else {
                $line .= ' []';
                push @lines, $line;
            }

        } elsif ( $type eq 'HASH' ) {
            if ( keys %$el ) {
                push @lines, $line;
                push @lines, $self->_dump_hash( $el, $indent + 1, $seen );
            } else {
                $line .= ' {}';
                push @lines, $line;
            }

        } else {
            die \"YAML::Tiny does not support $type references";
        }
    }

    @lines;
}

sub _dump_hash {
    my ($self, $hash, $indent, $seen) = @_;
    if ( $seen->{refaddr($hash)}++ ) {
        die \"YAML::Tiny does not support circular references";
    }
    my @lines  = ();
    foreach my $name ( sort keys %$hash ) {
        my $el   = $hash->{$name};
        my $line = ('  ' x $indent) . $self->_dump_scalar($name, 1) . ":";
        my $type = ref $el;
        if ( ! $type ) {
            $line .= ' ' . $self->_dump_scalar( $el );
            push @lines, $line;

        } elsif ( $type eq 'ARRAY' ) {
            if ( @$el ) {
                push @lines, $line;
                push @lines, $self->_dump_array( $el, $indent + 1, $seen );
            } else {
                $line .= ' []';
                push @lines, $line;
            }

        } elsif ( $type eq 'HASH' ) {
            if ( keys %$el ) {
                push @lines, $line;
                push @lines, $self->_dump_hash( $el, $indent + 1, $seen );
            } else {
                $line .= ' {}';
                push @lines, $line;
            }

        } else {
            die \"YAML::Tiny does not support $type references";
        }
    }

    @lines;
}



#####################################################################
# DEPRECATED API methods:

# Error storage (DEPRECATED as of 1.57)
our $errstr    = '';

# Set error
sub _error {
    require Carp;
    $errstr = $_[1];
    $errstr =~ s/ at \S+ line \d+.*//;
    Carp::croak( $errstr );
}

# Retrieve error
my $errstr_warned;
sub errstr {
    require Carp;
    Carp::carp( "YAML::Tiny->errstr and \$YAML::Tiny::errstr is deprecated" )
        unless $errstr_warned++;
    $errstr;
}




#####################################################################
# Helper functions. Possibly not needed.


# Use to detect nv or iv
use B;

# XXX-INGY Is flock YAML::Tiny's responsibility?
# Some platforms can't flock :-(
# XXX-XDG I think it is.  When reading and writing files, we ought
# to be locking whenever possible.  People (foolishly) use YAML
# files for things like session storage, which has race issues.
my $HAS_FLOCK;
sub _can_flock {
    if ( defined $HAS_FLOCK ) {
        return $HAS_FLOCK;
    }
    else {
        require Config;
        my $c = \%Config::Config;
        $HAS_FLOCK = grep { $c->{$_} } qw/d_flock d_fcntl_can_lock d_lockf/;
        require Fcntl if $HAS_FLOCK;
        return $HAS_FLOCK;
    }
}


# XXX-INGY Is this core in 5.8.1? Can we remove this?
# XXX-XDG Scalar::Util 1.18 didn't land until 5.8.8, so we need this
#####################################################################
# Use Scalar::Util if possible, otherwise emulate it

use Scalar::Util ();
BEGIN {
    local $@;
    if ( eval { Scalar::Util->VERSION(1.18); } ) {
        *refaddr = *Scalar::Util::refaddr;
    }
    else {
        eval <<'END_PERL';
# Scalar::Util failed to load or too old
sub refaddr {
    my $pkg = ref($_[0]) or return undef;
    if ( !! UNIVERSAL::can($_[0], 'can') ) {
        bless $_[0], 'Scalar::Util::Fake';
    } else {
        $pkg = undef;
    }
    "$_[0]" =~ /0x(\w+)/;
    my $i = do { no warnings 'portable'; hex $1 };
    bless $_[0], $pkg if defined $pkg;
    $i;
}
END_PERL
    }
}

delete $YAML::Tiny::{refaddr};

1;

# XXX-INGY Doc notes I'm putting up here. Changing the doc when it's wrong
# but leaving grey area stuff up here.
#
# I would like to change Read/Write to Load/Dump below without
# changing the actual API names.
#
# It might be better to put Load/Dump API in the SYNOPSIS instead of the
# dubious OO API.
#
# null and bool explanations may be outdated.

__END__

=pod

=head1 NAME

YAML::Tiny - Read/Write YAML files with as little code as possible

=head1 VERSION

version 1.73

=head1 PREAMBLE

The YAML specification is huge. Really, B<really> huge. It contains all the
functionality of XML, except with flexibility and choice, which makes it
easier to read, but with a formal specification that is more complex than
XML.

The original pure-Perl implementation L<YAML> costs just over 4 megabytes
of memory to load. Just like with Windows F<.ini> files (3 meg to load) and
CSS (3.5 meg to load) the situation is just asking for a B<YAML::Tiny>
module, an incomplete but correct and usable subset of the functionality,
in as little code as possible.

Like the other C<::Tiny> modules, YAML::Tiny has no non-core dependencies,
does not require a compiler to install, is back-compatible to Perl v5.8.1,
and can be inlined into other modules if needed.

In exchange for this adding this extreme flexibility, it provides support
for only a limited subset of YAML. But the subset supported contains most
of the features for the more common uses of YAML.

=head1 SYNOPSIS

Assuming F<file.yml> like this:

    ---
    rootproperty: blah
    section:
      one: two
      three: four
      Foo: Bar
      empty: ~


Read and write F<file.yml> like this:

    use YAML::Tiny;

    # Open the config
    my $yaml = YAML::Tiny->read( 'file.yml' );

    # Get a reference to the first document
    my $config = $yaml->[0];

    # Or read properties directly
    my $root = $yaml->[0]->{rootproperty};
    my $one  = $yaml->[0]->{section}->{one};
    my $Foo  = $yaml->[0]->{section}->{Foo};

    # Change data directly
    $yaml->[0]->{newsection} = { this => 'that' }; # Add a section
    $yaml->[0]->{section}->{Foo} = 'Not Bar!';     # Change a value
    delete $yaml->[0]->{section};                  # Delete a value

    # Save the document back to the file
    $yaml->write( 'file.yml' );

To create a new YAML file from scratch:

    # Create a new object with a single hashref document
    my $yaml = YAML::Tiny->new( { wibble => "wobble" } );

    # Add an arrayref document
    push @$yaml, [ 'foo', 'bar', 'baz' ];

    # Save both documents to a file
    $yaml->write( 'data.yml' );

Then F<data.yml> will contain:

    ---
    wibble: wobble
    ---
    - foo
    - bar
    - baz

=head1 DESCRIPTION

B<YAML::Tiny> is a perl class for reading and writing YAML-style files,
written with as little code as possible, reducing load time and memory
overhead.

Most of the time it is accepted that Perl applications use a lot
of memory and modules. The B<::Tiny> family of modules is specifically
intended to provide an ultralight and zero-dependency alternative to
many more-thorough standard modules.

This module is primarily for reading human-written files (like simple
config files) and generating very simple human-readable files. Note that
I said B<human-readable> and not B<geek-readable>. The sort of files that
your average manager or secretary should be able to look at and make
sense of.

=for stopwords normalise

L<YAML::Tiny> does not generate comments, it won't necessarily preserve the
order of your hashes, and it will normalise if reading in and writing out
again.

It only supports a very basic subset of the full YAML specification.

=for stopwords embeddable

Usage is targeted at files like Perl's META.yml, for which a small and
easily-embeddable module is extremely attractive.

Features will only be added if they are human readable, and can be written
in a few lines of code. Please don't be offended if your request is
refused. Someone has to draw the line, and for YAML::Tiny that someone
is me.

If you need something with more power move up to L<YAML> (7 megabytes of
memory overhead) or L<YAML::XS> (6 megabytes memory overhead and requires
a C compiler).

To restate, L<YAML::Tiny> does B<not> preserve your comments, whitespace,
or the order of your YAML data. But it should round-trip from Perl
structure to file and back again just fine.

=head1 METHODS

=for Pod::Coverage HAVE_UTF8 refaddr

=head2 new

The constructor C<new> creates a C<YAML::Tiny> object as a blessed array
reference.  Any arguments provided are taken as separate documents
to be serialized.

=head2 read $filename

The C<read> constructor reads a YAML file from a file name,
and returns a new C<YAML::Tiny> object containing the parsed content.

Returns the object on success or throws an error on failure.

=head2 read_string $string;

The C<read_string> constructor reads YAML data from a character string, and
returns a new C<YAML::Tiny> object containing the parsed content.  If you have
read the string from a file yourself, be sure that you have correctly decoded
it into characters first.

Returns the object on success or throws an error on failure.

=head2 write $filename

The C<write> method generates the file content for the properties, and
writes it to disk using UTF-8 encoding to the filename specified.

Returns true on success or throws an error on failure.

=head2 write_string

Generates the file content for the object and returns it as a character
string.  This may contain non-ASCII characters and should be encoded
before writing it to a file.

Returns true on success or throws an error on failure.

=for stopwords errstr

=head2 errstr (DEPRECATED)

Prior to version 1.57, some errors were fatal and others were available only
via the C<$YAML::Tiny::errstr> variable, which could be accessed via the
C<errstr()> method.

Starting with version 1.57, all errors are fatal and throw exceptions.

The C<$errstr> variable is still set when exceptions are thrown, but
C<$errstr> and the C<errstr()> method are deprecated and may be removed in a
future release.  The first use of C<errstr()> will issue a deprecation
warning.

=head1 FUNCTIONS

YAML::Tiny implements a number of functions to add compatibility with
the L<YAML> API. These should be a drop-in replacement.

=head2 Dump

  my $string = Dump(list-of-Perl-data-structures);

Turn Perl data into YAML. This function works very much like
Data::Dumper::Dumper().

It takes a list of Perl data structures and dumps them into a serialized
form.

It returns a character string containing the YAML stream.  Be sure to encode
it as UTF-8 before serializing to a file or socket.

The structures can be references or plain scalars.

Dies on any error.

=head2 Load

  my @data_structures = Load(string-containing-a-YAML-stream);

Turn YAML into Perl data. This is the opposite of Dump.

Just like L<Storable>'s thaw() function or the eval() function in relation
to L<Data::Dumper>.

It parses a character string containing a valid YAML stream into a list of
Perl data structures representing the individual YAML documents.  Be sure to
decode the character string  correctly if the string came from a file or
socket.

  my $last_data_structure = Load(string-containing-a-YAML-stream);

For consistency with YAML.pm, when Load is called in scalar context, it
returns the data structure corresponding to the last of the YAML documents
found in the input stream.

Dies on any error.

=head2 freeze() and thaw()

Aliases to Dump() and Load() for L<Storable> fans. This will also allow
YAML::Tiny to be plugged directly into modules like POE.pm, that use the
freeze/thaw API for internal serialization.

=head2 DumpFile(filepath, list)

Writes the YAML stream to a file with UTF-8 encoding instead of just
returning a string.

Dies on any error.

=head2 LoadFile(filepath)

Reads the YAML stream from a UTF-8 encoded file instead of a string.

Dies on any error.

=head1 YAML TINY SPECIFICATION

This section of the documentation provides a specification for "YAML Tiny",
a subset of the YAML specification.

It is based on and described comparatively to the YAML 1.1 Working Draft
2004-12-28 specification, located at L<http://yaml.org/spec/current.html>.

Terminology and chapter numbers are based on that specification.

=head2 1. Introduction and Goals

The purpose of the YAML Tiny specification is to describe a useful subset
of the YAML specification that can be used for typical document-oriented
use cases such as configuration files and simple data structure dumps.

=for stopwords extensibility

Many specification elements that add flexibility or extensibility are
intentionally removed, as is support for complex data structures, class
and object-orientation.

In general, the YAML Tiny language targets only those data structures
available in JSON, with the additional limitation that only simple keys
are supported.

As a result, all possible YAML Tiny documents should be able to be
transformed into an equivalent JSON document, although the reverse is
not necessarily true (but will be true in simple cases).

=for stopwords PCRE

As a result of these simplifications the YAML Tiny specification should
be implementable in a (relatively) small amount of code in any language
that supports Perl Compatible Regular Expressions (PCRE).

=head2 2. Introduction

YAML Tiny supports three data structures. These are scalars (in a variety
of forms), block-form sequences and block-form mappings. Flow-style
sequences and mappings are not supported, with some minor exceptions
detailed later.

The use of three dashes "---" to indicate the start of a new document is
supported, and multiple documents per file/stream is allowed.

Both line and inline comments are supported.

Scalars are supported via the plain style, single quote and double quote,
as well as literal-style and folded-style multi-line scalars.

The use of explicit tags is not supported.

The use of "null" type scalars is supported via the ~ character.

The use of "bool" type scalars is not supported.

=for stopwords serializer

However, serializer implementations should take care to explicitly escape
strings that match a "bool" keyword in the following set to prevent other
implementations that do support "bool" accidentally reading a string as a
boolean

  y|Y|yes|Yes|YES|n|N|no|No|NO
  |true|True|TRUE|false|False|FALSE
  |on|On|ON|off|Off|OFF

The use of anchors and aliases is not supported.

The use of directives is supported only for the %YAML directive.

=head2 3. Processing YAML Tiny Information

B<Processes>

=for stopwords deserialization

The YAML specification dictates three-phase serialization and three-phase
deserialization.

The YAML Tiny specification does not mandate any particular methodology
or mechanism for parsing.

Any compliant parser is only required to parse a single document at a
time. The ability to support streaming documents is optional and most
likely non-typical.

=for stopwords acyclic

Because anchors and aliases are not supported, the resulting representation
graph is thus directed but (unlike the main YAML specification) B<acyclic>.

Circular references/pointers are not possible, and any YAML Tiny serializer
detecting a circular reference should error with an appropriate message.

B<Presentation Stream>

=for stopwords unicode

YAML Tiny reads and write UTF-8 encoded files.  Operations on strings expect
or produce Unicode characters not UTF-8 encoded bytes.

B<Loading Failure Points>

=for stopwords modality

=for stopwords parsers

YAML Tiny parsers and emitters are not expected to recover from, or
adapt to, errors. The specific error modality of any implementation is
not dictated (return codes, exceptions, etc.) but is expected to be
consistent.

=head2 4. Syntax

B<Character Set>

YAML Tiny streams are processed in memory as Unicode characters and
read/written with UTF-8 encoding.

The escaping and unescaping of the 8-bit YAML escapes is required.

The escaping and unescaping of 16-bit and 32-bit YAML escapes is not
required.

B<Indicator Characters>

Support for the "~" null/undefined indicator is required.

Implementations may represent this as appropriate for the underlying
language.

Support for the "-" block sequence indicator is required.

Support for the "?" mapping key indicator is B<not> required.

Support for the ":" mapping value indicator is required.

Support for the "," flow collection indicator is B<not> required.

Support for the "[" flow sequence indicator is B<not> required, with
one exception (detailed below).

Support for the "]" flow sequence indicator is B<not> required, with
one exception (detailed below).

Support for the "{" flow mapping indicator is B<not> required, with
one exception (detailed below).

Support for the "}" flow mapping indicator is B<not> required, with
one exception (detailed below).

Support for the "#" comment indicator is required.

Support for the "&" anchor indicator is B<not> required.

Support for the "*" alias indicator is B<not> required.

Support for the "!" tag indicator is B<not> required.

Support for the "|" literal block indicator is required.

Support for the ">" folded block indicator is required.

Support for the "'" single quote indicator is required.

Support for the """ double quote indicator is required.

Support for the "%" directive indicator is required, but only
for the special case of a %YAML version directive before the
"---" document header, or on the same line as the document header.

For example:

  %YAML 1.1
  ---
  - A sequence with a single element

Special Exception:

To provide the ability to support empty sequences
and mappings, support for the constructs [] (empty sequence) and {}
(empty mapping) are required.

For example,

  %YAML 1.1
  # A document consisting of only an empty mapping
  --- {}
  # A document consisting of only an empty sequence
  --- []
  # A document consisting of an empty mapping within a sequence
  - foo
  - {}
  - bar

B<Syntax Primitives>

Other than the empty sequence and mapping cases described above, YAML Tiny
supports only the indentation-based block-style group of contexts.

All five scalar contexts are supported.

Indentation spaces work as per the YAML specification in all cases.

Comments work as per the YAML specification in all simple cases.
Support for indented multi-line comments is B<not> required.

Separation spaces work as per the YAML specification in all cases.

B<YAML Tiny Character Stream>

The only directive supported by the YAML Tiny specification is the
%YAML language/version identifier. Although detected, this directive
will have no control over the parsing itself.

=for stopwords recognise

The parser must recognise both the YAML 1.0 and YAML 1.1+ formatting
of this directive (as well as the commented form, although no explicit
code should be needed to deal with this case, being a comment anyway)

That is, all of the following should be supported.

  --- #YAML:1.0
  - foo

  %YAML:1.0
  ---
  - foo

  % YAML 1.1
  ---
  - foo

Support for the %TAG directive is B<not> required.

Support for additional directives is B<not> required.

Support for the document boundary marker "---" is required.

Support for the document boundary market "..." is B<not> required.

If necessary, a document boundary should simply by indicated with a
"---" marker, with not preceding "..." marker.

Support for empty streams (containing no documents) is required.

Support for implicit document starts is required.

That is, the following must be equivalent.

 # Full form
 %YAML 1.1
 ---
 foo: bar

 # Implicit form
 foo: bar

B<Nodes>

Support for nodes optional anchor and tag properties is B<not> required.

Support for node anchors is B<not> required.

Support for node tags is B<not> required.

Support for alias nodes is B<not> required.

Support for flow nodes is B<not> required.

Support for block nodes is required.

B<Scalar Styles>

Support for all five scalar styles is required as per the YAML
specification, although support for quoted scalars spanning more
than one line is B<not> required.

Support for multi-line scalar documents starting on the header
is not required.

Support for the chomping indicators on multi-line scalar styles
is required.

B<Collection Styles>

Support for block-style sequences is required.

Support for flow-style sequences is B<not> required.

Support for block-style mappings is required.

Support for flow-style mappings is B<not> required.

Both sequences and mappings should be able to be arbitrarily
nested.

Support for plain-style mapping keys is required.

Support for quoted keys in mappings is B<not> required.

Support for "?"-indicated explicit keys is B<not> required.

=for stopwords endeth

Here endeth the specification.

=head2 Additional Perl-Specific Notes

For some Perl applications, it's important to know if you really have a
number and not a string.

That is, in some contexts is important that 3 the number is distinctive
from "3" the string.

Because even Perl itself is not trivially able to understand the difference
(certainly without XS-based modules) Perl implementations of the YAML Tiny
specification are not required to retain the distinctiveness of 3 vs "3".

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=YAML-Tiny>

=begin html

For other issues, or commercial enhancement or support, please contact
<a href="http://ali.as/">Adam Kennedy</a> directly.

=end html

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 SEE ALSO

=over 4

=item * L<YAML>

=item * L<YAML::Syck>

=item * L<Config::Tiny>

=item * L<CSS::Tiny>

=item * L<http://use.perl.org/use.perl.org/_Alias/journal/29427.html>

=item * L<http://ali.as/>

=back

=head1 COPYRIGHT

Copyright 2006 - 2013 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
