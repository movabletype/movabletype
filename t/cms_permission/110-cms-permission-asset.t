#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    # Disable Commercial.pack temporarily.
    $test_env->skip_if_addon_exists('Commercial.pack');
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $ogawa = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro ogawa',
    );

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
    );

    my $admin = MT::Author->load(1);

    # Asset
    my $pic = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => 0,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Userpic A',
        description  => 'Userpic A',
    );
    $pic->tags('@userpic');
    $pic->save;

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
        label        => 'Sample Image',
        description  => 'Sample Image',
    );

    my $file1 = MT::Test::Permission->make_asset(
        class       => 'file',
        blog_id     => $blog->id,
        url         => 'http://narnia.na/nana/files/test.pdf',
        file_path   => File::Spec->catfile($ENV{MT_HOME}, "t", 'files', 'test.pdf'),
        file_name   => 'test.pdf',
        file_ext    => 'pdf',
        mime_type   => 'application/pdf',
        label       => 'Sample File',
        description => 'Sample PDF File',
    );

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $edit_assets = MT::Test::Permission->make_role(
        name        => 'Edit Assets',
        permissions => "'edit_assets', 'upload'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $create_post  => $blog);
    MT::Association->link($ichikawa => $manage_pages => $blog);
    MT::Association->link($ukawa    => $create_post  => $second_blog);
    MT::Association->link($egawa    => $manage_pages => $second_blog);
    MT::Association->link($ogawa    => $designer     => $blog);
    MT::Association->link($kagawa   => $edit_assets  => $blog);
    MT::Association->link($kikkawa  => $edit_assets  => $second_blog);
    MT::Association->link($kumekawa => $edit_assets  => $blog);
    MT::Association->link($kumekawa => $create_post  => $blog);
    MT::Association->link($kemikawa => $edit_assets  => $second_blog);
    MT::Association->link($kemikawa => $create_post  => $second_blog);
});

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });
my $kagawa   = MT::Author->load({ name => 'kagawa' });
my $kikkawa  = MT::Author->load({ name => 'kikkawa' });
my $kumekawa = MT::Author->load({ name => 'kumekawa' });
my $kemikawa = MT::Author->load({ name => 'kemikawa' });

my $admin = MT::Author->load(1);

my $pic   = MT::Asset::Image->load({ label => 'Userpic A' });
my $pic2  = MT::Asset::Image->load({ label => 'Sample Image' });
my $file1 = MT::Asset->load({ label => 'Sample File' });

subtest 'mode = asset_userpic' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'asset_userpic',
        id      => $pic->id,
        user_id => $admin->id,
    });
    $app->has_no_permission_error("asset_userpic by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'asset_userpic',
        id      => $pic->id,
        user_id => $aikawa->id,
    });
    $app->has_no_permission_error("asset_userpic by myself");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'asset_userpic',
        id      => $pic->id,
        user_id => $aikawa->id,
    });
    $app->has_permission_error("asset_userpic by other user");
};

subtest 'mode = complete_upload' => sub {

    # By admin

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'complete_upload',
        id      => $pic2->id,
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("complete_upload by admin");

    # By Permitted user
    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'complete_upload',
        id      => $pic2->id,
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("complete_upload by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'complete_upload',
        id      => $pic2->id,
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("complete_upload by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'complete_upload',
        id      => $pic2->id,
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("complete_upload by other permission");
};

subtest 'mode = dialog_asset_modal' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode     => 'dialog_asset_modal',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->content_like(
        qr!<div id="content-body-left"!i,
        "dialog_asset_modal by admin"
    );

    # By create_post
    $app->login($aikawa);
    $app->get_ok({
        __mode     => 'dialog_asset_modal',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->content_like(
        qr!name="select_asset" id="select_asset"!i,
        "dialog_asset_modal by create_post"
    );

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode     => 'dialog_asset_modal',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->has_permission_error("dialog_asset_modal by other blog");

    # By edit_assets
    $app->login($kagawa);
    $app->get_ok({
        __mode     => 'dialog_asset_modal',
        edit_field => 'customfield_test',
        label      => 'New Label',
        blog_id    => $blog->id,
    });
    $app->has_permission_error("dialog_asset_modal by edit_assets");
};

subtest 'mode = dialog_list_asset' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode     => 'dialog_list_asset',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->has_no_permission_error("XXX");
    $app->content_like(
        qr!<div id="content-body-left"!i,
        "dialog_list_asset by admin"
    );

    # By create_post
    $app->login($aikawa);
    $app->get_ok({
        __mode     => 'dialog_list_asset',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->has_no_permission_error("XXX");
    $app->content_like(
        qr!name="select_asset" id="select_asset"!i,
        "dialog_list_asset by create_post"
    );

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode     => 'dialog_list_asset',
        edit_field => 'customfield_test',
        blog_id    => $blog->id,
    });
    $app->has_permission_error("dialog_list_asset by other blog");

    # By edit_assets
    $app->login($kagawa);
    $app->get_ok({
        __mode     => 'dialog_list_asset',
        edit_field => 'customfield_test',
        label      => 'New Label',
        blog_id    => $blog->id,
    });
    $app->has_permission_error("dialog_list_asset by edit_assets");
};

subtest 'mode = asset_insert' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("asset_insert by admin");

    # By Permitted user(A)
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("asset_insert by permitted user (create_post)");

    # By Permitted user(B)
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("asset_insert by permitted user (manage_pages)");

    # By non Permitted user(A)
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("asset_insert by other blog (create_post)");

    # By non Permitted user(B)
    $app->login($egawa);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("asset_insert other blog (manage_pages)");

    # By other permission
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'asset_insert',
        id      => $pic2->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("asset_insert by other permission");
};

subtest 'mode = list' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        label   => 'New Label',
        blog_id => $blog->id,
        _type   => 'asset',
    });
    $app->has_no_permission_error("list by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'list',
        label   => 'New Label',
        blog_id => $blog->id,
        _type   => 'asset',
    });
    $app->has_no_permission_error("list by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'list',
        label   => 'New Label',
        blog_id => $blog->id,
        _type   => 'asset',
    });
    $app->has_permission_error("list by other blog");

    # By other permission
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        label   => 'New Label',
        blog_id => $blog->id,
        _type   => 'asset',
    });
    $app->has_no_permission_error("list by other permission");
};

subtest 'mode = start_upload' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_upload',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_upload by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'start_upload',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_upload by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'start_upload',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_upload by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_upload',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_upload by other permission");
};

subtest 'mode = start_upload_entry' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_upload_entry',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("start_upload_entry by admin");

    # By Permitted user
    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'start_upload_entry',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("start_upload_entry by permitted user");

    # By non Permitted user
    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'start_upload_entry',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("start_upload_entry by other blog");

    # By other permission
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'start_upload_entry',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("start_upload_entry by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'start_upload_entry',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("start_upload_entry by other permission");
};

subtest 'mode = upload_file' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'upload_file',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("upload_file by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'upload_file',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("upload_file by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'upload_file',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("upload_file by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'upload_file',
        label   => 'New Label',
        blog_id => $blog->id,
    });
    $app->has_permission_error("upload_file by other permission");
};

subtest 'mode = view' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("view by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("view by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("view by other blog");

    # By other permission
    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'asset',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("view by other permission");
};

subtest 'mode = view (type is file)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view file by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view file by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("view file by other blog");

    # By other permission
    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'file',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view file by other permission");
};

subtest 'mode = view (type is image)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view image by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view image by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("view image by other blog");

    # By other permission
    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'image',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view image by other permission");
};

subtest 'mode = view (type is audio)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view audio by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view audio by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("view audio by other blog");

    # By other permission
    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'audio',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view audio by other permission");
};

subtest 'mode = view (type is video)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view video by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view video by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("view video by other blog");

    # By other permission
    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'video',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("view video by other permission");
};

subtest 'mode = save' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("save by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_no_permission_error("save by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("save by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'asset',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $pic2->id,
    });
    $app->has_permission_error("save by other permission");
};

subtest 'mode = save (type is file)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("save by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'file',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by other permission");
};

subtest 'mode = save (type is image)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("save by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'image',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by other permission");
};

subtest 'mode = save (type is audio)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("save by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'audio',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by other permission");
};

subtest 'mode = save (type is video)' => sub {

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("save by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'video',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("save by other permission");
};

subtest 'mode = delete' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test2.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test2.jpg'),
        file_name    => 'test2.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $asset->id,
    });
    $app->has_no_permission_error("delete by admin");

    $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test2.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test2.jpg'),
        file_name    => 'test2.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $asset->id,
    });
    $app->has_no_permission_error("delete by permitted user");

    $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test2.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test2.jpg'),
        file_name    => 'test2.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'asset',
        blog_id => $blog->id,
        id      => $asset->id,
    });
    $app->has_permission_error("delete by other blog");

    $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test2.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test2.jpg'),
        file_name    => 'test2.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'asset',
        label   => 'New Label',
        blog_id => $blog->id,
        id      => $asset->id,
    });
    $app->has_permission_error("delete by other permission");
};

subtest 'mode = delete (file)' => sub {
    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("delete by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'file',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by other permission");
};

subtest 'mode = delete (image)' => sub {
    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("delete by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'image',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by other permission");
};

subtest 'mode = delete (audio)' => sub {
    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("delete by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'audio',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by other permission");
};

subtest 'mode = delete (video)' => sub {
    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_permission_error("delete by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'video',
        blog_id => $blog->id,
        id      => $file1->id,
    });
    $app->has_invalid_request("delete by other permission");
};

subtest 'mode = add_tags' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other permission");
};

subtest 'mode = remove_tags' => sub {
    my $asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $blog->id,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Sample Image',
        description  => 'Sample photo',
    );

    # By admin
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by admin");

    # By Permitted user
    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user");

    # By non Permitted user
    $app->login($kikkawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other blog");

    # By other permission
    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'asset',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_asset%26blog_id%3D' . $blog->id,
        blog_id                => $blog->id,
        id                     => $asset->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other permission");
};

done_testing();
