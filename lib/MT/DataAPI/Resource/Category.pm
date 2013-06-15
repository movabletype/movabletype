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
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class',
        'label',
        'description',
        'parent',
        'basename',
    ];
}

1;
