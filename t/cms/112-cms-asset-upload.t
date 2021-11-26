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

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);

File::Path::mkpath $blog->archive_path unless -d $blog->archive_path;

subtest 'Regular JPEG image' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    MT::Test::Image->write(file => $test_image);

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile(qw/ %a test.jpg /),
        'file_name'  => 'test.jpg',
        'url'        => '%a/test.jpg',
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

subtest 'Regular JPEG image with wrong extension' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    MT::Test::Image->write(file => $test_image);
    (my $renamed_test_image = $test_image) =~ s/test\.jpg/wrong-extension-test\.gif/;
    rename $test_image => $renamed_test_image;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
    });

    $app->content_like(
        qr/Extension changed from gif to jpg/,
        'Reported that the extension was changed'
    );

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile(qw/ %a wrong-extension-test.jpg /),
        'file_name'  => 'wrong-extension-test.jpg',
        'url'        => '%a/wrong-extension-test.jpg',
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

subtest 'Regular PDF file' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_pdf = $test_env->save_file('test.pdf', 'dummy');

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $test_pdf],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
    });
    my $expected_values = {
        'file_ext'   => 'pdf',
        'file_path'  => File::Spec->catfile(qw/ %a test.pdf /),
        'file_name'  => 'test.pdf',
        'url'        => '%a/test.pdf',
        'class'      => 'file',
        'blog_id'    => '1',
        'created_by' => '1'
    };
    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
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
