use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} ||= 'mysql-test.cfg';
}

use Test::More;
use Plack::Test;
use HTTP::Request::Common;

use lib qw( lib extlib t/lib );
use MT;
use MT::PSGI;

MT->instance;
my $uri = MT->config->AdminCGIPath . MT->config->AdminScript;

{
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    my $res       = $test_apps->request( GET $uri );
    isnt( $res->content, 'Not Found', 'No restriction' );
}

{
    my $cms      = MT::PSGI->new( application => 'cms' )->to_app;
    my $test_cms = Plack::Test->create($cms);
    my $res      = $test_cms->request( GET $uri );
    isnt( $res->content,
        'Not Found', 'No restriction for specific application' );
}

MT->config->RestrictedPSGIApp('cms');

{
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    my $res       = $test_apps->request( GET $uri );
    is( $res->content, 'Not Found', 'Restrict "cms"' );
}

{
    my $cms      = MT::PSGI->new( application => 'cms' )->to_app;
    my $test_cms = Plack::Test->create($cms);
    my $res      = $test_cms->request( GET $uri );
    is( $res->content,
        'Not Found', 'Restrict "cms" for specific application' );
}

done_testing;
