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
    [   $MT::DataAPI::Resource::Common::fields{blog},
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class', 'label',
        'description',
        'parent',
        'basename',
    ];
}

1;
