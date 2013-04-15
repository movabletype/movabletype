package MT::API::Resource::Trackback;

use strict;
use warnings;

sub updatable_fields {
    [];
}

sub fields {
    [   {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        {   name        => 'entry',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->entry_id, };
            },
        },
        'id',
        {   name  => 'date',
            alias => 'created_on',
        },
        'title',
        'excerpt',
        {   name  => 'blogName',
            alias => 'blog_name',
        },
        {   name  => 'url',
            alias => 'source_url',
        },
        'ip',
    ];
}

1;
