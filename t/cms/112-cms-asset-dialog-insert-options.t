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
use File::Temp qw( tempfile );

use MT::Test;
use MT::Test::App;
use MT::Test::Permission;
use MT::Test::Image;

$test_env->prepare_fixture('db_data');

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

my ($guard, $tempfile) = MT::Test::Image->tempfile(
    DIR    => $test_env->root,
    SUFFIX => '.jpg',
);
my $asset = MT::Test::Permission->make_asset(
    class        => 'image',
    blog_id      => $blog->id,
    url          => 'http://narnia.na/nana/images/test.jpg',
    file_path    => $tempfile,
    file_name    => 'test.jpg',
    file_ext     => 'jpg',
    image_width  => 640,
    image_height => 480,
    mime_type    => 'image/jpeg',
    label        => 'Userpic A',
    description  => 'Userpic A',
);
subtest 'Check disable image popup' => sub {
    my %params = (
        __mode       => 'dialog_insert_options',
        __type       => 'asset',
        blog_id      => $blog->id,
        dialog_view  => 1,
        no_insert    => 0,
        dialog       => 1,
        id           => $asset->id,
        edit_field   => 'editor-input-content',
        force_insert => 1,
        entry_insert => 1,
    );
    my $elm_id = "#image_default_link_popup-" . $asset->id;
    subtest 'check image popup enabled' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok(\%params);
        note $app->wq_find($elm_id)->as_html;
        is($app->wq_find($elm_id)->size, 1, 'image popup check is show');
    };

    subtest 'change DisableImagePopup 1' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $test_env->update_config(DisableImagePopup => 1);
        $app->post_ok(\%params);
        note $app->wq_find($elm_id)->as_html;
        is($app->wq_find($elm_id)->size, 0, 'image popup check is hide');
        $test_env->update_config(DisableImagePopup => 0);
    };

    subtest 'empty popup_image template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        my $tmpl = $mt->model('template')->load({
            blog_id => $blog->id,
            type    => 'popup_image'
        });
        $tmpl->text('');
        $tmpl->save;
        $app->post_ok(\%params);
        note $app->_find_text('.custom-control .alert');
        is($app->_find_text('.custom-control .alert'), q{'Popup image' template does not exist or is empty and cannot be selected.}, 'empty error');
    };

    subtest 'remove popup_image template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $mt->model('template')->remove({
            blog_id => $blog->id,
            type    => 'popup_image'
        });
        $app->post_ok(\%params);
        note $app->_find_text('.custom-control .alert');
        is $app->_find_text('.custom-control .alert'), q{'Popup image' template does not exist or is empty and cannot be selected.}, 'empty error';
    };

};

done_testing;
