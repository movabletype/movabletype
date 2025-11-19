use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Plack::Test; 1 }
        or plan skip_all => 'Plack::Test is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request::Common;

use MT::Test;
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
