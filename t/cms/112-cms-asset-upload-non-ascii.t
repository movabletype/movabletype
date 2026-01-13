#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use JSON;

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

use File::Spec;
use File::Path;

use MT::Test;
use MT::Test::Image;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);

no Carp::Always;

require Encode;
my $file = Encode::encode($^O eq 'MSWin32' ? 'cp932' : 'utf-8' => 'テスト.jpg');
my $test_image = $test_env->path($file);
MT::Test::Image->write(file => $test_image);

subtest 'AllowNonAsciiFilename = 1 (Default)' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    # js_upload_file (Modern)
    $app->js_post_ok({
        __test_upload         => [file => $test_image],
        __mode                => 'js_upload_file',
        blog_id               => $blog->id,
        destination           => '%a',
        auto_rename_non_ascii => 1,
    });

    my $asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($asset, 'Asset uploaded successfully');
#   ok($asset->file_name !~ /テスト/, 'Filename was renamed');

    if ($asset) {
        $asset->remove;
    }
};

subtest 'AllowNonAsciiFilename = 0' => sub {
    $test_env->update_config(AllowNonAsciiFilename => 0);

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);

    my $res = $app->js_post_ok({
        __test_upload         => [file => $test_image],
        __mode                => 'js_upload_file',
        blog_id               => $blog->id,
        destination           => '%a',
        auto_rename_non_ascii => 1,
    });

    my $hash = JSON::from_json($res->decoded_content);
    like($hash->{error}, qr/Non-ASCII/, 'Error message returned in JSON');
};

done_testing();
