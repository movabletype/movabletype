#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval 'use Test::Spec; 1'
        or plan skip_all => 'Test::Spec is not installed';
    eval 'use Imager; 1'
        or plan skip_all => 'Imager is not installed';
    plan skip_all => 'Not for Windows now' if $^O eq 'MSWin32';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(

        # to serve actual js libraries
        StaticFilePath => "MT_HOME/mt-static/",

        # ImageMagick 6.90 hangs when it tries to scale
        # the same image again (after the initialization).
        # Version 7.07 works fine. Other three drivers do, too.
        # Because Image::Magick hides its $VERSION in an
        # internal package (Image::Magick::Q16 etc), it's
        # more reliable to depend on something else.
        ImageDriver => 'Imager',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Selenium;
use MT::Test::Image;

my $blog_id = 1;

my $before_fields;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

});

my $author = MT->model('author')->load(1) or die MT->model('author')->errstr;

my ($guard, $tempfile) = MT::Test::Image->tempfile(
    DIR    => $test_env->root,
    SUFFIX => '.jpg',
);
for (my $x = 0; $x < 120; ++$x) {
    MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog_id,
        url          => "http://narnia.na/nana/images/test_${x}.jpg",
        file_path    => $tempfile,
        file_name    => "test_${x}.jpg",
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Userpic A',
        description  => 'Userpic A',
    );
}

subtest 'AssetModalVersion' => sub {
    subtest 'AssetModalVersion is default' => sub {
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($author);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_asset_modal&_type=asset&blog_id=1&dialog_view=1edit_field=editor-input-content&asset_select=1&can_multi=1&dialog=1');
        my $length = $selenium->driver->execute_script(q{return jQuery("#content-body-left").length;});
        is($length, 1, '#content-body-left not found');
        $selenium->screenshot_full;
    };
    subtest 'AssetModalVersion is 2' => sub {
        $test_env->update_config(AssetModalVersion => 2);
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($author);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_asset_modal&_type=asset&blog_id=1&dialog_view=1&edit_field=editor-input-content&asset_select=1&can_multi=1&dialog=1');
        my $length = $selenium->driver->execute_script(q{return jQuery("[data-is=assets]").length;});
        is($length, 1, '[data-is=assets] not found');
        $selenium->screenshot_full;
    };
    subtest 'AssetModalVersion is 1' => sub {
        $test_env->update_config(AssetModalVersion => 1);
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($author);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_asset_modal&_type=asset&blog_id=1&dialog_view=1edit_field=editor-input-content&asset_select=1&can_multi=1&dialog=1');
        my $length = $selenium->driver->execute_script(q{return jQuery("#content-body-left").length;});
        is($length, 1, '#content-body-left not found');
        $selenium->screenshot_full;
    };
};
subtest 'AssetModalFiestLoad' => sub {
    $test_env->update_config(AssetModalVersion => 2);
    subtest 'AssetModalFiestLoad is default' => sub {
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($author);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_asset_modal&_type=asset&blog_id=1&dialog_view=1&edit_field=editor-input-content&asset_select=1&can_multi=1&dialog=1');
        my $pages = $selenium->driver->execute_script(q{return jQuery(".pagination .mt-pager-index:last").text();});
        is($pages, 10, 'pages is 10');
        $selenium->screenshot_full;
    };
    subtest 'AssetModalFiestLoad is 60' => sub {
        $test_env->update_config(AssetModalFiestLoad => 60);
        my $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($author);
        $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_asset_modal&_type=asset&blog_id=1&dialog_view=1&edit_field=editor-input-content&asset_select=1&can_multi=1&dialog=1');
        my $pages = $selenium->driver->execute_script(q{return jQuery(".pagination .mt-pager-index:last").text();});
        is($pages, 5, 'pages is 5');
        $selenium->screenshot_full;
    };
};

done_testing;

