package MT::API::Resource::User;

use strict;
use warnings;

sub updatable_fields {
    [qw(displayName)];
}

sub fields {
    [   'id',
        {   name  => 'displayName',
            alias => 'nickname',
        },
        {   name  => 'userpicURL',
            alias => 'userpic_url',
        },
    ];
}

1;
