#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

MT::Test->init_db;


my $website = MT::Test::Permission->make_website(name => 'my website');
my $admin = MT->model('author')->load(1);
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);
$app->post_ok({
    __mode          => 'save',
    _type           => 'website',
    id              => $website->id,
    blog_id         => $website->id,
    cfg_screen      => 'cfg_web_services',
    enable_data_api => '0',
});

ok(grep { $website->id eq $_ } split(',', MT->config('DataAPIDisableSite')), 'Include updated website');

$website->remove;

ok(!grep { $website->id eq $_ } split(',', MT->config('DataAPIDisableSite')), 'Not include updated website');

done_testing;
