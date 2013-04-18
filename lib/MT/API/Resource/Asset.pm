package MT::API::Resource::Asset;

use strict;
use warnings;

use MT::API::Resource::Common;

sub updatable_fields {
    [   qw(
            label
            description
            tags
            customFields
            )
    ];
}

sub fields {
    [   'id', 'label', 'description', 'url', 'mime_type',
        $MT::API::Resource::Common::fields{tags},
    ];
}

1;
