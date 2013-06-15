package MT::DataAPI::Resource::Blog;

use strict;
use warnings;

sub updatable_fields {
    [];
}

sub fields {
    [   qw(id class name description),
        {   name  => 'url',
            alias => 'site_url',
        },
        {   name  => 'archiveUrl',
            alias => 'archive_url',
        },
    ];
}

1;
