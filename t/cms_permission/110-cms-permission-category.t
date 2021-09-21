#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    plan skip_all => 'FIXME: Not for external CGI server just for now' if $ENV{MT_TEST_RUN_APP_AS_CGI};

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
        name      => 'kumekawa',
        nicknamee => 'Saburo Kumekawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $edit_categories = MT::Test::Permission->make_role(
        name        => 'Edit Categories',
        permissions => "'edit_categories'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa => $edit_categories => $blog);
    MT::Association->link($ukawa  => $designer        => $blog);
    MT::Association->link($egawa  => $manage_pages    => $blog);

    MT::Association->link($ichikawa => $edit_categories => $second_blog);
    MT::Association->link($ichikawa => $create_post     => $blog);

    MT::Association->link($ogawa,    $edit_categories, $website);
    MT::Association->link($kumekawa, $designer,        $website);

    MT::Association->link($kagawa,  $edit_categories, $other_website);
    MT::Association->link($kikkawa, $edit_categories, $other_blog);

    # Category
    my $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
        label     => 'my category',
    );
    my $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
        label     => 'my website category',
    );

    # Folder
    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $egawa->id,
        label     => 'my folder',
    );
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

my $admin = MT::Author->load(1);

require MT::Folder;
my $cat         = MT::Category->load({ label => 'my category' });
my $website_cat = MT::Category->load({ label => 'my website category' });
my $folder      = MT::Folder->load({ label => 'my folder' });

subtest 'mode = js_add_category' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $blog->id,
        label   => 'New Label 1',
    });
    $app->has_no_permission_error("js_add_category by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $blog->id,
        label   => 'New Label 2',
    });
    $app->has_no_permission_error("js_add_category by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $blog->id,
        label   => 'New Label 3',
    });
    $app->has_permission_error("js_add_category by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $blog->id,
        label   => 'New Label 4',
    });
    $app->has_permission_error("js_add_category by other permission");
};

subtest 'mode = js_add_category (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 1',
    });
    $app->has_no_permission_error("js_add_category by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 2',
    });
    $app->has_no_permission_error("js_add_category by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 3',
    });
    $app->has_permission_error("js_add_category by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 3',
    });
    $app->has_permission_error("js_add_category by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 3',
    });
    $app->has_permission_error("js_add_category by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'js_add_category',
        blog_id => $website->id,
        label   => 'New Label 4',
    });
    $app->has_permission_error("js_add_category by other permission");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = list (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = save_cat' => sub {
    # XXX: The following tests are somewhat broken: The Category must be given a name!
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("save_cat by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("save_cat by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $blog->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by other permission");
};

subtest 'mode = save_cat (website)' => sub {
    # XXX: The following tests are somewhat broken: The Category must be given a name!
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("save_cat by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_no_permission_error("save_cat by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save_cat',
        blog_id => $website->id,
        _type   => 'category',
    });
    $app->has_permission_error("save_cat by other permission");
};

subtest 'mode = bulk_update_category' => sub {
    # XXX: The following tests are somewhat broken:
    # Failed to update Categories: Some of Categories were changed after you opened this page.
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $blog->id,
        datasource => 'category',
    });
    $app->has_no_permission_error("bulk_update_category by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $blog->id,
        datasource => 'category',
    });
    $app->has_no_permission_error("bulk_update_category by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $blog->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $blog->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by other permission");
};

subtest 'mode = bulk_update_category (website)' => sub {
    # XXX: The following tests are somewhat broken:
    # Failed to update Categories: Some of Categories were changed after you opened this page.
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_no_permission_error("bulk_update_category by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_no_permission_error("bulk_update_category by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode     => 'bulk_update_category',
        blog_id    => $website->id,
        datasource => 'category',
    });
    $app->has_permission_error("bulk_update_category by other permission");
};

subtest 'mode = save (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by other permission");
};

subtest 'mode = save (new, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_permission_error("save (new) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("save (new) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_permission_error("save (new) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
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
        _type   => 'category',
        label   => 'CategoryName',
        id      => $cat->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $cat->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $cat->id,
    });
    $app->has_permission_error("save (edit) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $cat->id,
    });
    $app->has_permission_error("save (edit) by other permission");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $folder->id,
    });
    $app->has_permission_error("save (edit) by type mismatch");
};

subtest 'mode = save (edit, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_permission_error("save (edit) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_permission_error("save (edit) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_permission_error("save (edit) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $website_cat->id,
    });
    $app->has_permission_error("save (edit) by other permission");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
        id      => $folder->id,
    });
    $app->has_permission_error("save (edit) by type mismatch");
};

subtest 'mode = edit (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by other permission");
};

subtest 'mode = edit (new, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_permission_error("edit (new) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_permission_error("edit (new) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        label   => 'CategoryName',
    });
    $app->has_invalid_request("edit (new) by other permission");
};

subtest 'mode = edit (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_permission_error("edit (edit) by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_permission_error("edit (edit) by other permission");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $folder->id,
    });
    $app->has_permission_error("edit (edit) by type mismatch");
};

subtest 'mode = edit (edit, website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("edit (edit) by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("edit (edit) by child blog");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("edit (edit) by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("edit (edit) by other permission");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $website->id,
        _type   => 'category',
        id      => $folder->id,
    });
    $app->has_permission_error("edit (edit) by type mismatch");
};

subtest 'mode = delete ' => sub {
    my $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_no_permission_error("delete  by admin");

    $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_no_permission_error("delete  by permitted user");

    $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_permission_error("delete  by other blog");

    $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_permission_error("delete  by other permission");

    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $egawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $folder->id,
    });
    $app->has_permission_error("delete  by type mismatch");
};

subtest 'mode = delete (website)' => sub {
    my $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("delete  by admin");

    $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_no_permission_error("delete  by permitted user");

    $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("delete  by other website");

    $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("delete  by child blog");

    $website_cat = MT::Test::Permission->make_category(
        blog_id   => $website->id,
        author_id => $ogawa->id,
    );
    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $website_cat->id,
    });
    $app->has_permission_error("delete  by other blog");

    my $cat = MT::Test::Permission->make_category(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'category',
        id      => $cat->id,
    });
    $app->has_permission_error("delete  by other permission");

    my $folder = MT::Test::Permission->make_folder(
        blog_id   => $blog->id,
        author_id => $egawa->id,
    );
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $website->id,
        _type   => 'category',
        id      => $folder->id,
    });
    $app->has_permission_error("delete  by type mismatch");
};

done_testing();
