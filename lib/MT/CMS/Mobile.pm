package MT::CMS::Mobile;
use strict;
use warnings;

sub change_to_pc_view {
    my ($app) = @_;
    $app->session( 'pc_view', 1 );
    $app->session->save;
    $app->json_result( { success => 1 } );
}

1;

