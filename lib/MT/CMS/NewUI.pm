package MT::CMS::NewUI;
use strict;
use warnings;

sub test_page {
    my $app = shift;

    my $param = {};

    $app->load_tmpl( 'test_page.tmpl', $param );
}

1;

