package MT::DataAPI::Resource::Category;

use strict;
use warnings;

sub updatable_fields {
    [   qw(
            label
            description
            basename
            )
    ];
}

sub fields {
    [   {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        'id',
        'class',
        'label',
        'description',
        'parent',
        'basename',
    ];
}

1;
