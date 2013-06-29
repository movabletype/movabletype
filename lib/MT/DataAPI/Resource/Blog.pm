package MT::DataAPI::Resource::Blog;

use strict;
use warnings;

sub updatable_fields {
    [];
}

sub fields {
    [   qw(id class name description archiveUrl),
        {   name  => 'url',
            alias => 'site_url',
        },
    ];
}

1;
