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

MT->config('TrimFilePath' => 1);
is(MT->config('TrimFilePath') => 1, "TrimFilePath is set correctly");

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
my $blog  = MT::Blog->load(1);

subtest 'File name with leading spaces' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    MT::Test::Image->write(file => $test_image);
    (my $renamed_test_image = $test_image) =~ s/test\.jpg$/ test-1.jpg/;
    rename $test_image => $renamed_test_image;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
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
        'file_path'  => File::Spec->catfile(qw/ %a test-1.jpg /),
        'file_name'  => 'test-1.jpg',
        'url'        => '%a/test-1.jpg'
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

subtest 'File name with trailing spaces (wrong extension)' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test-2.jpg');
    MT::Test::Image->write(file => $test_image);
    my $renamed_test_image = $test_image . " ";
    rename $test_image => $renamed_test_image;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
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
        'file_path'  => File::Spec->catfile(qw/ %a test-2.jpg /),
        'file_name'  => 'test-2.jpg',
        'url'        => '%a/test-2.jpg'
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

subtest "Exists after applying path_trim without operation_if_exists param" => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    (my $renamed_test_image = $test_image) =~ s/test\.jpg$/ test-1.jpg/;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok(!$created_asset, 'Not created');
};

subtest '"Exists after applying path_trim with "Auto-rename"' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test.jpg');
    (my $renamed_test_image = $test_image) =~ s/test\.jpg$/ test-1.jpg/;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
        operation_if_exists => 1,    # Upload and rename
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');

    my $file_name = do {
        return "" unless $created_asset;
        my $values = $created_asset->column_values();
        $values->{file_name};
    };

    like( $file_name, qr/[0-9a-z]{40}\.jpg$/, 'Auto rename applyied' );
};

subtest '"Exists after applying path_trim with "Overwrite, do nothing"' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('test-2.jpg');
    my $renamed_test_image = $test_image . " ";

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
        operation_if_exists => 2,    # Overwrite
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok(!$created_asset, 'Overwrite, do nothing');
};

done_testing();
