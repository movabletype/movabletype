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


BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );

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
my $site_admin
    = MT::Role->load( { name => MT->translate('Site Administrator') } );
my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa   => $site_admin => $blog );
MT::Association->link( $ichikawa => $site_admin => $website );
MT::Association->link( $ogawa    => $site_admin => $second_blog );
MT::Association->link( $kumekawa => $designer   => $blog );

# Run
my ( $app, $out );

subtest 'mode = adjust_sitepath' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'adjust_sitepath',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: adjust_sitepath" );
    ok( $out !~ m!permission=1!i, "adjust_sitepath by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'adjust_sitepath',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: adjust_sitepath" );
    ok( $out =~ m!permission=1!i, "adjust_sitepath by non permitted user" );
};

subtest 'mode = backup' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out !~ m!permission=1!i, "backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out !~ m!permission=1!i, "backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out !~ m!permission=1!i, "backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out =~ m!permission=1!i, "backup by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out =~ m!permission=1!i, "backup by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out =~ m!permission=1!i, "backup by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup" );
    ok( $out =~ m!permission=1!i, "backup by other permission" );
};

subtest 'mode = backup_download' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup_download" );
    ok( $out !~ m!permission=1!i, "backup_download by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup_download" );
    ok( $out !~ m!permission=1!i, "backup_download by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup_download" );
    ok( $out !~ m!permission=1!i, "backup_download by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: backup_download" );
    ok( $out =~ m!permission=1!i,
        "backup_download by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: backup_download" );
    ok( $out =~ m!permission=1!i,
        "backup_download by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup_download" );
    ok( $out =~ m!permission=1!i, "backup_download by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'backup_download',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: backup_download" );
    ok( $out =~ m!permission=1!i, "backup_download by other permission" );
};

subtest 'mode = cfg_system_general' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_system_general',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_system_general" );
    ok( $out !~ m!permission=1!i, "cfg_system_general by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_system_general',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_system_general" );
    ok( $out =~ m!permission=1!i,
        "cfg_system_general by non permitted user" );
};

subtest 'mode = dialog_adjust_sitepath' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_adjust_sitepath',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_adjust_sitepath" );
    ok( $out !~ m!permission=1!i, "dialog_adjust_sitepath by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_adjust_sitepath',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_adjust_sitepath" );
    ok( $out =~ m!permission=1!i,
        "dialog_adjust_sitepath by non permitted user" );
};

subtest 'mode = dialog_restore_upload' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_restore_upload',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_restore_upload" );
    ok( $out !~ m!permission=1!i, "dialog_restore_upload by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_restore_upload',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_restore_upload" );
    ok( $out =~ m!permission=1!i,
        "dialog_restore_upload by non permitted user" );
};

subtest 'mode = recover' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'recover',
            blog_id          => 0,
            email            => $aikawa->email,
            name             => $aikawa->name,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: recover" );
    ok( $out !~ m!permission=1!i, "recover by admin" );
};

subtest 'mode = restore' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: restore" );
    ok( $out !~ m!permission=1!i, "restore by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: restore" );
    ok( $out =~ m!permission=1!i, "restore by non permitted user" );
};

subtest 'mode = restore_premature_cancel' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'restore_premature_cancel',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: restore_premature_cancel" );
    ok( $out !~ m!permission=1!i, "restore_premature_cancel by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'restore_premature_cancel',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: restore_premature_cancel" );
    ok( $out =~ m!permission=1!i,
        "restore_premature_cancel by non permitted user" );
};

subtest 'mode = save_cfg_system_general' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_cfg_system_general',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_cfg_system_general" );
    ok( $out !~ m!permission=1!i, "save_cfg_system_general by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_cfg_system_general',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cfg_system_general" );
    ok( $out =~ m!permission=1!i,
        "save_cfg_system_general by non permitted user" );
};

subtest 'mode = start_backup' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_backup" );
    ok( $out !~ m!permission=1!i, "start_backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_backup" );
    ok( $out !~ m!permission=1!i, "start_backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_backup" );
    ok( $out !~ m!permission=1!i, "start_backup by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_backup" );
    ok( $out =~ m!permission=1!i,
        "start_backup by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_backup" );
    ok( $out =~ m!permission=1!i,
        "start_backup by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_backup" );
    ok( $out =~ m!permission=1!i, "start_backup by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'start_backup',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_backup" );
    ok( $out =~ m!permission=1!i, "start_backup by other permission" );
};

subtest 'mode = start_restore' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_restore" );
    ok( $out !~ m!permission=1!i, "start_restore by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_restore" );
    ok( $out !~ m!permission=1!i, "start_restore by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_restore" );
    ok( $out !~ m!permission=1!i, "start_restore by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_restore" );
    ok( $out =~ m!permission=1!i,
        "start_restore by non permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: start_restore" );
    ok( $out =~ m!permission=1!i,
        "start_restore by non permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_restore" );
    ok( $out =~ m!permission=1!i, "start_restore by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'start_restore',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_restore" );
    ok( $out =~ m!permission=1!i, "start_restore by other permission" );
};

subtest 'mode = system_check' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'system_check',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: system_check" );
    ok( $out !~ m!permission=1!i, "system_check by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'system_check',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: system_check" );
    ok( $out =~ m!permission=1!i, "system_check by non permitted user" );
};

subtest 'mode = upgrade' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'upgrade',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: upgrade" );
    ok( $out !~ m!permission=1!i, "upgrade by admin" );
};

done_testing();
