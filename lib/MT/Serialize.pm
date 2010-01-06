# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Serialize;

use strict;
our $VERSION = 2;

{
    my %Types = (
        Storable => [ \&_freeze_storable, \&_thaw_storable ],
        MT       => [ \&_freeze_mt_2,     \&_thaw_mt    ],
    );

    sub new {
        my $class = shift;
        my $type = $Types{$_[0]};
        bless { freeze => $type->[0], thaw => $type->[1] }, $class;
    }
}

my $default_serializer;
sub _default_serializer {
    return $default_serializer if $default_serializer;
    $default_serializer = new MT::Serialize(MT->config->Serializer);
}

sub serialize {
    my $ser = shift;
    $ser = _default_serializer unless ref $ser;
    $ser->{freeze}->(@_);
}

sub unserialize {
    my $ser = shift;
    $ser = _default_serializer unless ref $ser;
    $ser->{thaw}->(@_);
}

sub _freeze_storable { require Storable; Storable::freeze(@_) }
sub _thaw_storable   { require Storable; Storable::thaw(@_)   }

# for compatibility, in case this routine is referenced directly
# by plugins...
sub _freeze_mt {
    &_freeze_mt_1;
}

sub _freeze_mt_1 {
    my($ref) = @_;
    my $frozen = 'SERG';
    for my $col (keys %{ $$ref }) {
        my $col_val = ${$ref}->{$col};
        $col_val = '' unless defined $col_val;
        no_utf8($col_val);
        $frozen .= pack('N', length($col)) . $col .
                   pack('N', length($col_val)) . $col_val;
    }
    $frozen;
}

sub _freeze_mt_2 {
    my($ref) = @_;

    # version 2 signature: 'SERG' + packed long 0 + packed long protocol
    my $ref_cnt = 0;
    my %refs = ( $ref => $ref_cnt++ );
    my $freezer;

    # The ice tray freezes a single element, yielding a frozen cube
    my %ice_tray = (
        'HASH' => sub {
            my $v = shift;
            my $cube = 'H' . pack('N', scalar(keys %$v));
            for my $k (keys %$v) {
                my $kv = $v->{$k};
                $cube .= pack('N', length($k)) . $k .
                    $freezer->($kv);
            }
            $cube;
        },
        'ARRAY' => sub {
            my $v = shift;
            my $cube = 'A' . pack('N', scalar(@$v));
            $cube .= $freezer->($_) foreach @$v;
            $cube;
        },
        'SCALAR' => sub {
            my $v = shift;
            no_utf8($$v);
            'S' . pack('N', length($$v)) . $$v;
        },
        'REF' => sub {
            my $v = shift;
            'R' . $freezer->($$v);
        },
    );

    $freezer = sub {
        my ($value) = @_;
        my $frozen;
        my $ref = ref $value;
        if ($ref) {
            if (exists $refs{$value}) {
                $frozen = 'P' . pack('N', $refs{$value});
            } else {
                $refs{$value} = $ref_cnt++;
                if (!exists $ice_tray{$ref}) {
                    # unknown reference type-- CODE or foreign package?
                    $value = \undef; $ref = 'REF';
                }
                $frozen = $ice_tray{$ref}->($value);
            }
        } else {
            if (defined $value) {
                no_utf8($value);
                $frozen = '-' . pack('N', length($value)) . $value;
            } else {
                $frozen = 'U';
            }
        }
        $frozen;
    };

    'SERG' . pack('N', 0) . pack('N', 2) . $freezer->($$ref);
}

sub no_utf8 {
    for (@_) { 
        next if ref;
        $_ = pack 'C0A*', $_;
    }
}

sub _thaw_mt {
    my ($frozen) = @_;
    return \{} unless $frozen && substr($frozen, 0, 4) eq 'SERG';
    my $n = unpack 'N', substr($frozen, 4, 4);
    if ($n == 0) {
        my $v = unpack 'N', substr($frozen, 8, 4);
        if (($v > 0) && ($v <= $VERSION)) {
            my $thaw = '_thaw_mt_' . $v;
            no strict 'refs';
            return $thaw->($frozen);
        } else {
            return \{};
        }
    } else {
        _thaw_mt_1($frozen);
    }
}

sub _thaw_mt_1 {
    my($frozen) = @_;
    return unless substr($frozen, 0, 4) eq 'SERG';
    substr($frozen, 0, 4) = '';
    my $thawed = {};
    my $len = length $frozen;
    my $pos = 0;
    while ($pos < $len) {
        my $slen = unpack 'N', substr($frozen, $pos, 4);
        my $col = $slen ? substr($frozen, $pos+4, $slen) : '';
        $pos += 4 + $slen;
        $slen = unpack 'N', substr($frozen, $pos, 4);
        my $col_val = substr($frozen, $pos+4, $slen);
        $pos += 4 + $slen;
        $thawed->{$col} = $col_val;
    }
    \$thawed;
}

sub _thaw_mt_2 {
    my($frozen) = @_;
    return unless substr($frozen, 0, 4) eq 'SERG';

    my $thawed;
    my @refs = (\$thawed);
    my $heater;
    my $pos = 12;  # skips past signature and version block

    # The microwave thaws and pops out an element
    my %microwave = (
        'H' => sub {   # hashref
            my $keys = unpack 'N', substr($frozen, $pos, 4);
            $pos += 4;
            my $values = {};
            push @refs, $values;
            for (my $k = 0; $k < $keys; $k++ ) {
                my $key_name_len = unpack 'N', substr($frozen, $pos, 4);
                my $key_name = substr($frozen, $pos + 4, $key_name_len);
                $pos += 4 + $key_name_len;
                $values->{$key_name} = $heater->();
            }
            $values;
        },
        'A' => sub {   # arrayref
            my $array_count = unpack 'N', substr($frozen, $pos, 4);
            $pos += 4;
            my $values = [];
            push @refs, $values;
            for (my $a = 0; $a < $array_count; $a++) {
                push @$values, $heater->();
            }
            $values;
        },
        'S' => sub {   # scalarref
            my $slen = unpack 'N', substr($frozen, $pos, 4);
            my $col_val = substr($frozen, $pos+4, $slen);
            $pos += 4 + $slen;
            push @refs, \$col_val;
            \$col_val;
        },
        'R' => sub {   # refref
            my $value;
            push @refs, \$value;
            $value = $heater->();
            \$value;
        },
        '-' => sub {   # scalar value
            my $slen = unpack 'N', substr($frozen, $pos, 4);
            my $col_val = substr($frozen, $pos+4, $slen);
            $pos += 4 + $slen;
            $col_val;
        },
        'U' => sub {   # undef
            undef;
        },
        'P' => sub {   # pointer to known ref
            my $ptr = unpack 'N', substr($frozen, $pos, 4);
            $pos += 4;
            $refs[$ptr];
        }
    );

    $heater = sub {
        my $type = substr($frozen, $pos, 1); $pos++;
        exists $microwave{$type} ? $microwave{$type}->() : undef;
    };

    $thawed = $heater->();
    $thawed = {} unless defined $thawed;
    \$thawed;
}

1;
__END__

=head1 NAME

MT::Serialize - Data serialization library

=head1 SYNOPSIS

    my $serializer = MT::Serialize->new(MT->config->Serializer);

    my $data = { 'this' => 'is', 'my' => 'data' };
    my $frozen = $serializer->serialize( \$data );

    my $thawed = $serializer->unserialize( $frozen );

=head1 DESCRIPTION

This package provides an abstraction layer to the serialization methods that
are available to Movable Type.  The user can select the type of serialization
they want to use by specifying it in the mt.cfg file with the 'Serializer'
configuration key. 'MT' and 'Storable' are the currently available
serialization methods.

=head1 USAGE

=head2 MT::Serialize::new( $type )

Constructor that returns an object with methods that are appropriate for
the I<$type> of serialization requested.

=head2 MT::Serialize->serialize( $data )

Converts the data given into a bytestream, suitable for storage in a
BerkeleyDB table, a BLOB field in a database or a flat file.

Note that the $data parameter must be a reference to whatever data you
want to serialize.  For instance, if you are serializing a hashref, you
should pass through a reference to the hashref.

=head2 MT::Serialize->unserialize( $data )

Converts a serialized bytestream given back into the original Perl data
structure.  It returns a reference to whatever data structure was
reconstructed.

=head2 no_utf8

This function removes UTF-8 from scalars.

=head1 COMPATIBILITY NOTES

Version 2 of the native MT serializer changes the structure of the
stream quite a bit, but remains backward compatible.  If version 1
frozen data is fed into the MT thaw method, it will handle it using
the legacy code.  Then upon reserializing the data, it will be
upgraded to the new format.  The new encoding includes a version
number which should allow us more flexibility in upgrading the
encoding format in the future, without worrying about breaking or
upgrading existing serialized data.

The updated protocol allows you to store most any Perl data structure,
although it does not currently support references to objects, code
references or globs.

=cut
