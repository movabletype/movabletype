package MT::API::Resource::Comment;

use strict;
use warnings;

sub updatable_fields {
    [   qw(
            body
            parent
            status
            )
    ];
}

sub fields {
    [   {   name        => 'author',
            from_object => sub {
                my ($obj) = @_;
                MT::API::Resource->from_object( $obj->author );
            },
        },
        {   name        => 'entry',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->entry_id, };
            },
        },
        {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        'id',
        {   name  => 'date',
            alias => 'created_on',
        },
        {   name  => 'body',
            alias => 'text',
        },
        {   name        => 'link',
            from_object => sub {
                my ($obj) = @_;
                $obj->permalink;
            },
        },
        {   name  => 'parent',
            alias => 'parent_id',
        },
        {   name        => 'status',
            from_object => sub {
                my ($obj) = @_;
                $obj->status_text;
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                $obj->set_status_by_text( $hash->{status} );
                return;
            },
        },
    ];
}

1;
