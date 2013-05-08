package MT::DataAPI::Resource::Common;

use strict;
use warnings;

our %fields = (
    tags => {
        name        => 'tags',
        from_object => sub {
            my ($obj) = @_;
            [ $obj->tags ];
        },
        to_object => sub {
            my ( $hash, $obj ) = @_;
            if ( ref $hash->{tags} eq 'ARRAY' ) {
                $obj->set_tags( @{ $hash->{tags} } );
            }
            return;
        },
    },
    status => {
        name        => 'status',
        from_object => sub {
            my ($obj) = @_;
            $obj->get_status_text;
        },
        to_object => sub {
            my ( $hash, $obj ) = @_;
            $obj->set_status_by_text( $hash->{status} );
            return;
        },
    },
);

1;
