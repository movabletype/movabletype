#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
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

use MT::Test;
use MT;
use MT::Test::Selenium;

$test_env->prepare_fixture('db_data');

my $author = MT->model('author')->load(1) or die MT->model('author')->errstr;
$author->set_password('Nelson');
$author->save or die $author->errstr;

#subtest 'On Edit Image dialog (blog_id = 1, asset_id = 1)' => sub {
{
    my $selenium = MT::Test::Selenium->new($test_env);

    $selenium->visit('/cgi-bin/mt.cgi?__mode=dialog_edit_image&blog_id=1&id=1&username=Melody&password=Nelson');

    subtest 'just after opening dialog,' => sub {
        is( $selenium->find('input#resize-width')->value => 640, "resize-width text should be 640" );
        is( $selenium->find('input#resize-height')->value => 480, "resize-height text should be 480" );
        ok( $selenium->find('button#resize-apply')->attribute('disabled'), "resize-apply button should be disabled" );
        ok( $selenium->find('button#resize-reset')->attribute('disabled'), "resize-reset button should be disabled" );
    };
    subtest 'when resize width is changed to 320,' => sub {
        $selenium->find('input#resize-width')->set(320);
        is( $selenium->get_current_value('input#resize-width') => 320, "resize-width text should be 320" );
        is( $selenium->get_current_value('input#resize-height') => 240, "resize-height text should be 240" );
        ok( !$selenium->find('button#resize-apply')->attribute('disabled'), "resize-apply button should be enabled" );
        ok( !$selenium->find('button#resize-reset')->attribute('disabled'), "resize-reset button should be enabled" );
    };
    subtest 'when resize width is changed to 1280,' => sub {
        $selenium->find('input#resize-width')->set(1280);
        is( $selenium->get_current_value('input#resize-width') => 1280, "resize-width text should be 1280" );
        is( $selenium->get_current_value('input#resize-height') => 960, "resize-height text should be 960" );
        ok( $selenium->find('button#resize-apply')->attribute('disabled'), "resize-apply button should be disabled" );
        ok( !$selenium->find('button#resize-reset')->attribute('disabled'), "resize-reset button should be enabled" );
    };
};

done_testing;
