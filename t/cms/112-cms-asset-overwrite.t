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

subtest 'Upload asset(overwrite image with document)' => sub {
    subtest 'first upload with image file' => sub {
        my $image_file = prepare_file('test.jpg', file_type => 'image');
        my $image_asset = upload_asset($image_file);
        isa_ok($image_asset, 'MT::Asset::Image');
        is $image_asset->file_name, 'test.jpg', 'asset file_name should be "test.jpg"';
        is $image_asset->label,     'test.jpg', 'asset label should be "test.jpg"';
    };

    subtest 'overwrite with document file' => sub {
        my $doc_file = prepare_file('test.jpg', file_type => 'document');
        my $doc_asset = upload_asset($doc_file);
        isa_ok($doc_asset, 'MT::Asset');
        is $doc_asset->file_name, 'test.jpg', 'asset file_name should still be "test.jpg"';
        is $doc_asset->label,     'test.jpg', 'asset label should still be "test.jpg"';

        my $overwritten_asset = MT->model('asset.image')->load({ file_name => 'test.jpg' });
        is $overwritten_asset->id, $doc_asset->id, 'Asset ID remains the same after overwrite';
    };
};

subtest 'Upload asset(overwrite document with image)' => sub {
    subtest 'first upload with document file' => sub {
        my $doc_file = prepare_file('test.txt', file_type => 'document');
        my $doc_asset = upload_asset($doc_file);
        isa_ok($doc_asset, 'MT::Asset');
        is $doc_asset->file_name, 'test.txt', 'asset file_name should be "test.txt"';
        is $doc_asset->label,     'test.txt', 'asset label should be "test.txt"';
    };

    subtest 'overwrite with image file' => sub {
        # rename extension
        my $image_file = $test_env->path('test.jpg');
        (my $renamed_image_file = $image_file) =~ s/\.jpg/.txt/;
        rename $image_file => $renamed_image_file;
        my $image_asset = upload_asset($renamed_image_file);
        is $image_asset->file_name, 'test.txt', 'asset file_name should still be "test.txt"';
        is $image_asset->label,     'test.txt', 'asset label should still be "test.txt"';

        my $overwritten_asset = MT->model('asset')->load({ file_name => 'test.txt' });
        is $overwritten_asset->id, $image_asset->id, 'Asset ID remains the same after overwrite';
    };
};

sub prepare_file {
    my ($file, %options) = @_;

    my $file_type = $options{file_type} || 'image';

    require Encode;
    $file = Encode::encode($^O eq 'MSWin32' ? 'cp932' : 'utf-8' => $file);

    my $test_file = $test_env->path($file);
    
    if ($file_type eq 'image') {
        MT::Test::Image->write(file => $test_file);
    } elsif ($file_type eq 'document') {
        $test_env->save_file($file, 'dummy');
    }
    $test_file;
}

sub upload_asset {
    my $file = shift;

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $res = $app->post_ok({
        __mode        => 'js_upload_file',
        blog_id       => $blog_id,
        destination   => '%s',
        __test_upload => [
            'file',
            $file,
        ],
        operation_if_exists   => 2, # Overwrite
    });

    my $hash     = JSON::from_json($res->decoded_content);
    my $asset_id = $hash->{result}{asset}{id};
    $asset_id
        ? MT->model('asset.image')->load($asset_id)
        : undef;
}

done_testing;
