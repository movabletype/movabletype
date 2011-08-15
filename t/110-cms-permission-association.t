#!/usr/bin/perl

use strict;
use warnings;

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
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);
my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);
my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);
my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $admin = MT::Author->load(1);

# Role
my $send_notification = MT::Test::Permission->make_role(
   name  => 'Send Notification',
   permissions => "'create_post','send_notifications'",
);

my $edit_notification = MT::Test::Permission->make_role(
    name  => 'Edit Notification',
    permissions => "'edit_notifications'",
);

my $designer_role = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $ukawa => $send_notification => $blog );
MT::Association->link( $egawa => $edit_notification => $blog );
MT::Association->link( $aikawa => $send_notification => $second_blog );
MT::Association->link( $ichikawa => $designer_role => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $admin->id,
);

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
    ok( $out, "Request: entry_notify" );
    ok( $out !~ m!Permission denied!i, "entry_notify by admin" );

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
    ok( $out, "Request: entry_notify" );
    ok( $out !~ m!Permission denied!i, "entry_notify by permitted user" );

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
    ok( $out, "Request: entry_notify" ); 
    ok( $out =~ m!permission=1!i, "entry_notify by other blog user" ); #TODO: should be use 'Permission Denied' instead of

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
    ok( $out, "Request: entry_notify" );
    ok( $out =~ m!permission=1!i, "entry_notify by other role user" );  #TODO: should be use 'Permission Denied' instead of
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
    ok( $out, "Request: export_notification" );
    ok( $out !~ m!Permission denied!i, "export_notification by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_notification" );
    ok( $out !~ m!Permission denied!i, "export_notification by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'export_notification',
            blog_id          => $second_blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_notification" );
    ok( $out =~ m!Permission denied!i, "export_notification by other blog user" );

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
    ok( $out, "Request: export_notification" );
    ok( $out =~ m!Permission denied!i, "export_notification by other role user" );
};

subtest 'mode = send_notify' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'send_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_notify" );
    ok( $out !~ m!No permissions!i, "send_notify by admin" ); #TODO: should be use 'Permission Denied' instead of

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'send_notify',
            blog_id          => $blog->id,
            entry_id         => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_notify" );
    ok( $out !~ m!No permissions!i, "send_notify by permitted user" ); #TODO: should be use 'Permission Denied' instead of

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'send_notify',
            blog_id          => $second_blog->id,
            entry_id         => $entry->id,
            send_notify_emails => 'test@example.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: send_notify" );
    ok( $out =~ m!No permissions!i, "send_notify by other blog user" ); #TODO: should be use 'Permission Denied' instead of

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
    ok( $out, "Request: send_notify" );
    ok( $out =~ m!No permissions!i, "send_notify by other role user" ); #TODO: should be use 'Permission Denied' instead of
};

done_testing();
