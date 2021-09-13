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

use MT;
use MT::Object;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin   = MT::Author->load(1);
my $blog_id = 1;

subtest 'No error occurs on site dashboard (MTC-26619)' => sub {
    my $content_data = MT->model('content_data')->new(
        author_id       => $admin->id,
        blog_id         => $blog_id,
        content_type_id => 100,
        status          => 2,
    );
    $content_data->column('unique_id',    'dummy');
    $content_data->column('ct_unique_id', 'dummy');
    MT::Object::save($content_data) or die;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'dashboard',
        blog_id => $blog_id,
    });
    ok !$app->generic_error;

};

done_testing;

