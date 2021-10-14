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

use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

subtest 'dialog_asset_modal' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'dialog_asset_modal',
        __type      => 'asset',
        edit_field  => 'editor-input-content',
        blog_id     => $blog->id,
        dialog_view => 1,
        filter      => 'class',
        filter_val  => 'image',
        can_multi   => 1,
        dialog      => 1,
    });

    $app->content_like(qr/<option value="file"/,  'has Files in Asset Type select box');
    $app->content_like(qr/<option value="video"/, 'has Videos in Asset Type select box');
    $app->content_like(qr/<option value="audio"/, 'has Audio in Asset Type select box');
    $app->content_like(qr/<option value="image"/, 'has Images in Asset Type select box');
};

subtest 'Load images by dialog_list_asset' => sub {
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $ct = MT::Test::Permission->make_content_type(
        name    => 'content type 1',
        blog_id => $website->id,
    );
    my $cf_image = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'asset_image',
        type            => 'asset_image',
    );
    my $pic1 = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $website->id,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image 1',
        description  => 'Sample Image 1',
    );
    my $pic2 = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image 2',
        description  => 'Sample Image 2',
    );
    my %dialog_list_asset_options = (
        __mode      => 'dialog_list_asset',
        _type       => 'asset',
        offset      => 0,
        dialog_view => 1,
        dialog      => 1,
        json        => 1,
        can_multi   => 0,
        filter      => 'class',
        filter_val  => 'image',
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id => $website->id,
    });
    my $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 2, "Retrieve assets include website and children");

    $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id    => $website->id,
        edit_field => 'customfield_xx',
    });
    $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 2, "Retrieve assets include website and children with custom field");

    $res = $app->post_ok({
        %dialog_list_asset_options,
        blog_id          => $website->id,
        content_field_id => $cf_image->id,
    });
    $json = MT::Util::from_json($res->decoded_content);
    is($json->{pager}{rows}, 1, "Retrieve assets include website and children with content field");
};

done_testing;
