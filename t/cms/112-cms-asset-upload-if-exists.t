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

use File::Spec;
use File::Path;

use MT::Test;
use MT::Test::Image;
use MT::Test::App;
use File::Copy qw(copy);

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);

File::Path::mkpath $blog->archive_path unless -d $blog->archive_path;

subtest 'Without "auto_rename_if_exists"' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    MT::Test::Image->write(file => $test_image);

    copy($test_image, $test_env->path('site/archives/test.jpg'));

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->post_ok({
        __test_upload => [file => $test_image],
        __mode        => 'upload_file',
        blog_id       => $blog->id,
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }], });
    ok(!$created_asset, 'Not created');
};

subtest 'With "auto_rename_if_exists"' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    MT::Test::Image->write(file => $test_image);

    copy($test_image, $test_env->path('site/archives/test.jpg'));

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->post_ok({
            __mode                => 'upload_file',
            blog_id               => $blog->id,
            __test_upload         => [file => $test_image],
            auto_rename_if_exists => 1,
        },
    );

    my ($uploaded_file) = grep /[0-9a-z]{40}\.jpg$/, $test_env->files($blog->archive_path);

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'Created');
    my $replaced_basename = File::Basename::basename($uploaded_file);
    my $expected_values   = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile('%a', $replaced_basename),
        'file_name'  => $replaced_basename,
        'url'        => '%a/' . $replaced_basename,
        'class'      => 'image',
        'blog_id'    => '1',
        'created_by' => '1'
    };
    my $result_values = do {
        return +{} unless $created_asset;
        my $values = $created_asset->column_values();
        +{ map { $_ => $values->{$_} } keys %$expected_values };
    };
    is_deeply(
        $result_values, $expected_values,
        "Created asset's column values"
    );
};

done_testing();
