package MT::API::Resource::User;

use strict;
use warnings;

use base qw(MT::API::Resource);

sub model {
    my ( $class, $app ) = @_;
    $app->model('author');
}

sub columns {
    [qw(id name nickname)];
}

1;
