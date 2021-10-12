#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
plan tests => 1;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

my $asset = MT::Test::Permission->make_asset(
    class     => 'image',
    blog_id   => $blog->id,
    url       => 'http://narnia.na/nana/images/test.jpg',
    file_path =>
      File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
    file_name    => 'test.jpg',
    file_ext     => 'jpg',
    image_width  => 640,
    image_height => 480,
    mime_type    => 'image/jpeg',
    label        => 'Userpic A',
    description  => 'Userpic A',
);
my $asset_id = $asset->id;
subtest 'dialog_asset_modal' => sub {
    my %params = (
           __test_user      => $admin,
            __request_method => 'POST',
            __mode       => 'dialog_insert_options',
            __type       => 'asset',
            blog_id      => $blog->id,
            dialog_view  => 1,
            no_insert    => 0,
            dialog       => 1,
            id           => $asset_id,
            edit_field   => 'editor-input-content',
            force_insert => 1,
            entry_insert => 1,
 
    );
    
    subtest 'check image popup enabled' => sub {
        my $app = _run_app('MT::App::CMS', \%params);
        my $out = delete $app->{__test_output};
        like( $out, qr/id="link_to_popup-${asset_id}"/, 'output' );
    };
    subtest 'change DisableImagePopup 1' => sub {
        $mt->config( "DisableImagePopup", 1 );
        my $app = _run_app('MT::App::CMS', \%params);
        my $out = delete $app->{__test_output};
        unlike( $out, qr/id="link_to_popup-${asset_id}"/, 'output' );
        $mt->config( "DisableImagePopup", 1 );
    };

    subtest 'remove popup_image template' => sub {
        $mt->model('template')->remove(
            {
                blog_id => $blog->id,
                type    => 'popup_image'
            }
        );
        my $app = _run_app('MT::App::CMS', \%params);
        my $out = delete $app->{__test_output};
        unlike( $out, qr/id="link_to_popup-${asset_id}"/, 'output' );
    };
};

done_testing();
