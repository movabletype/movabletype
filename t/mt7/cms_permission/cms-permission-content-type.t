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

### Prepare
MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Sites
        my $site = MT::Test::Permission->make_website( name => 'my website' );
        my $site2 = MT::Test::Permission->make_website(
            name => 'my second website' );

        # can_manage_content_type_Users
        my $sys_manage_content_types_user
            = MT::Test::Permission->make_author(
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
        MT::Association->link(
            $manage_content_type_user => $manage_content_types_role =>
                $site );

        my $user = MT::Test::Permission->make_author(
            name     => 'ichikawa',
            nickname => 'Jiro Ichikawa',
        );
    }
);

### Loading test data
my $site = MT::Website->load( { name => 'my website' } );
my $sys_manage_content_types_user = MT::Author->load( { name => 'aikawa' } );
my $manage_content_type_user      = MT::Author->load( { name => 'kagawa' } );
my $user = MT::Author->load( { name => 'ichikawa' } );

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type',
);

my $admin = MT::Author->load(1);

### Run
my ( $app, $out );

# Create new
subtest 'mode = view (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'create by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_types_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'create by permitted user (can_manage_content_types)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_type_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_type',
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'create by permitted user (manage_content_type_user)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'create by not permitted user' );

};

# edit
subtest 'mode = view (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'edit by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_types_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'edit by permitted user (can_manage_content_types)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_type_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_type',
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'edit by permitted user (manage_content_type_user)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'edit by not permitted user' );

};

# save new
subtest 'mode = save(new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'save',
            blog_id          => $site->id,
            _type            => 'content_type',
            name             => 'content_type_test_' . $admin->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save(new) by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_types_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            name => 'content_type_test_' . $sys_manage_content_types_user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'save(new) by permitted user (can_manage_content_types)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_type_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_type',
            name => 'content_type_test_' . $manage_content_type_user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'save(new) by permitted user (manage_content_type_user)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            name             => 'content_type_test_' . $user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save(new) by not permitted user' );

};

# save edit
subtest 'mode = save(edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'save',
            blog_id          => $site->id,
            _type            => 'content_type',
            name             => $content_type->name . '_' . $admin->id,
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'save(edit) by admin' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_types_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            name             => $content_type->name . '_' . $sys_manage_content_types_user->id,
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'save(edit) by permitted user (can_manage_content_types)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_type_user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_type',
            name             => $content_type->name . '_' . $manage_content_type_user->id,
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'save(edit) by permitted user (manage_content_type_user)' );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'view',
            blog_id          => $site->id,
            _type            => 'content_type',
            name             => $content_type->name . '_' . $user->id,
            id               => $content_type->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'save(edit) by not permitted user' );

};

# delete
subtest 'mode = delete' => sub {
    require MT::ContentType;
    my $content_type_admin = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for admin',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'delete',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type_admin->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/, 'delete by admin' );

    my $content_type_sys_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for sys_manage_content_types_user',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_content_types_user,
            __request_method => 'GET',
            __mode           => 'delete',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type_sys_user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'delete by permitted user (can_manage_content_types)' );

    my $content_type_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for manage_content_type_user',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $manage_content_type_user,
            __request_method => 'GET',
            __mode           => 'delete',
            blog_id          => $site->id,
            content_type_id  => $content_type->id,
            _type            => 'content_type',
            id               => $content_type_user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out !~ /permission=1/,
        'delete by permitted user (manage_content_type_user)' );

    my $content_type_other_user = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type for other user',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'delete',
            blog_id          => $site->id,
            _type            => 'content_type',
            id               => $content_type_other_user->id,
        },
    );

    $out = delete $app->{__test_output};
    ok( $out =~ /permission=1/, 'delete by not permitted user' );

};

done_testing();
