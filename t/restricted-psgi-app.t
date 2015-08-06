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

{
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    isnt( $test_apps->request( GET '/mt/mt.cgi' )->content,
        'Not Found', 'No restriction' );
}

{
    my $cms = MT::PSGI->new( application => 'cms' )->to_app;
    my $test_cms = Plack::Test->create($cms);
    isnt( $test_cms->request( GET '/mt/mt.cgi' )->content,
        'Not Found', 'No restriction for specific application' );
}

MT->config->RestrictedPSGIApp('cms');

{
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    is( $test_apps->request( GET '/mt/mt.cgi' )->content,
        'Not Found', 'Restrict "cms"' );
}

{
    my $cms = MT::PSGI->new( application => 'cms' )->to_app;
    my $test_cms = Plack::Test->create($cms);
    is( $test_cms->request( GET '/mt/mt.cgi' )->content,
        'Not Found', 'Restrict "cms" for specific application' );
}

done_testing;
