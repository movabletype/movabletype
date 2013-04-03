package MT::API::Resource::Blog;

use strict;
use warnings;

sub updatable_fields {
    [qw(name)];
}

sub fields {
    [qw(id name)];
}

1;
