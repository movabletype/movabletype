# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Serialize;

use strict;
use warnings;
our $VERSION            = '5';
our $SERIALIZER_VERSION = '2';

{
    my %Types = (
        Storable => [ \&_freeze_storable,    \&_thaw_storable ],
        JSON     => [ \&_freeze_json,        \&_thaw_json ],
        MT       => [ \&_freeze_mt_5,        \&_thaw_mt ],
        MT2      => [ \&_freeze_mt_2,        \&_thaw_mt ],
        MTS      => [ \&_freeze_mt_storable, \&_thaw_mt ],
        MTJ      => [ \&_freeze_mt_json,     \&_thaw_mt ],
    );

    sub new {
        my $class = shift;
        my $type  = $Types{ $_[0] };
        bless { freeze => $type->[0], thaw => $type->[1] }, $class;
    }
}

my $default_serializer;

sub _default_serializer {
    return $default_serializer if $default_serializer;
    $default_serializer = new MT::Serialize( MT->config->Serializer );
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

sub serializer_version {
    my ( $ser, $frozen ) = @_;
    return undef unless $frozen && substr( $frozen, 0, 4 ) eq 'SERG';
    my $n = unpack 'N', substr( $frozen, 4, 4 );
    if ( $n == 0 ) {
        my $v = unpack 'N', substr( $frozen, 8, 4 );
        if ( ( $v > 0 ) && ( $v <= $VERSION ) ) {
            return $v;
        }
        else {
            return undef;
        }
    }
    else {
        return 1;
    }
}

sub _freeze_storable { require Storable; Storable::freeze(@_) }
sub _thaw_storable   { require Storable; Storable::thaw(@_) }

sub _freeze_json { require JSON; JSON::encode_json( ${ $_[0] } ) }
sub _thaw_json   { require JSON; \JSON::decode_json(shift) }

# for compatibility, in case this routine is referenced directly
# by plugins...
sub _freeze_mt {
    &_freeze_mt_1;
}

sub _freeze_mt_1 {
    my ($ref) = @_;
    my $frozen = 'SERG';
    for my $col ( keys %{$$ref} ) {
        my $col_val = ${$ref}->{$col};
        $col_val = '' unless defined $col_val;
        no_utf8($col_val);
        $frozen
            .= pack( 'N', length($col) )
            . $col
            . pack( 'N', length($col_val) )
            . $col_val;
    }
    $frozen;
}

sub _macrofreeze {
    use bytes;
    my $value   = shift;
    my $ref_cnt = 1;       # for compatibility with the existing algorithm
    my %refs;
    my $frozen = '';
    my @stack;

    while (1) {
        if (@stack) {
            my $top = $stack[-1];
            if ( $top->[0] eq 'ARRAY' || $top->[0] eq 'REF' ) {
                $value = splice @$top, 1, 1;
            }
            elsif ( $top->[0] eq 'HASH' ) {
                ( my ($key), $value ) = splice @$top, 1, 2;
                $frozen .= pack( 'N', length($key) ) . $key;
            }
            else {
                die "Unexpected type '@{[$top->[0]]}' in _macrofreeze\n";
            }
            pop @stack if @$top <= 1;
        }

        my $ref = ref $value;

        if ($ref) {
            if ( exists $refs{$value} ) {
                $frozen .= 'P' . pack( 'N', $refs{$value} );
            }
            else {
                $refs{$value} = $ref_cnt++;
                if ( $ref !~ /^(HASH|ARRAY|SCALAR|REF)$/ ) {

                    # unknown reference type-- CODE or foreign package?
                    $value = \undef;
                    $ref   = 'REF';
                }
                if ( $ref eq 'SCALAR' ) {
                    no_utf8($$value);
                    $frozen .= 'S' . pack( 'N', length($$value) ) . $$value;
                }
                elsif ( $ref eq 'REF' ) {
                    $frozen .= 'R';
                    push( @stack, [ 'REF' => $$value ] );
                }
                elsif ( $ref eq 'ARRAY' ) {
                    $frozen .= 'A' . pack( 'N', scalar(@$value) );
                    push( @stack, [ 'ARRAY' => @$value ] ) if scalar @$value;
                }
                elsif ( $ref eq 'HASH' ) {
                    $frozen .= 'H' . pack( 'N', scalar( keys %$value ) );
                    push( @stack, [ 'HASH' => %$value ] ) if keys %$value;
                }
                else {
                    die "Unexpected type '$ref' in _macrofreeze\n";
                }
            }
        }
        else {
            if ( defined $value ) {
                no_utf8($value);
                $frozen .= '-' . pack( 'N', length($value) ) . $value;
            }
            else {
                $frozen .= 'U';
            }
        }
        last if !@stack;
    }
    return $frozen;
}

sub _freeze_mt_2 {
    my ($ref) = @_;

    # version 2 signature: 'SERG' + packed long 0 + packed long protocol
    'SERG' . pack( 'N', 0 ) . pack( 'N', 2 ) . _macrofreeze($$ref);
}

sub _freeze_mt_storable {
    my ($ref) = @_;

    # version 3 signature: 'SERG' + packed long 0 + packed long protocol
    require Storable;
    'SERG' . pack( 'N', 0 ) . pack( 'N', 3 ) . Storable::nfreeze($$ref);
}

sub _freeze_mt_json {
    my ($ref) = @_;

    # version 3 signature: 'SERG' + packed long 0 + packed long protocol
    require JSON;
    'SERG' . pack( 'N', 0 ) . pack( 'N', 4 ) . JSON::encode_json($$ref);
}

sub no_utf8 {
    for (@_) {
        next if ref;
        $_ = pack 'C0A*', $_;
    }
}

sub _freeze_mt_5 {
    my $enc = MT->config('PublishCharset') || 'UTF-8';
    no warnings 'redefine';
    local *no_utf8 = sub {
        for (@_) {
            next if ref;
            $_ = Encode::encode( $enc, $_ ) if Encode::is_utf8($_);
        }
    };
    _freeze_mt_2(@_);
}

sub _thaw_mt {
    my ($frozen) = @_;
    return \{} unless $frozen && substr( $frozen, 0, 4 ) eq 'SERG';
    my $n = unpack 'N', substr( $frozen, 4, 4 );
    if ( $n == 0 ) {
        my $v = unpack 'N', substr( $frozen, 8, 4 );
        if ( ( $v > 0 ) && ( $v <= $VERSION ) ) {
            my $thaw = '_thaw_mt_' . $v;
            no strict 'refs';
            return $thaw->($frozen);
        }
        else {
            return \{};
        }
    }
    else {
        _thaw_mt_1($frozen);
    }
}

sub _thaw_mt_1 {
    my ($frozen) = @_;
    return unless substr( $frozen, 0, 4 ) eq 'SERG';
    substr( $frozen, 0, 4 ) = '';
    my $thawed = {};
    my $len    = length $frozen;
    my $pos    = 0;
    while ( $pos < $len ) {
        my $slen = unpack 'N', substr( $frozen, $pos, 4 );
        my $col = $slen ? substr( $frozen, $pos + 4, $slen ) : '';
        $pos += 4 + $slen;
        $slen = unpack 'N', substr( $frozen, $pos, 4 );
        my $col_val = substr( $frozen, $pos + 4, $slen );
        $pos += 4 + $slen;
        $thawed->{$col} = $col_val;
    }
    \$thawed;
}

sub _macrowave {
    use bytes;
    @_ == 2 or die "_macrowave expects: \$frozen, \$pos\n";
    my ( $frozen, $pos ) = @_;
    my $refs = [undef];
    my $len  = length $frozen;
    my ( @stack, $value );
    my $encoding = MT->app->config('PublishCharset') || 'UTF-8';
    my $enc = Encode::find_encoding($encoding)
        or die "unknown encoding: $encoding";

    while ( $pos < $len ) {
        my $type = substr( $frozen, $pos, 1 );
        $pos++;

        my $newref;
        $value = $type eq 'H'
            ? do {    # hashref
            my $keys = unpack 'N', substr( $frozen, $pos, 4 );
            $pos += 4;
            my $values = {};
            push @$refs, $values;
            $newref = [ $values, $keys ];
            $values;
            }
            : $type eq 'A' ? do {    # arrayref
            my $array_count = unpack 'N', substr( $frozen, $pos, 4 );
            $pos += 4;
            my $values = [];
            push @$refs, $values;
            $newref = [ $values, $array_count ];
            $values;
            }
            : $type eq 'S' ? do {    # scalarref
            my $slen = unpack 'N', substr( $frozen, $pos, 4 );
            my $col_val = substr( $frozen, $pos + 4, $slen );
            $col_val = $enc->decode($col_val)
                if !( Encode::is_utf8($col_val) );
            $pos += 4 + $slen;
            push @$refs, \$col_val;
            \$col_val;
            }
            : $type eq 'R' ? do {    # refref
            my $value = \(undef);
            push @$refs, $value;
            $newref = [ $value, 1 ];
            $value;
            }
            : $type eq '-' ? do {    # scalar value
            my $slen = unpack 'N', substr( $frozen, $pos, 4 );
            my $col_val = substr( $frozen, $pos + 4, $slen );
            $col_val = $enc->decode($col_val)
                if !( Encode::is_utf8($col_val) );
            $pos += 4 + $slen;
            $col_val;
            }
            : $type eq 'U' ? do {    # undef
            undef;
            }
            : $type eq 'P' ? do {    # pointer to known ref
            my $ptr = unpack 'N', substr( $frozen, $pos, 4 );
            $pos += 4;
            $refs->[$ptr];
            }
            : undef;

# if there is something on the stack, it has to be a complex ref (ARRAY, HASH, REF), then process it
        if (@stack) {
            my $top  = $stack[-1];
            my $more = --$top->[1];
            if ( ref $top->[0] eq 'HASH' ) {
                $top->[0]->{ $top->[2] } = $value;
            }
            elsif ( ref $top->[0] eq 'ARRAY' ) {
                push( @{ $top->[0] }, $value );
            }
            elsif ( ref $top->[0] eq 'REF' ) {
                ${ $top->[0] } = $value;
            }
            else {
                die
                    "Unexpected reference type in _macrowave @$top; expected HASH, ARRAY, or REF\n";
            }
        }

        push( @stack, $newref ) if $newref;

        # pop all completed elements
        while ( @stack && $stack[-1]->[1] == 0 ) {
            $value = $stack[-1]->[0];
            pop(@stack);
        }

        # if the top one is hash, process next key
        if ( @stack && $stack[-1]->[1] > 0 && ref $stack[-1]->[0] eq 'HASH' )
        {
            my $key_name_len = unpack 'N', substr( $frozen, $pos, 4 );
            $stack[-1]->[2] = substr( $frozen, $pos + 4, $key_name_len );
            $pos += 4 + $key_name_len;
        }

        last if !@stack;    # if nothing on the stack, we're done here
    }
    return $value;
}

sub _thaw_mt_2 {            # MT
    my ($frozen) = @_;
    return unless substr( $frozen, 0, 4 ) eq 'SERG';

    my $thawed;
    my $pos = 12;           # skips past signature and version block

    # The microwave thaws and pops out an element
    $thawed = _macrowave( $frozen, $pos );
    $thawed = {} unless defined $thawed;
    \$thawed;
}

sub _thaw_mt_3 {            # Storable
    my ($frozen) = @_;
    return unless substr( $frozen, 0, 4 ) eq 'SERG';

    my $thawed;
    my $pos = 12;           # skips past signature and version block

    require Storable;
    $thawed = Storable::thaw( substr( $frozen, $pos ) );
    $thawed = {} unless defined $thawed;
    \$thawed;
}

sub _thaw_mt_4 {            # JSON
    my ($frozen) = @_;
    return unless substr( $frozen, 0, 4 ) eq 'SERG';

    my $thawed;
    my $pos = 12;           # skips past signature and version block

    require JSON;
    $thawed = JSON::decode_json( substr( $frozen, $pos ) );
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
