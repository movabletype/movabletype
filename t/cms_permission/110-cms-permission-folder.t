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
    my $other_website = MT::Test::Permission->make_website(
        name => 'other website',
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
    my $other_blog = MT::Test::Permission->make_blog(
        parent_id => $other_website->id,
        name      => 'other blog',
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
        nickname => 'Goro Ogawa',
    );

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );
    my $edit_categories = MT::Test::Permission->make_role(
        name        => 'Edit Categories',
        permissions => "'edit_categories'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $manage_pages    => $blog);
    MT::Association->link($ichikawa => $manage_pages    => $second_blog);
    MT::Association->link($ukawa    => $designer        => $blog);
    MT::Association->link($egawa    => $edit_categories => $blog);

    MT::Association->link($ogawa,    $manage_pages, $website);
    MT::Association->link($kumekawa, $designer,     $website);

    MT::Association->link($kagawa,  $manage_pages, $other_website);
    MT::Association->link($kikkawa, $manage_pages, $other_blog);

    # Category
    my $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $egawa->id,
        label     => 'my category',
    );

    # Folder
    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
        label     => 'my folder',
    );
    my $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
        label     => 'my website folder',
    );
});

my $website       = MT::Website->load({ name => 'my website' });
my $other_website = MT::Website->load({ name => 'other website' });

my $blog        = MT::Blog->load({ name => 'my blog' });
my $second_blog = MT::Blog->load({ name => 'second blog' });
my $other_blog  = MT::Blog->load({ name => 'other blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });
my $kagawa   = MT::Author->load({ name => 'kagawa' });
my $kikkawa  = MT::Author->load({ name => 'kikkawa' });
my $kumekawa = MT::Author->load({ name => 'kumekawa' });

my $admin = MT::Author->load(1);

require MT::Folder;
my $cat            = MT::Category->load({ label => 'my category' });
my $folder         = MT::Folder->load({ label => 'my folder' });
my $website_folder = MT::Folder->load({ label => 'my website folder' });

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'folder',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'folder',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = list (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'folder',
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = save (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("save (new) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by other permission");
};

subtest 'mode = save (new, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("save (new) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("save (new) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("save (new) by other permission");
};

subtest 'mode = save (edit)' => sub {
    # XXX: The following tests are somewhat broken: Your Dashboard has been updated.
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $folder->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $folder->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $folder->id,
    });
    $app->has_permission_error("save (edit) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $folder->id,
    });
    $app->has_permission_error("save (edit) by other permission");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $cat->id,
    });
    $app->has_permission_error("save (edit) by type mismatch");
};

subtest 'mode = save (edit, website)' => sub {
    # XXX: The following tests are somewhat broken: Your Dashboard has been updated.
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_permission_error("save (edit) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_permission_error("save (edit) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_permission_error("save (edit) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $website_folder->id,
    });
    $app->has_permission_error("save (edit) by other permission");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
        id      => $cat->id,
    });
    $app->has_permission_error("save (edit) by type mismatch");
};

subtest 'mode = edit (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("edit (new) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by other permission");
};

subtest 'mode = edit (new, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("edit (new) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_permission_error("edit (new) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        label   => 'FolderName',
    });
    $app->has_invalid_request("edit (new) by other permission");
};

subtest 'mode = edit (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_permission_error("edit (edit) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_permission_error("edit (edit) by other permission");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $cat->id,
    });
    $app->has_permission_error("edit (edit) by type mismatch");
};

subtest 'mode = edit (edit, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("edit (edit) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("edit (edit) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("edit (edit) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("edit (edit) by other permission");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $cat->id,
    });
    $app->has_permission_error("edit (edit) by type mismatch");
};

subtest 'mode = delete ' => sub {
    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_no_permission_error("delete  by admin");

    $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_no_permission_error("delete  by permitted user");

    $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_permission_error("delete  by other blog");

    $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $folder->id,
    });
    $app->has_permission_error("delete  by other permission");

    $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'folder',
        id      => $cat->id,
    });
    $app->has_permission_error("delete  by type mismatch");
};

subtest 'mode = delete (website)' => sub {
    my $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("delete  by admin");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_no_permission_error("delete  by permitted user");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("delete  by other website");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("delete  by child blog");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("delete  by other blog");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $website_folder->id,
    });
    $app->has_permission_error("delete  by other permission");

    $website_folder = MT::Test::Permission->make_folder(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'folder',
        id      => $cat->id,
    });
    $app->has_permission_error("delete  by type mismatch");
};

done_testing();
