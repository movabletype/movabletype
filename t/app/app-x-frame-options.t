#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Plack::Test; 1 }
        or plan skip_all => 'Plack::Test is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request;

use MT::Test;
use MT;
use MT::Test::App;
use MT::PSGI;

$test_env->prepare_fixture('db');

my $config = MT->instance->config;
my $user   = MT->model('author')->load(1);

{
    $config->XFrameOptions('SAMEORIGIN', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({});
    like($res->header('x-frame-options') => qr/sameorigin/i, 'SAMEORIGIN');
}

{
    $config->XFrameOptions('DENY', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({});
    like($res->header('x-frame-options') => qr/deny/i, 'DENY');
}

{
    $config->XFrameOptions('ALLOW-FROM https://example.com', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({});
    like($res->header('x-frame-options') => qr{allow-from https://example\.com}i, 'ALLOW-FROM');
}

{
    $config->XFrameOptions('SAMEORIGIN', 1);
    $config->save_config;

    my $app = MT::Test::App->new('DataAPI');
    $app->login($user);
    my $res = $app->get({});
    ok($res->decoded_content =~ /API Version is required/, 'Data API');
    like($res->header('x-frame-options') => qr/sameorigin/i, 'Header is set');
}

{
    my $app  = MT::PSGI->new->to_app;
    my $test = Plack::Test->create($app);

    my $req = HTTP::Request->new(GET => '/cgi-bin/mt.cgi');
    my $res = $test->request($req);

    is(lc $res->header('X-Frame-Options'), 'sameorigin', 'PSGI');
}

{
    $config->XFrameOptions('sameorigin', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({});
    like($res->header('x-frame-options') => qr/sameorigin/i, 'Lower case');
}

{
    $config->XFrameOptions('invalid', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({});
    like($res->header('x-frame-options') => qr/sameorigin/i, 'Invalid value');
}

{
    $config->XFrameOptions('sameorigin', 1);
    $config->save_config;

    my $app = MT::Test::App->new('CMS');
    $app->login($user);
    my $res = $app->get_ok({ __mode => 'invalid' });
    ok($app->page_title =~ /An error occurred/, 'An error occurred');
    like($res->header('x-frame-options') => qr/sameorigin/i, 'Header is set');
}

done_testing;
