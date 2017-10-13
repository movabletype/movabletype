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
MT->instance;
my $config = MT->config;
$config->EnableAddressBook( 1, 1 );
$config->save_config;

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

my $admin = MT::Author->load(1);

# Role
my $send_notification = MT::Test::Permission->make_role(
    name        => 'Send Notification',
    permissions => "'create_post','send_notifications'",
);

my $edit_notification = MT::Test::Permission->make_role(
    name        => 'Edit Notification',
    permissions => "'edit_notifications'",
);

my $designer_role = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $ukawa    => $send_notification => $blog );
MT::Association->link( $egawa    => $edit_notification => $blog );
MT::Association->link( $aikawa   => $send_notification => $second_blog );
MT::Association->link( $ichikawa => $designer_role     => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id   => $blog->id,
    author_id => $admin->id,
);

# Notification
my $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );

# Run
my ( $app, $out );

subtest 'mode = entry_notify' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'entry_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: entry_notify" );
    ok( $out !~ m!permission=1!i, "entry_notify by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'entry_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: entry_notify" );
    ok( $out !~ m!permission=1!i, "entry_notify by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'entry_notify',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: entry_notify" );
    ok( $out =~ m!invalid request!i, "entry_notify by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'entry_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: entry_notify" );
    ok( $out =~ m!permission=1!i, "entry_notify by other role user" );

    done_testing();
};

subtest 'mode = export_notification' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: export_notification" );
    ok( $out !~ m!permission=1!i, "export_notification by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: export_notification" );
    ok( $out !~ m!permission=1!i, "export_notification by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $second_blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: export_notification" );
    ok( $out =~ m!permission=1!i, "export_notification by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: export_notification" );
    ok( $out =~ m!permission=1!i, "export_notification by other role user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_notification" );
    ok( $out =~ m!permission=1!i,
        "export_notification by other role user (send notification)" );

    done_testing();
};

subtest 'mode = send_notify' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user        => $admin,
            __request_method   => 'POST',
            __mode             => 'send_notify',
            blog_id            => $blog->id,
            entry_id           => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: send_notify" );
    ok( $out !~ m!No permissions!i, "send_notify by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user        => $ukawa,
            __request_method   => 'POST',
            __mode             => 'send_notify',
            blog_id            => $blog->id,
            entry_id           => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: send_notify" );
    ok( $out !~ m!No permissions!i, "send_notify by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user        => $aikawa,
            __request_method   => 'POST',
            __mode             => 'send_notify',
            blog_id            => $second_blog->id,
            entry_id           => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: send_notify" );
    ok( $out =~ m!No permissions!i, "send_notify by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'send_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: send_notify" );
    ok( $out =~ m!No permissions!i, "send_notify by other role user" );

    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'notification',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'notification',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $second_blog->id,
            _type            => 'notification',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'notification',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other role user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'notification',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i,
        "list by other role user (send notification)" );

    done_testing();
};

subtest 'mode = save' => sub {

    # Edit screen is not provided by default installation.

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $second_blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other role user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i,
        "save by other role user (send notification)" );

    done_testing();
};

subtest 'mode = edit' => sub {

    # Edit screen is not provided by default installation.
    # We should be displaying more detail message for user, I think.

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $second_blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other blog user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other role user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by other role user (send notification)" );

    done_testing();
};

subtest 'mode = delete' => sub {
    $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by permitted user" );

    $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $second_blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog user" );

    $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other role user" );

    $addr = MT::Test::Permission->make_notification( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'notification',
            id               => $addr->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by other role user (send notification)" );

    done_testing();
};

done_testing();
