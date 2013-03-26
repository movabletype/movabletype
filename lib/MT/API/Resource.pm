package MT::API::Resource;

use strict;
use warnings;

sub from_object {
    my ( $class, $app, $obj ) = @_;

    +{  map {
            my $ref = ref $_;
            if ( !$ref ) {
                $_ => $obj->$_;
            }
            elsif ( $ref eq 'HASH' ) {
                if (my $alias = $_->{alias}) {
                    $_->{name} => $obj->$alias;
                }
                else {
                    $_->{name} => $_->{from_object}->( $class, $app, $obj );
                }
            }
            } @{ $class->columns }
    };
}

sub to_object {
    my ( $class, $app, $hash ) = @_;

    my $obj = $class->model->new;
    $obj->set_values(
        {   map {
                my $ref = ref $_;
                if ( !$ref ) {
                    $_ => $hash->{$_};
                }
                elsif ( $ref eq 'HASH' ) {
                    $_->{name} => $_->{to_object}->( $class, $app, $hash );
                }
                } @{ $class->columns }
        }
    );

    $obj;
}

1;
