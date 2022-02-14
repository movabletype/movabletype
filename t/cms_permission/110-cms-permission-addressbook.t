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
MT->instance;
my $config = MT->config;
$config->EnableAddressBook(1, 1);
$config->save_config;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(name => 'my website');

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

    my $designer_role = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($ukawa    => $send_notification => $blog);
    MT::Association->link($egawa    => $edit_notification => $blog);
    MT::Association->link($aikawa   => $send_notification => $second_blog);
    MT::Association->link($ichikawa => $designer_role     => $blog);

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $admin->id,
        title     => 'my entry',
    );

    # Notification
    my $addr = MT::Test::Permission->make_notification(
        blog_id => $blog->id,
        name    => 'my notification',
    );
});

my $website     = MT::Website->load({ name => 'my website' });
my $blog        = MT::Blog->load({ name => 'my blog' });
my $second_blog = MT::Blog->load({ name => 'second blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });

my $admin = MT::Author->load(1);

my $entry = MT::Entry->load({ title => 'my entry' });

require MT::Notification;
my $addr = MT::Notification->load({ name => 'my notification' });

subtest 'mode = entry_notify' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'entry_notify',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_no_permission_error("entry_notify by admin");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'entry_notify',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_no_permission_error("entry_notify by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode   => 'entry_notify',
        blog_id  => $second_blog->id,
        entry_id => $entry->id,
    });
    $app->has_invalid_request("entry_notify by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'entry_notify',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("entry_notify by other role user");
};

subtest 'mode = export_notification' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'export_notification',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export_notification by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'export_notification',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export_notification by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'export_notification',
        blog_id => $second_blog->id,
    });
    $app->has_permission_error("export_notification by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'export_notification',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("export_notification by other role user");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'export_notification',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("export_notification by other role user (send notification)");
};

subtest 'mode = send_notify' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode             => 'send_notify',
        blog_id            => $blog->id,
        entry_id           => $entry->id,
        send_notify_emails => 'test@example.com',
    });
    $app->has_no_permission_error("send_notify by admin");

    {
        # XXX: The following test is somewhat broken because the user doesn't have enough permission
        # so the first request succeeds and then the following redirect fails.
        local $app->{max_redirect} = 1;
        $app->login($ukawa);
        $app->post_ok({
            __mode             => 'send_notify',
            blog_id            => $blog->id,
            entry_id           => $entry->id,
            send_notify_emails => 'test@example.com',
        });
        $app->has_no_permission_error("send_notify by permitted user");
    }

    $app->login($aikawa);
    $app->post_ok({
        __mode             => 'send_notify',
        blog_id            => $second_blog->id,
        entry_id           => $entry->id,
        send_notify_emails => 'test@example.com',
    });
    $app->has_permission_error("send_notify by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'send_notify',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("send_notify by other role user");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'notification',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'notification',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $second_blog->id,
        _type   => 'notification',
    });
    $app->has_permission_error("list by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'notification',
    });
    $app->has_permission_error("list by other role user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $blog->id,
        _type   => 'notification',
    });
    $app->has_permission_error("list by other role user (send notification)");
};

subtest 'mode = save' => sub {

    # Edit screen is not provided by default installation.

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_no_permission_error("save by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_no_permission_error("save by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $second_blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("save by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("save by other role user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("save by other role user (send notification)");
};

subtest 'mode = edit' => sub {

    # Edit screen is not provided by default installation.
    # We should be displaying more detail message for user, I think.

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_invalid_request("edit by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $second_blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_invalid_request("edit by other blog user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_invalid_request("edit by other role user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_invalid_request("edit by other role user (send notification)");
};

subtest 'mode = delete' => sub {
    my $addr = MT::Test::Permission->make_notification(blog_id => $blog->id,);
    my $app  = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_no_permission_error("delete by admin");

    $addr = MT::Test::Permission->make_notification(blog_id => $blog->id,);
    $app->login($egawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_no_permission_error("delete by permitted user");

    $addr = MT::Test::Permission->make_notification(blog_id => $blog->id,);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $second_blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("delete by other blog user");

    $addr = MT::Test::Permission->make_notification(blog_id => $blog->id,);
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("delete by other role user");

    $addr = MT::Test::Permission->make_notification(blog_id => $blog->id,);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        _type   => 'notification',
        id      => $addr->id,
    });
    $app->has_permission_error("delete by other role user (send notification)");
};

done_testing();
