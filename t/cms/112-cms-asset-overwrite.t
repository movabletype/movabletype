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

use utf8;
my $builder = Test::More->builder;
binmode $builder->output,         ':encoding(utf8)';
binmode $builder->failure_output, ':encoding(utf8)';
binmode $builder->todo_output,    ':encoding(utf8)';

use JSON;

use MT::Test;
use MT;
use MT::Test::Image;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin   = MT->model('author')->load(1);
my $blog_id = 1;
my $site    = MT::Website->load($blog_id);
$site->site_path($test_env->root . "/site");
$site->save;

no Carp::Always;

subtest 'Uploaded asset (test.jpg)' => sub {
    subtest 'first time' => sub {
        my $asset = upload_asset('test.jpg');
        isa_ok($asset, 'MT::Asset::Image');
        is $asset->file_name, 'test.jpg', 'asset file_name should be "test.jpg"';
        is $asset->label,     'test.jpg', 'asset label should be "test.jpg"';
    };
    subtest 'second time with overwrite option' => sub {
        my $asset = upload_asset('test.jpg');
        isa_ok($asset, 'MT::Asset::Image');
        is $asset->file_name,   'test.jpg', 'asset file_name should not be "test.jpg"';
        is $asset->label,       'test.jpg', 'asset label should be "test.jpg"';
    };
};


sub upload_asset {
    my ($file, %opts) = @_;

    require Encode;
    $file = Encode::encode($^O eq 'MSWin32' ? 'cp932' : 'utf-8' => $file);

    my $test_image = $test_env->path($file);
    MT::Test::Image->write(file => $test_image);

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $res = $app->post_ok({
        __mode        => 'js_upload_file',
        blog_id       => $blog_id,
        destination   => '%s',
        __test_upload => [
            'file',
            $test_image,
        ],
        auto_rename_non_ascii => 1,
        operation_if_exists   => 0, # overwrite
    });

    my $hash     = JSON::from_json($res->decoded_content);
    my $asset_id = $hash->{result}{asset}{id};
    $asset_id
        ? MT->model('asset.image')->load($asset_id)
        : undef;
}

done_testing;
