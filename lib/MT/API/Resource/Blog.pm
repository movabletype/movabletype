package MT::API::Resource::Blog;

use strict;
use warnings;

use base qw(MT::API::Resource);

sub model {
    my ( $class, $app ) = @_;
    $app->model('blog');
}

sub columns {
    [qw(id name)];
}

1;
