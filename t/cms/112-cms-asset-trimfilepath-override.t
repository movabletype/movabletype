#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    plan skip_all => 'Not for Win32 (illegal paths)' if $^O eq 'MSWin32';
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Spec;
use File::Path;

use MT::Test;
use MT::Test::Image;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

# Override explicitly
MT->config->TrimFilePath(0, 1);
MT->config->save_config;

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
        'file_path'  => File::Spec->catfile('%a', ' test-1.jpg'),
        'file_name'  => ' test-1.jpg',
        'url'        => ('%a/ test-1.jpg' =~ s/ /%20/gr)
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
        'file_path'  => File::Spec->catfile('%a', 'test-2.jpg .jpg'),
        'file_name'  => 'test-2.jpg .jpg',
        'url'        => ('%a/test-2.jpg .jpg' =~ s/ /%20/gr)
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

subtest "'destination' with spaces (Testing for 'Custom')" => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('destination-with-spaces.jpg');
    MT::Test::Image->write(file => $test_image);

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a/ yyyy/mm / dd ',
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');

    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile('%a', ' yyyy', 'mm ', ' dd ', 'destination-with-spaces.jpg'),
        'file_name'  => 'destination-with-spaces.jpg',
        'url'        => '%a/ yyyy/mm / dd /destination-with-spaces.jpg'
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

subtest "'extra_path' with spaces" => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('extra-path-with-spaces.jpg');
    MT::Test::Image->write(file => $test_image);

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
        extra_path    => ' a/b / c ',
    });

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');

    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile('%a', ' a', 'b ', ' c ', 'extra-path-with-spaces.jpg'),
        'file_name'  => 'extra-path-with-spaces.jpg',
        'url'        => '%a/ a/b / c /extra-path-with-spaces.jpg'
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
