# Copyrights 1999-2021 by [Mark Overmeer <markov@cpan.org>].
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.02.
# This code is part of distribution MIME::Types.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package MIME::Types;
use vars '$VERSION';
$VERSION = '2.22';


use strict;

use MIME::Type     ();
use File::Spec     ();
use File::Basename qw(dirname);
use List::Util     qw(first);


my %typedb;
sub new(@) { (bless {}, shift)->init( {@_} ) }

sub init($)
{   my ($self, $args) = @_;
    keys %typedb or $self->_read_db($args);
    $self;
}

sub _read_db($)
{   my ($self, $args)   = @_;
    my $skip_extensions = $args->{skip_extensions};
    my $only_complete   = $args->{only_complete};
    my $only_iana       = $args->{only_iana};

    my $db              = $ENV{PERL_MIME_TYPE_DB}
      || $args->{db_file}
      || File::Spec->catfile(dirname(__FILE__), 'types.db');

    local *DB;
    open DB, '<:encoding(utf8)', $db
       or die "cannot open type database in $db: $!\n";

    while(1)
    {   my $header = <DB>;
        defined $header or last;
        chomp $header;

        # This logic is entangled with the bin/collect_types script
        my ($count, $major, $is_iana, $has_ext) = split /\:/, $header;
        my $skip_section = $major eq 'EXTENSIONS' ? $skip_extensions
          : (($only_iana && !$is_iana) || ($only_complete && !$has_ext));

#warn "Skipping section $header\n" if $skip_section;
        (my $section = $major) =~ s/^x-//;
        if($major eq 'EXTENSIONS')
        {   local $_;
            while(<DB>)
            {   last if m/^$/;
                next if $skip_section;
                chomp;
                $typedb{$section}{$1} = $2 if m/(.*);(.*)/;
            }
        }
        else
        {   local $_;
            while(<DB>)
            {   last if m/^$/;
                next if $skip_section;
                chomp;
                $typedb{$section}{$1} = "$major/$_" if m/^(?:x-)?([^;]+)/;
            }
        }
    }

    close DB;
}

# Catalyst-Plugin-Static-Simple uses it :(
sub create_type_index {}

#-------------------------------------------

sub type($)
{   my $spec    = lc $_[1];
    $spec       = 'text/plain' if $spec eq 'text';   # old mailers

    $spec =~ m!^(?:x\-)?([^/]+)/(?:x-)?(.*)!
        or return;

    my $section = $typedb{$1}    or return;
    my $record  = $section->{$2} or return;
    return $record if ref $record;   # already extended

    my $simple   = $2;
    my ($type, $ext, $enc) = split m/\;/, $record;
    my $os       = undef;   # XXX TODO

    $section->{$simple} = MIME::Type->new
      ( type       => $type
      , extensions => [split /\,/, $ext]
      , encoding   => $enc
      , system     => $os
      );
}


sub mimeTypeOf($)
{   my ($self, $name) = @_;
    (my $ext = lc $name) =~ s/.*\.//;
    my $type = $typedb{EXTENSIONS}{$ext} or return;
    $self->type($type);
}


sub addType(@)
{   my $self = shift;

    foreach my $type (@_)
    {   my ($major, $minor) = split m!/!, $type->simplified;
        $typedb{$major}{$minor} = $type;
        $typedb{EXTENSIONS}{$_} = $type for $type->extensions;
    }
    $self;
}


sub types()
{   my $self  = shift;
    my @types;
    foreach my $section (keys %typedb)
    {   next if $section eq 'EXTENSIONS';
        push @types, map $_->type("$section/$_"),
                         sort keys %{$typedb{$section}};
    }
    @types;
}


sub listTypes()
{   my $self  = shift;
    my @types;
    foreach my $section (keys %typedb)
    {   next if $section eq 'EXTENSIONS';
        foreach my $sub (sort keys %{$typedb{$section}})
        {   my $record = $typedb{$section}{$sub};
            push @types, ref $record            ? $record->type
                       : $record =~ m/^([^;]+)/ ? $1 : die;
        }
    }
    @types;
}


sub extensions { keys %{$typedb{EXTENSIONS}} }
sub _MojoExtTable() {$typedb{EXTENSIONS}}

#-------------

sub httpAccept($)
{   my $self   = shift;
    my @listed;

    foreach (split /\,\s*/, shift)
    {
        m!^   ([a-zA-Z0-9-]+ | \*) / ( [a-zA-Z0-9+-]+ | \* )
          \s* (?: \;\s*q\=\s* ([0-9]+(?:\.[0-9]*)?) \s* )?
              (\;.* | )
          $ !x or next;

        my $mime = "$1/$2$4";
        my $q    = defined $3 ? $3 : 1;   # q, default=1

        # most complex first
        $q += $4 ? +0.01 : $1 eq '*' ? -0.02 : $2 eq '*' ? -0.01 : 0;

        # keep order
        $q -= @listed*0.0001;

        push @listed, [ $mime => $q ];
    }
    map $_->[0], sort {$b->[1] <=> $a->[1]} @listed;
}


sub httpAcceptBest($@)
{   my $self   = shift;
    my @accept = ref $_[0] eq 'ARRAY' ? @{(shift)} : $self->httpAccept(shift);
    my $match;

    foreach my $acc (@accept)
    {   $acc   =~ s/\s*\;.*//;    # remove attributes
        my $m = $acc !~ s#/\*$## ? first { $_->equals($acc) } @_
              : $acc eq '*'      ? $_[0]     # $acc eq */*
              :                    first { $_->mediaType eq $acc } @_;
        return $m if defined $m;
    }

    ();
}


sub httpAcceptSelect($@)
{   my ($self, $accept) = (shift, shift);
    my $fns  = !@_ ? return () : ref $_[0] eq 'ARRAY' ? shift : [@_];

    unless(defined $accept)
    {   my $fn = $fns->[0];
        return ($fn, $self->mimeTypeOf($fn));
    }

    # create mapping  type -> filename
    my (%have, @have);
    foreach my $fn (@$fns)
    {   my $type = $self->mimeTypeOf($fn) or next;
        $have{$type->simplified} = $fn;
        push @have, $type;
    }

    my $type = $self->httpAcceptBest($accept, @have);
    defined $type ? ($have{$type}, $type) : ();
}

#-------------------------------------------
# OLD INTERFACE (version 0.06 and lower)


use base 'Exporter';
our @EXPORT_OK = qw(by_suffix by_mediatype import_mime_types);


my $mime_types;

sub by_suffix($)
{   my $filename = shift;
    $mime_types ||= MIME::Types->new;
    my $mime     = $mime_types->mimeTypeOf($filename);

    my @data     = defined $mime ? ($mime->type, $mime->encoding) : ('','');
    wantarray ? @data : \@data;
}


sub by_mediatype($)
{   my $type = shift;
    $mime_types ||= MIME::Types->new;

    my @found;
    if(!ref $type && index($type, '/') >= 0)
    {   my $mime   = $mime_types->type($type);
        @found     = $mime if $mime;
    }
    else
    {   my $search = ref $type eq 'Regexp' ? $type : qr/$type/i;
        @found     = map $mime_types->type($_),
                         grep $_ =~ $search,
                             $mime_types->listTypes;
    }

    my @data;
    foreach my $mime (@found)
    {   push @data, map [$_, $mime->type, $mime->encoding],
                        $mime->extensions;
    }

    wantarray ? @data : \@data;
}


sub import_mime_types($)
{   my $filename = shift;
    use Carp;
    croak <<'CROAK';
import_mime_types is not supported anymore: if you have types to add
please send them to the author.
CROAK
}

1;
