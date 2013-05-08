package MT::DataAPI::Resource::Asset;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            label
            description
            tags
            )
    ];
}

sub fields {
    [   'id', 'label', 'description', 'url', 'mime_type',
        $MT::DataAPI::Resource::Common::fields{tags},
    ];
}

1;
