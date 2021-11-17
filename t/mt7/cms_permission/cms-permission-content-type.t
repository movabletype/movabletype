#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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

    # Sites
    my $site  = MT::Test::Permission->make_website(name => 'my website');
    my $site2 = MT::Test::Permission->make_website(name => 'my second website');

    # can_manage_content_type_Users
    my $sys_manage_content_types_user = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );
    $sys_manage_content_types_user->can_manage_content_types(1);
    $sys_manage_content_types_user->save;

    my $manage_content_type_user = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );
    my $manage_content_types_role = MT::Test::Permission->make_role(
        name        => 'manage content type',
        permissions => "'manage_content_types'",
    );
    require MT::Association;
    MT::Association->link($manage_content_type_user => $manage_content_types_role => $site);

    my $user = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );
});

### Loading test data
my $site                          = MT::Website->load({ name => 'my website' });
my $sys_manage_content_types_user = MT::Author->load({ name => 'aikawa' });
my $manage_content_type_user      = MT::Author->load({ name => 'kagawa' });
my $user                          = MT::Author->load({ name => 'ichikawa' });

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type',
);

my $admin = MT::Author->load(1);

# Create new
subtest 'mode = view (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
    });

    $app->has_no_permission_error('create by admin');

    $app->login($sys_manage_content_types_user);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
    });

    $app->has_no_permission_error('create by permitted user (can_manage_content_types)');

    $app->login($manage_content_type_user);
    $app->get_ok({
        __mode          => 'view',
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        _type           => 'content_type',
    });

    $app->has_no_permission_error('create by permitted user (manage_content_type_user)');

    $app->login($user);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
    });

    $app->has_permission_error('create by not permitted user');
};

# edit
subtest 'mode = view (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type->id,
    });

    $app->has_no_permission_error('edit by admin');

    $app->login($sys_manage_content_types_user);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type->id,
    });

    $app->has_no_permission_error('edit by permitted user (can_manage_content_types)');

    $app->login($manage_content_type_user);
    $app->get_ok({
        __mode          => 'view',
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        _type           => 'content_type',
        id              => $content_type->id,
    });

    $app->has_no_permission_error('edit by permitted user (manage_content_type_user)');

    $app->login($user);
    $app->get_ok({
        __mode  => 'view',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type->id,
    });

    $app->has_permission_error('edit by not permitted user');
};

# save new
subtest 'mode = save(new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => 'content_type_test_' . $admin->id,
    });

    $app->has_no_permission_error('save(new) by admin');

    $app->login($sys_manage_content_types_user);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => 'content_type_test_' . $sys_manage_content_types_user->id,
    });

    $app->has_no_permission_error('save(new) by permitted user (can_manage_content_types)');

    $app->login($manage_content_type_user);
    $app->post_ok({
        __mode          => 'save',
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        _type           => 'content_type',
        name            => 'content_type_test_' . $manage_content_type_user->id,
    });

    $app->has_no_permission_error('save(new) by permitted user (manage_content_type_user)');

    $app->login($user);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => 'content_type_test_' . $user->id,
    });

    $app->has_permission_error('save(new) by not permitted user');
};

# save edit
subtest 'mode = save(edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => $content_type->name . '_' . $admin->id,
        id      => $content_type->id,
    });

    $app->has_no_permission_error('save(edit) by admin');

    $app->login($sys_manage_content_types_user);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => $content_type->name . '_' . $sys_manage_content_types_user->id,
        id      => $content_type->id,
    });

    $app->has_no_permission_error('save(edit) by permitted user (can_manage_content_types)');

    $app->login($manage_content_type_user);
    $app->post_ok({
        __mode          => 'save',
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        _type           => 'content_type',
        name            => $content_type->name . '_' . $manage_content_type_user->id,
        id              => $content_type->id,
    });

    $app->has_no_permission_error('save(edit) by permitted user (manage_content_type_user)');

    $app->login($user);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $site->id,
        _type   => 'content_type',
        name    => $content_type->name . '_' . $user->id,
        id      => $content_type->id,
    });

    $app->has_permission_error('save(edit) by not permitted user');
};

# delete
subtest 'mode = delete' => sub {
    require MT::ContentType;
    my $content_type_admin = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for admin',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type_admin->id,
    });

    $app->has_no_permission_error('delete by admin');

    my $content_type_sys_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for sys_manage_content_types_user',
    );
    $app->login($sys_manage_content_types_user);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type_sys_user->id,
    });

    $app->has_no_permission_error('delete by permitted user (can_manage_content_types)');

    my $content_type_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for manage_content_type_user',
    );
    $app->login($manage_content_type_user);
    $app->post_ok({
        __mode          => 'delete',
        blog_id         => $site->id,
        content_type_id => $content_type->id,
        _type           => 'content_type',
        id              => $content_type_user->id,
    });

    $app->has_no_permission_error('delete by permitted user (manage_content_type_user)');

    my $content_type_other_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for other user',
    );
    $app->login($user);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $site->id,
        _type   => 'content_type',
        id      => $content_type_other_user->id,
    });

    $app->has_permission_error('delete by not permitted user');
};

done_testing();
