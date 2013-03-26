package MT::API::Resource::Website;

use strict;
use warnings;

use base qw(MT::API::Resource::Blog);

sub model {
    my ( $class, $app ) = @_;
    $app->model('website');
}

1;
