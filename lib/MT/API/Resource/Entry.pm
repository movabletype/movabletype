package MT::API::Resource::Entry;

use strict;
use warnings;

use base qw(MT::API::Resource);

sub model {
    my ( $class, $app ) = @_;
    $app->model('author');
}

sub columns {
    [
        {
            name => 'status',
            from_object => sub {
                my ( $class, $app, $obj ) = @_;
                MT::Entry::status_text( $obj->status );
            },
            to_object => sub {
                my ( $class, $app, $hash ) = @_;
                # TODO
            },
        },
        {
            name => 'body',
            alias => 'text',
        },
        {
            name => 'more',
            alias => 'text_more',
        },
        qw(id title class),
    ]
}

1;
