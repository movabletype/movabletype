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
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{ name => 'test site' }],
    asset   => [qw/test.jpg test.(jpg/],
});

my $image_driver = MT->config->ImageDriver;

my $admin = MT::Author->load(1);
my $normal_asset = $objs->{image}{'test.jpg'};
my $weird_asset  = $objs->{image}{'test.(jpg'};

subtest 'Remove asset with a normal extension' => sub {
    ok !!MT->model('asset')->load($normal_asset->id), "asset still exists";
    ok -f $normal_asset->file_path, "file exists";

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    # make a cache
    $app->get_ok({
        __mode  => 'thumbnail_image',
        blog_id => $normal_asset->blog_id,
        id      => $normal_asset->id,
        width   => 30,
        height  => 30,
    });
    my ($cache) = grep /assets_c/, $test_env->files;
    ok $cache && -f $cache, "cache exists";

    $app->post_ok({
        __mode      => 'delete',
        _type       => 'asset',
        action_name => 'delete',
        blog_id     => $normal_asset->blog_id,
        return_args => '__mode%3Dlist%26blog_id%3D0%26_type%3Dasset%26does_act%3D1',
        id          => $normal_asset->id,
    });
    ok !$app->generic_error, "no error";
    ok !MT->model('asset')->load($normal_asset->id), "asset does not exist anymore";
    ok !-f $normal_asset->file_path, "file does not exist anymore";
    ok $cache && !-f $cache, "cache does not exist anynmore" or $test_env->ls;
};

subtest 'Remove asset with a weird extension' => sub {
    ok !!MT->model('asset')->load($weird_asset->id), "asset still exists";
    ok -f $weird_asset->file_path, "file exists";

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    # make a cache
    $app->get_ok({
        __mode  => 'thumbnail_image',
        blog_id => $weird_asset->blog_id,
        id      => $weird_asset->id,
        width   => 30,
        height  => 30,
    });
    my ($cache) = grep /assets_c/, $test_env->files;
    SKIP: {
        local $TODO = 'Only for *Magick' unless $image_driver =~ /Magick/;
        ok $cache && -f $cache, "cache exists";
    }

    $app->post_ok({
        __mode      => 'delete',
        _type       => 'asset',
        action_name => 'delete',
        blog_id     => $weird_asset->blog_id,
        return_args => '__mode%3Dlist%26blog_id%3D0%26_type%3Dasset%26does_act%3D1',
        id          => $weird_asset->id,
    });
    ok !$app->generic_error, "no error";
    ok !MT->model('asset')->load($weird_asset->id), "asset does not exist anymore";
    ok !-f $weird_asset->file_path, "file does not exist anymore";
    SKIP: {
        local $TODO = 'Only for *Magick' unless $image_driver =~ /Magick/;
        ok $cache && !-f $cache, "cache does not exist anynmore" or $test_env->ls;
    }
};

done_testing;
