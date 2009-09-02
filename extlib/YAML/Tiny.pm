package YAML::Tiny;

use 5.005;
use strict;

use vars qw{$VERSION @ISA @EXPORT_OK $errstr};
BEGIN {
	$VERSION = '1.12';
	$errstr  = '';

	require Exporter;
	@ISA       = qw{ Exporter  };
	@EXPORT_OK = qw{
		Load     Dump
		LoadFile DumpFile
		freeze   thaw
		};
}

# Create the main error hash
my %ERROR = (
	YAML_PARSE_ERR_NO_FINAL_NEWLINE => "Stream does not end with newline character",
	
);

my %NO = (
	'%' => 'YAML::Tiny does not support directives',
	'&' => 'YAML::Tiny does not support anchors',
	'*' => 'YAML::Tiny does not support aliases',
	'?' => 'YAML::Tiny does not support explicit mapping keys',
	':' => 'YAML::Tiny does not support explicit mapping values',
	'!' => 'YAML::Tiny does not support explicit tags',
);

my $ESCAPE_CHAR = '[\\x00-\\x08\\x0b-\\x0d\\x0e-\\x1f\"\n]';

# Escapes for unprintable characters
my @UNPRINTABLE = qw(z    x01  x02  x03  x04  x05  x06  a
                     x08  t    n    v    f    r    x0e  x0f
                     x10  x11  x12  x13  x14  x15  x16  x17
                     x18  x19  x1a  e    x1c  x1d  x1e  x1f
                    );

# Printable characters for escapes
my %UNESCAPES = (
	z => "\x00", a => "\x07", t    => "\x09",
	n => "\x0a", v => "\x0b", f    => "\x0c",
	r => "\x0d", e => "\x1b", '\\' => '\\',
	);

# Create an empty YAML::Tiny object
sub new {
	my $class = shift;
	bless [ @_ ], $class;
}

# Create an object from a file
sub read {
	my $class = ref $_[0] ? ref shift : shift;

	# Check the file
	my $file = shift or return $class->_error( 'You did not specify a file name' );
	return $class->_error( "File '$file' does not exist" )              unless -e $file;
	return $class->_error( "'$file' is a directory, not a file" )       unless -f _;
	return $class->_error( "Insufficient permissions to read '$file'" ) unless -r _;

	# Slurp in the file
	local $/ = undef;
	open CFG, $file or return $class->_error( "Failed to open file '$file': $!" );
	my $contents = <CFG>;
	close CFG;

	$class->read_string( $contents );
}

# Create an object from a string
sub read_string {
	my $class = ref $_[0] ? ref shift : shift;
	my $self  = bless [], $class;

	# Handle special cases
	return undef unless defined $_[0];
	return $self unless length $_[0];
	unless ( $_[0] =~ /[\012\015]+$/ ) {
		return $class->_error('YAML_PARSE_ERR_NO_FINAL_NEWLINE');
	}

	# Split the file into lines
	my @lines = grep { ! /^\s*(?:\#.*)?$/ }
	            split /(?:\015{1,2}\012|\015|\012)/, shift;

	# A nibbling parser
	while ( @lines ) {
		# Do we have a document header?
		if ( $lines[0] =~ /^---\s*(?:(.+)\s*)?$/ ) {
			# Handle scalar documents
			shift @lines;
			if ( defined $1 and $1 !~ /^[#%]YAML:[\d\.]+$/ ) {
				push @$self, $self->_read_scalar( "$1", [ undef ], \@lines );
				next;
			}
		}

		if ( ! @lines or $lines[0] =~ /^---\s*(?:(.+)\s*)?$/ ) {
			# A naked document
			push @$self, undef;

		} elsif ( $lines[0] =~ /^\s*\-/ ) {
			# An array at the root
			my $document = [ ];
			push @$self, $document;
			$self->_read_array( $document, [ 0 ], \@lines );

		} elsif ( $lines[0] =~ /^(\s*)\w/ ) {
			# A hash at the root
			my $document = { };
			push @$self, $document;
			$self->_read_hash( $document, [ length($1) ], \@lines );

		} else {
			die "CODE INCOMPLETE";
		}
	}

	$self;
}

sub _check_support {
	# Check if we support the next char
	my $errstr = $NO{substr($_[1], 0, 1)};
	Carp::croak($errstr) if $errstr;
}

# Deparse a scalar string to the actual scalar
sub _read_scalar {
	my ($self, $string, $indent, $lines) = @_;

	# Trim trailing whitespace
	$string =~ s/\s*$//;

	# Explitic null/undef
	return undef if $string eq '~';

	# Quotes
	if ( $string =~ /^'(.*?)'$/ ) {
		return '' unless defined $1;
		my $rv = $1;
		$rv =~ s/''/'/g;
		return $rv;
	}
	if ( $string =~ /^"((?:\\.|[^"])*)"$/ ) {
		my $str = $1;
		$str =~ s/\\"/"/g;
		$str =~ s/\\([never\\fartz]|x([0-9a-fA-F]{2}))/(length($1)>1)?pack("H2",$2):$UNESCAPES{$1}/gex;
		return $str;
	}
	if ( $string =~ /^['"]/ ) {
		# A quote with folding... we don't support that
		die "YAML::Tiny does not support multi-line quoted scalars";
	}

	# Null hash and array
	if ( $string eq '{}' ) {
		# Null hash
		return {};		
	}
	if ( $string eq '[]' ) {
		# Null array
		return [];
	}

	# Regular unquoted string
	return $string unless $string =~ /^[>|]/;

	# Error
	die "Multi-line scalar content missing" unless @$lines;

	# Check the indent depth
	$lines->[0] =~ /^(\s*)/;
	$indent->[-1] = length("$1");
	if ( defined $indent->[-2] and $indent->[-1] <= $indent->[-2] ) {
		die "Illegal line indenting";
	}

	# Pull the lines
	my @multiline = ();
	while ( @$lines ) {
		$lines->[0] =~ /^(\s*)/;
		last unless length($1) >= $indent->[-1];
		push @multiline, substr(shift(@$lines), length($1));
	}

	my $j = (substr($string, 0, 1) eq '>') ? ' ' : "\n";
	my $t = (substr($string, 1, 1) eq '-') ? '' : "\n";
	return join( $j, @multiline ) . $t;
}

# Parse an array
sub _read_array {
	my ($self, $array, $indent, $lines) = @_;

	while ( @$lines ) {
		# Check for a new document
		return 1 if $lines->[0] =~ /^---\s*(?:(.+)\s*)?$/;

		# Check the indent level
		$lines->[0] =~ /^(\s*)/;
		if ( length($1) < $indent->[-1] ) {
			return 1;
		} elsif ( length($1) > $indent->[-1] ) {
			die "Hash line over-indented";
		}

		if ( $lines->[0] =~ /^(\s*\-\s+)[^'"]\S*\s*:(?:\s+|$)/ ) {
			# Inline nested hash
			my $indent2 = length("$1");
			$lines->[0] =~ s/-/ /;
			push @$array, { };
			$self->_read_hash( $array->[-1], [ @$indent, $indent2 ], $lines );

		} elsif ( $lines->[0] =~ /^\s*\-(\s*)(.+?)\s*$/ ) {
			# Array entry with a value
			shift @$lines;
			push @$array, $self->_read_scalar( "$2", [ @$indent, undef ], $lines );

		} elsif ( $lines->[0] =~ /^\s*\-\s*$/ ) {
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
					$self->_read_array( $array->[-1], [ @$indent, $indent2 ], $lines );
				}

			} elsif ( $lines->[0] =~ /^(\s*)\w/ ) {
				push @$array, { };
				$self->_read_hash( $array->[-1], [ @$indent, length("$1") ], $lines );

			} else {
				die "CODE INCOMPLETE";
			}

		} else {
			die "CODE INCOMPLETE";
		}
	}

	return 1;
}

# Parse an array
sub _read_hash {
	my ($self, $hash, $indent, $lines) = @_;

	while ( @$lines ) {
		# Check for a new document
		return 1 if $lines->[0] =~ /^---\s*(?:(.+)\s*)?$/;

		# Check the indent level
		$lines->[0] =~/^(\s*)/;
		if ( length($1) < $indent->[-1] ) {
			return 1;
		} elsif ( length($1) > $indent->[-1] ) {
			die "Hash line over-indented";
		}

		# Get the key
		unless ( $lines->[0] =~ s/^\s*([^'"][^\n]*?)\s*:(\s+|$)// ) {
			die "Bad hash line";
		}
		my $key = $1;

		# Do we have a value?
		if ( length $lines->[0] ) {
			# Yes
			$hash->{$key} = $self->_read_scalar( shift(@$lines), [ @$indent, undef ], $lines );
		} else {
			# An indent
			shift @$lines;
			unless ( @$lines ) {
				$hash->{$key} = undef;
				return 1;
			}
			if ( $lines->[0] =~ /^(\s*)-/ ) {
				$hash->{$key} = [];
				$self->_read_array( $hash->{$key}, [ @$indent, length($1) ], $lines );
			} elsif ( $lines->[0] =~ /^(\s*)./ ) {
				my $indent2 = length("$1");
				if ( $indent->[-1] >= $indent2 ) {
					# Null hash entry
					$hash->{$key} = undef;
				} else {
					$hash->{$key} = {};
					$self->_read_hash( $hash->{$key}, [ @$indent, length($1) ], $lines );
				}
			}
		}
	}

	return 1;
}

# Save an object to a file
sub write {
	my $self = shift;
	my $file = shift or return $self->_error(
		'No file name provided'
		);

	# Write it to the file
	open( CFG, '>' . $file ) or return $self->_error(
		"Failed to open file '$file' for writing: $!"
		);
	print CFG $self->write_string;
	close CFG;
}

# Save an object to a string
sub write_string {
	my $self = shift;
	return '' unless @$self;

	# Iterate over the documents
	my $indent = 0;
	my @lines  = ();
	foreach my $cursor ( @$self ) {
		push @lines, '---';

		# An empty document
		if ( ! defined $cursor ) {
			# Do nothing

		# A scalar document
		} elsif ( ! ref $cursor ) {
			$lines[-1] .= ' ' . $self->_write_scalar( $cursor );

		# A list at the root
		} elsif ( ref $cursor eq 'ARRAY' ) {
			push @lines, $self->_write_array( $indent, $cursor );

		# A hash at the root
		} elsif ( ref $cursor eq 'HASH' ) {
			push @lines, $self->_write_hash( $indent, $cursor );

		} else {
			die "CODE INCOMPLETE";
		}
	}

	join '', map { "$_\n" } @lines;
}

sub _write_scalar {
	my $str = $_[1];
	return '~'  unless defined $str;
	if ( $str =~ /$ESCAPE_CHAR/ ) {
		$str =~ s/\\/\\\\/g;
		$str =~ s/"/\\"/g;
		$str =~ s/\n/\\n/g;
		$str =~ s/([\x00-\x1f])/\\$UNPRINTABLE[ord($1)]/ge;
		return qq{"$str"};
	}
	if ( length($str) == 0 or $str =~ /\s/ ) {
		$str =~ s/'/''/;
		return "'$str'";
	}
	return $str;
}

sub _write_array {
	my ($self, $indent, $array) = @_;
	my @lines  = ();
	foreach my $el ( @$array ) {
		my $line = ('  ' x $indent) . '-';
		if ( ! ref $el ) {
			$line .= ' ' . $self->_write_scalar( $el );
			push @lines, $line;

		} elsif ( ref $el eq 'ARRAY' ) {
			if ( @$el ) {
				push @lines, $line;
				push @lines, $self->_write_array( $indent + 1, $el );
			} else {
				$line .= ' []';
				push @lines, $line;
			}

		} elsif ( ref $el eq 'HASH' ) {
			if ( keys %$el ) {
				push @lines, $line;
				push @lines, $self->_write_hash( $indent + 1, $el );
			} else {
				$line .= ' {}';
				push @lines, $line;
			}

		} else {
			die "CODE INCOMPLETE";
		}
	}

	@lines;
}

sub _write_hash {
	my ($self, $indent, $hash) = @_;
	my @lines  = ();
	foreach my $name ( sort keys %$hash ) {
		my $el   = $hash->{$name};
		my $line = ('  ' x $indent) . "$name:";
		if ( ! ref $el ) {
			$line .= ' ' . $self->_write_scalar( $el );
			push @lines, $line;

		} elsif ( ref $el eq 'ARRAY' ) {
			if ( @$el ) {
				push @lines, $line;
				push @lines, $self->_write_array( $indent + 1, $el );
			} else {
				$line .= ' []';
				push @lines, $line;
			}

		} elsif ( ref $el eq 'HASH' ) {
			if ( keys %$el ) {
				push @lines, $line;
				push @lines, $self->_write_hash( $indent + 1, $el );
			} else {
				$line .= ' {}';
				push @lines, $line;
			}

		} else {
			die "CODE INCOMPLETE";
		}
	}

	@lines;
}

# Set error
sub _error {
	$errstr = $ERROR{$_[1]} ? "$ERROR{$_[1]} ($_[1])" : $_[1];
	undef;
}

# Retrieve error
sub errstr {
	$errstr;
}





#####################################################################
# YAML Compatibility

sub Dump {
	YAML::Tiny->new(@_)->write_string;
}

sub Load {
	my $self = YAML::Tiny->read_string(@_)
		or Carp::croak("Failed to load YAML document from string");
	return @$self;	
}

BEGIN {
	*freeze = *Dump;
	*thaw   = *Load;
}

sub DumpFile {
	my $file = shift;
	YAML::Tiny->new(@_)->write($file);
}

sub LoadFile {
	my $self = YAML::Tiny->read($_[0])
		or Carp::croak("Failed to load YAML document from '" . ($_[0] || '') . "'");
	return @$self;
}

1;

__END__

=pod

=head1 NAME

YAML::Tiny - Read/Write YAML files with as little code as possible

=head1 PREAMBLE

The YAML specification is huge. Like, B<really> huge. It contains all the
functionality of XML, except with flexibility and choice, which makes it
easier to read, but with a full specification that is more complex than XML.

The pure-Perl implementation L<YAML> costs just over 4 megabytes of memory
to load. Just like with Windows .ini files (3 meg to load) and CSS (3.5 meg
to load) the situation is just asking for a B<YAML::Tiny> module, an
incomplete but correct and usable subset of the functionality, in as little
code as possible.

Like the other C<::Tiny> modules, YAML::Tiny will have no non-core
dependencies, not require a compiler, and be back-compatible to at least
perl 5.005_03, and ideally 5.004.

=head1 SYNOPSIS

    #############################################
    # In your file
    
    ---
    rootproperty: blah
    section:
      one: two
      three: four
      Foo: Bar
      empty: ~
    
    
    
    #############################################
    # In your program
    
    use YAML::Tiny;
    
    # Create a YAML file
    my $yaml = YAML::Tiny->new;
    
    # Open the config
    $yaml = YAML::Tiny->read( 'file.yml' );
    
    # Reading properties
    my $root = $yaml->[0]->{rootproperty};
    my $one  = $yaml->[0]->{section}->{one};
    my $Foo  = $yaml->[0]->{section}->{Foo};
    
    # Changing data
    $yaml->[0]->{newsection} = { this => 'that' }; # Add a section
    $yaml->[0]->{section}->{Foo} = 'Not Bar!';     # Change a value
    delete $yaml->[0]->{section};                  # Delete a value or section
    
    # Add an entire document
    $yaml->[1] = [ 'foo', 'bar', 'baz' ];
    
    # Save the file
    $yaml->write( 'file.conf' );

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

L<YAML::Tiny> does not generate comments, it won't necesarily preserve the
order of your hashes, and it will normalise if reading in and writing out
again.

It only supports a very basic subset of the full YAML specification.

Usage is targetted at files like Perl's META.yml, for which a small and
easily-embeddable module is extremely attractive.

Features will only be added if they are human readable, and can be written
in a few lines of code. Please don't be offended if your request is
refused. Someone has to draw the line, and for YAML::Tiny that someone is me.

If you need something with more power move up to L<YAML> (4 megabytes of
memory overhead) or L<YAML::Syck> (275k, but requires libsyck and a C
compiler).

To restate, L<YAML::Tiny> does B<not> preserve your comments, whitespace, or
the order of your YAML data. But it should round-trip from Perl structure
to file and back again just fine.

=head1 METHODS

=head2 new

The constructor C<new> creates and returns an empty C<YAML::Tiny> object.

=head2 read $filename

The C<read> constructor reads a YAML file, and returns a new
C<YAML::Tiny> object containing the contents of the file. 

Returns the object on success, or C<undef> on error.

When C<read> fails, C<YAML::Tiny> sets an error message internally
you can recover via C<YAML::Tiny-E<gt>errstr>. Although in B<some>
cases a failed C<read> will also set the operating system error
variable C<$!>, not all errors do and you should not rely on using
the C<$!> variable.

=head2 read_string $string;

The C<read_string> method takes as argument the contents of a YAML file
(a YAML document) as a string and returns the C<YAML::Tiny> object for
it.

=head2 write $filename

The C<write> method generates the file content for the properties, and
writes it to disk to the filename specified.

Returns true on success or C<undef> on error.

=head2 write_string

Generates the file content for the object and returns it as a string.

=head2 errstr

When an error occurs, you can retrieve the error message either from the
C<$YAML::Tiny::errstr> variable, or using the C<errstr()> method.

=head1 FUNCTIONS

YAML::Tiny implements a number of functions to add compatibility with
the L<YAML> API. These should be a drop-in replacement, except that
YAML::Tiny will B<not> export functions by default, and so you will need
to explicitly import the functions.

=head2 Dump

  my $string = Dump(list-of-Perl-data-structures);

Turn Perl data into YAML. This function works very much like Data::Dumper::Dumper().

It takes a list of Perl data strucures and dumps them into a serialized form.

It returns a string containing the YAML stream.

The structures can be references or plain scalars.

=head2 Load

  my @documents = Load(string-containing-a-YAML-stream);

Turn YAML into Perl data. This is the opposite of Dump.

Just like L<Storable>'s thaw() function or the eval() function in relation
to L<Data::Dumper>.

It parses a string containing a valid YAML stream into a list of Perl data
structures.

=head2 freeze() and thaw()

Aliases to Dump() and Load() for L<Storable> fans. This will also allow
YAML::Tiny to be plugged directly into modules like POE.pm, that use the
freeze/thaw API for internal serialization.

=head2 DumpFile(filepath, list)

Writes the YAML stream to a file instead of just returning a string.

=head2 LoadFile(filepath)

Reads the YAML stream from a file instead of a string.

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

L<YAML>, L<YAML::Syck>, L<Config::Tiny>, L<CSS::Tiny>,
L<http://use.perl.org/~Alias/journal/29427>, L<http://ali.as/>

=head1 COPYRIGHT

Copyright 2006 - 2007 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
