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
        nickname => 'saburo Kumekawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $designer   = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $site_admin => $blog);
    MT::Association->link($ichikawa => $site_admin => $website);
    MT::Association->link($ogawa    => $site_admin => $second_blog);
    MT::Association->link($kumekawa => $designer   => $blog);
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });
my $kagawa   = MT::Author->load({ name => 'kagawa' });
my $kikkawa  = MT::Author->load({ name => 'kikkawa' });
my $kumekawa = MT::Author->load({ name => 'kumekawa' });

my $admin = MT::Author->load(1);

subtest 'mode = adjust_sitepath' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'adjust_sitepath',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("adjust_sitepath by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'adjust_sitepath',
        blog_id => $blog->id,
    });
    $app->has_permission_error("adjust_sitepath by non permitted user");
};

subtest 'mode = backup' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("backup by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("backup by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("backup by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $website->id,
    });
    $app->has_permission_error("backup by non permitted user on website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup by non permitted user on blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup by other permission");
};

subtest 'mode = backup_download' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("backup_download by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("backup_download by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("backup_download by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $website->id,
    });
    $app->has_permission_error("backup_download by non permitted user on website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup_download by non permitted user on blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup_download by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'backup_download',
        blog_id => $blog->id,
    });
    $app->has_permission_error("backup_download by other permission");
};

subtest 'mode = cfg_system_general' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_system_general',
        blog_id => 0,
    });
    $app->has_no_permission_error("cfg_system_general by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'cfg_system_general',
        blog_id => 0,
    });
    $app->has_permission_error("cfg_system_general by non permitted user");
};

subtest 'mode = dialog_adjust_sitepath' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_adjust_sitepath',
        blog_id => 0,
    });
    $app->has_no_permission_error("dialog_adjust_sitepath by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_adjust_sitepath',
        blog_id => 0,
    });
    $app->has_permission_error("dialog_adjust_sitepath by non permitted user");
};

subtest 'mode = dialog_restore_upload' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_restore_upload',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dialog_restore_upload by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_restore_upload',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_restore_upload by non permitted user");
};

subtest 'mode = recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'recover',
        blog_id => 0,
        email   => $aikawa->email,
        name    => $aikawa->name,
    });
    $app->has_no_permission_error("recover by admin");
};

subtest 'mode = restore' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'restore',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("restore by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'restore',
        blog_id => $blog->id,
    });
    $app->has_permission_error("restore by non permitted user");
};

subtest 'mode = restore_premature_cancel' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'restore_premature_cancel',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("restore_premature_cancel by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'restore_premature_cancel',
        blog_id => $blog->id,
    });
    $app->has_permission_error("restore_premature_cancel by non permitted user");
};

subtest 'mode = save_cfg_system_general' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_cfg_system_general',
        blog_id => 0,
    });
    $app->has_no_permission_error("save_cfg_system_general by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save_cfg_system_general',
        blog_id => 0,
    });
    $app->has_permission_error("save_cfg_system_general by non permitted user");
};

subtest 'mode = start_backup' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_backup by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_backup by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("start_backup by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $website->id,
    });
    $app->has_permission_error("start_backup by non permitted user on website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_backup by non permitted user on blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_backup by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'start_backup',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_backup by other permission");
};

subtest 'mode = start_restore' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_restore by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_restore by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("start_restore by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $website->id,
    });
    $app->has_permission_error("start_restore by non permitted user on website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_restore by non permitted user on blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_restore by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'start_restore',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_restore by other permission");
};

subtest 'mode = system_check' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'system_check',
        blog_id => 0,
    });
    $app->has_no_permission_error("system_check by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'system_check',
        blog_id => 0,
    });
    $app->has_permission_error("system_check by non permitted user");
};

subtest 'mode = upgrade' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'upgrade',
        blog_id => 0,
    });
    $app->has_no_permission_error("upgrade by admin");
};

done_testing();
