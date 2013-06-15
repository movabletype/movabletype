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
    [   qw(
            id
            label
            url
            description
            ),
        {   name  => 'mimeType',
            alias => 'mime_type',
        },
        {   name  => 'filename',
            alias => 'file_name',
        },
        $MT::DataAPI::Resource::Common::fields{tags},
    ];
}

1;
