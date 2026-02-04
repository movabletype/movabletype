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
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request::Common;

use MT;
use MT::PSGI;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

MT::Test->init_db;
MT->instance;
my $uri = MT->config->AdminCGIPath . MT->config->DataAPIScript;

subtest 'no restriction' => sub {
    {
        my $apps      = MT::PSGI->new->to_app;
        my $test_apps = Plack::Test->create($apps);
        my $res       = $test_apps->request(GET $uri );
        isnt($res->content, 'Not Found', 'No restriction');
    }

    {
        my $cms      = MT::PSGI->new(application => 'data_api')->to_app;
        my $test_cms = Plack::Test->create($cms);
        my $res      = $test_cms->request(GET $uri );
        isnt($res->content, 'Not Found', 'No restriction for specific application');
    }
};

subtest 'with RestrictedPSGIApp' => sub {
    my @restricted_psgi_apps = MT->config->RestrictedPSGIApp;
    push @restricted_psgi_apps, 'data_api';
    MT->config->set('RestrictedPSGIApp', \@restricted_psgi_apps, 1);

    {
        my $apps      = MT::PSGI->new->to_app;
        my $test_apps = Plack::Test->create($apps);
        my $res       = $test_apps->request(GET $uri );
        is($res->content, 'Not Found', 'Restrict "data_api"');
    }

    {
        my $cms      = MT::PSGI->new(application => 'data_api')->to_app;
        my $test_cms = Plack::Test->create($cms);
        my $res      = $test_cms->request(GET $uri );
        is($res->content, 'Not Found', 'Restrict "data_api" for specific application');
    }

    @restricted_psgi_apps = grep { 'data_api' ne $_ } MT->config->RestrictedPSGIApp;
    MT->config->set('RestrictedPSGIApp', \@restricted_psgi_apps, 1);
};

subtest 'with DisableDataAPI' => sub {
    MT->config->DisableDataAPI(1, 1);

    {
        my $apps      = MT::PSGI->new->to_app;
        my $test_apps = Plack::Test->create($apps);
        my $res       = $test_apps->request(GET $uri );
        is($res->content, 'Not Found', 'Restrict "data_api"');
    }

    {
        my $cms      = MT::PSGI->new(application => 'data_api')->to_app;
        my $test_cms = Plack::Test->create($cms);
        my $res      = $test_cms->request(GET $uri );
        is($res->content, 'Not Found', 'Restrict "data_api" for specific application');
    }

    MT->config->DisableDataAPI(undef, 1);
};

subtest 'Disable Data API via UI' => sub {
    my $admin = MT->model('author')->load(1);
    my $app   = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'cfg_web_services',
        blog_id => 0,
    });
    $app->post_form_ok({
        disable_data_api => 1,
    });

    {
        my $apps      = MT::PSGI->new->to_app;
        my $test_apps = Plack::Test->create($apps);
        my $res       = $test_apps->request(GET $uri );
        if ($ENV{MT_TEST_RUN_APP_AS_CGI}) {
            is($res->content, '{"error":{"code":400,"message":"API Version is required"}}', 'Restrict "data_api"');
        } else {
            is($res->content, 'Not Found', 'Restrict "data_api"');
        }
    }

    {
        my $cms      = MT::PSGI->new(application => 'data_api')->to_app;
        my $test_cms = Plack::Test->create($cms);
        my $res      = $test_cms->request(GET $uri );
        if ($ENV{MT_TEST_RUN_APP_AS_CGI}) {
            is($res->content, '{"error":{"code":400,"message":"API Version is required"}}', 'Restrict "data_api"');
        } else {
            is($res->content, 'Not Found', 'Restrict "data_api" for specific application');
        }
    }
};

done_testing;
