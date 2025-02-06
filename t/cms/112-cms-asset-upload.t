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
use Image::ExifTool;

my $has_image_magick = eval { require Image::Magick; 1 };
my $image_driver     = MT->config->ImageDriver;

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

subtest 'Regular JPEG image, wrt exif removal' => sub {
    my $org_force_exif_removal = MT->config('ForceExifRemoval');
    my $asset_dir              = File::Spec->catdir($blog->archive_path, 'assets_c');

    for my $exif_removal (0, 1) {
        my $name         = 'test_' . ($exif_removal ? 'without' : 'with') . '_exif';
        my $newest_asset = MT::Asset->load(
            { class => '*' },
            { sort  => [{ column => 'id', desc => 'DESC' }] },
        );

        my $test_image = $test_env->path("$name.jpg");
        MT::Test::Image->write(file => $test_image);
        my $tool = Image::ExifTool->new;
        $tool->ExtractInfo($test_image);
        $tool->SetNewValue(Comment => 'mt_test');
        $tool->SetNewValue('EXIF:Orientation' => 'Horizontal (normal)');
        $tool->WriteInfo($test_image);

        my $org_exif = Image::ExifTool::ImageInfo($test_image);
        ok $org_exif->{ProfileCMMType}, "test image has profile information in exif";
        is $org_exif->{Comment} => 'mt_test', "test image has Comment in exif";
        is $org_exif->{Orientation} => 'Horizontal (normal)', "test image has Orientation in exif";

        $test_env->update_config(ForceExifRemoval => $exif_removal);

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
            'file_path'  => File::Spec->catfile('%a', "$name.jpg"),
            'file_name'  => "$name.jpg",
            'url'        => '%a/' . "$name.jpg",
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

        my ($thumbnail)   = grep /$name/, $test_env->files($asset_dir);
        my $uploaded_file = File::Spec->catfile($blog->archive_path, "$name.jpg");

        for my $item (['uploaded file' => $uploaded_file], [thumbnail => $thumbnail]) {
            my ($key, $file) = @$item;
            my $exif = Image::ExifTool::ImageInfo($file);
            if ($exif_removal or $key eq 'thumbnail') {
                ok !$exif->{Comment}, "$key has no Comment in exif" or note explain $exif;
                SKIP: {
                    # FIXME
                    local $TODO = 'Only for ImageMagick driver' unless $image_driver =~ /ImageMagick/;
                    ok $exif->{ProfileCMMType}, "but $key still has profile information in exif";
                }
                is $exif->{Orientation} => 'Horizontal (normal)', "but $key still has orientation information in exif";
                SKIP: {
                    if ($has_image_magick) {
                        # FIXME
                        local $TODO = 'Only for ImageMagick driver' unless $image_driver =~ /ImageMagick/;
                        my $magick = Image::Magick->new;
                        $magick->Read($file);
                        ok $magick->Get('icc'), "Image::Magick still returns icc";
                    }
                }
            } else {
                is $exif->{Comment} => 'mt_test', "$key still has Comment in exif";
                SKIP: {
                    local $TODO = 'Only for *Magick driver' unless $image_driver =~ /Magick/;
                    ok $exif->{ProfileCMMType}, "$key still has profile information in exif";
                }
                is $exif->{Orientation} => 'Horizontal (normal)', "but $key still has orientation information in exif";
                SKIP: {
                    if ($has_image_magick) {
                        local $TODO = 'Only for *Magick driver' unless $image_driver =~ /Magick/;
                        my $magick = Image::Magick->new;
                        $magick->Read($file);
                        ok $magick->Get('icc'), "Image::Magick returns icc";
                    }
                }
            }
        }
    }
    $test_env->update_config(ForceExifRemoval => $org_force_exif_removal);
};

subtest 'Regular JPEG image with wrong extension' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('wrong-extension-test.jpg');
    MT::Test::Image->write(file => $test_image);
    (my $renamed_test_image = $test_image) =~ s/\.jpg/.gif/;
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

subtest 'Regular JPEG image with wrong extension separator' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('wrong-extension-separator.jpg');
    MT::Test::Image->write(file => $test_image);
    (my $renamed_test_image = $test_image) =~ s/\.jpg/-jpg/;
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
        qr/Extension changed from none to jpg/,
        'Reported that the extension was changed'
    );

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile(qw/ %a wrong-extension-separator-jpg.jpg /),
        'file_name'  => 'wrong-extension-separator-jpg.jpg',
        'url'        => '%a/wrong-extension-separator-jpg.jpg',
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

subtest 'Regular JPEG image with string added like extension' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('string-added-like-extension.jpg');
    MT::Test::Image->write(file => $test_image);
    my $renamed_test_image = $test_env->path('test.bak');
    rename $test_image => $renamed_test_image or die $!;

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->js_post_ok({
        __test_upload => [file => $renamed_test_image],
        __mode        => 'js_upload_file',
        blog_id       => $blog->id,
        destination   => '%a',
    });

    $app->content_like(
        qr/Extension changed from none to jpg/,
        'Reported that the extension was changed'
    );

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile(qw/ %a test.bak.jpg /),
        'file_name'  => 'test.bak.jpg',
        'url'        => '%a/test.bak.jpg',
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

subtest 'Regular JPEG image with extension string being filename' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $test_image = $test_env->path('extension-string-being-filename.jpg');
    MT::Test::Image->write(file => $test_image);
    my $renamed_test_image = $test_env->path('jpg');
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
        qr/Extension changed from none to jpg/,
        'Reported that the extension was changed'
    );

    my $created_asset = MT::Asset->load(
        { id   => { '>' => $newest_asset->id } },
        { sort => [{ column => 'id', desc => 'DESC' }] },
    );
    ok($created_asset, 'An asset is created');
    my $expected_values = {
        'file_ext'   => 'jpg',
        'file_path'  => File::Spec->catfile(qw/ %a jpg.jpg /),
        'file_name'  => 'jpg.jpg',
        'url'        => '%a/jpg.jpg',
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

subtest 'Show edit page' => sub {
    my $newest_asset = MT::Asset->load(
        { class => '*' },
        { sort  => [{ column => 'id', desc => 'DESC' }] },
    );

    my $app = MT::Test::App->new('CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $blog->id,
        id      => $newest_asset->id,
        _type   => 'asset',
    });
};

done_testing();
