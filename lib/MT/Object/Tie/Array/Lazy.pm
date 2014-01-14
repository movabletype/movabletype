# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Object::Tie::Array::Lazy;

use strict;
use warnings;

use base qw( Tie::Array );
use Carp qw( croak );

sub create {
    my $class = shift;
    my ( $data, $opts ) = @_;

    my @array;
    tie @array, 'MT::Object::Tie::Array::Lazy', $opts;
    @array = @$data;

    \@array;
}

sub TIEARRAY {
    my $class = shift;
    my ($opts) = @_;

    if ( !$opts || !$opts->{model} ) {
        croak "usage: tie ARRAY, '" . __PACKAGE__ . "', {model => \$model}";
    }

    my $self = {
        data => [],
        %$opts,
    };

    if ( !ref $self->{model} && $self->{model} !~ m/::/ ) {
        $self->{model} = MT->model( $self->{model} );
    }

    bless $self, $class;
}
sub FETCHSIZE { scalar @{ $_[0]->{data} } }
sub STORESIZE { $#{ $_[0]->{data} } = $_[1] - 1 }
sub STORE     { $_[0]->{data}[ $_[1] ] = $_[2] }

sub FETCH {
    my $self    = shift;
    my ($index) = @_;
    my $data    = $self->{data};
    my $value   = $data->[$index];
    my $ref     = ref $value;
    if ( $ref eq 'HASH' || $ref eq 'ARRAY' ) {
        my %ids = map {
            my $index = $_;
            my $value = $data->[$index];
            my $ref   = ref $value;
            my $id    = do {
                if ( $ref eq 'HASH' ) {
                    $value->{id};
                }
                elsif ( $ref eq 'ARRAY' ) {
                    $value->[0];
                }
                else {
                    undef;
                }
            };

            $id ? ( $id => $index ) : ();
        } 0 .. ( $self->FETCHSIZE - 1 );

        my @objs = $self->model->load( { id => [ keys %ids ] } );

        for my $o (@objs) {
            $data->[ delete $ids{ $o->id } ] = $o;
        }
        while ( my ( $id, $index ) = each %ids ) {
            my $res = undef;
            if ( ref $data->[$index] eq 'HASH' ) {
                $res = $self->model->new;
                $res->set_values( $data->[$index] );
            }
            $data->[$index] = $res;
        }

        $value = $data->[$index];
    }
    $value;
}
sub CLEAR { @{ $_[0]->{data} } = () }

sub POP {
    my $self = shift;
    $self->FETCH(-1);
    pop( @{ $self->{data} } );
}
sub PUSH { my $o = shift; push( @{ $o->{data} }, @_ ) }

sub SHIFT {
    my $self = shift;
    $self->FETCH(0);
    shift( @{ $self->{data} } );
}
sub UNSHIFT { my $o = shift; unshift( @{ $o->{data} }, @_ ) }
sub EXISTS { exists $_[0]->{data}[ $_[1] ] }

sub DELETE {
    my $self = shift;
    my ($index) = @_;
    $self->FETCH($index);

    delete $self->{data}[$index];
}

sub SPLICE {
    my $ob  = shift;
    my $sz  = $ob->FETCHSIZE;
    my $off = @_ ? shift : 0;
    $off += $sz if $off < 0;
    my $len = @_ ? shift : $sz - $off;
    if ($len) {
        for ( $off .. ( $off + $len - 1 ) ) {
            $ob->FETCH($_);
        }
    }
    return splice( @{ $ob->{data} }, $off, $len, @_ );
}

sub model {
    $_[0]->{model};
}

1;

__END__

=head1 NAME

MT::Object::Tie::Array::Lazy

=head1 SYNOPSIS

Creating a I<MT::Object::Tie::Array::Lazy> object:

    use MT::Object::Tie::Array::Lazy;

    my $model = 'entry';
    my $objs  = MT->model($model)
        ->load_arrayref( { id => [ 1, 2, 3 ] }, { fetchonly => ['id'] } );
    my $array
        = MT::Object::Tie::Array::Lazy->create( $objs, { model => $model } );
    ref $array->[0];    # MT::Entry;

Creating an object via raw interface:

    use MT::Object::Tie::Array::Lazy;

    my $model = 'entry';
    my $objs  = MT->model($model)
        ->load_arrayref( { id => [ 1, 2, 3 ] }, { fetchonly => ['id'] } );
    tie @array, MT::Object::Tie::Array::Lazy, { model => $model };
    @array = @$objs;
    ref $array[0];    # MT::Entry;

=head1 DESCRIPTION

I<MT::Object::Tie::Array::Lazy> is used in order to create the list of objects which are not necessarily used.
