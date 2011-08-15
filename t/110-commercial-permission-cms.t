#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'addons/Commercial.pack/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

plan skip_all => 'Commercial Pack does not installed.'
    unless MT->instance->component('commercial');

### Make test data

# Website
my $website = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $second_website->id,
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

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $admin = MT::Author->load(1);

# Role
require MT::Role;
my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );
my $blog_admin = MT::Role->load( { name => MT->translate( 'Blog Administrator' ) } );
my $website_admin = MT::Role->load( { name => MT->translate( 'Website Administrator' ) } );

require MT::Association;
MT::Association->link( $aikawa => $blog_admin => $blog );
MT::Association->link( $ichikawa => $blog_admin => $second_blog );
MT::Association->link( $ukawa => $website_admin => $website );
MT::Association->link( $egawa => $website_admin => $second_website );
MT::Association->link( $ogawa => $designer => $blog );

# Field
my $blog_field = MT::Test::Permission->make_field(
    blog_id => $blog->id,
    name => 'Blog CF',
    tag => 'blog_cf_1',
    basename => 'blog_cf_1',
);
my $website_field = MT::Test::Permission->make_field(
    blog_id => $website->id,
    name => 'Website CF',
    tag => 'website_cf_1',
    basename => 'website_cf_1',
    type => 'page',
);
my $system_field = MT::Test::Permission->make_field(
    blog_id => 0,
    name => 'System CF',
    tag => 'system_cf_1',
    basename => 'system_cf_1',
    type => 'page',
);

# Run
my ( $app, $out );

subtest 'mode = view_field' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view_field',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_field" );
    ok( $out !~ m!Permission denied!i, "view_field by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view_field',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_field" );
    ok( $out !~ m!Permission denied!i, "view_field by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'view_field',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_field" );
    ok( $out =~ m!Permission denied!i, "view_field by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'view_field',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_field" );
    ok( $out =~ m!Permission denied!i, "view_field by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view_field',
            blog_id          => 0,
            id               => $system_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_field" );
    ok( $out =~ m!Permission denied!i, "view_field on system by non permitted user" );
};

subtest 'mode = prep_customfields_upgrade' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'prep_customfields_upgrade',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: prep_customfields_upgrade" );
    ok( $out !~ m!Permission denied!i, "prep_customfields_upgrade by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'prep_customfields_upgrade',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: prep_customfields_upgrade" );
    ok( $out =~ m!Permission denied!i, "prep_customfields_upgrade by non permitted user" );
};

subtest 'mode = list_field' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_field',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_field" );
    ok( $out !~ m!Permission denied!i, "list_field by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_field',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_field" );
    ok( $out !~ m!Permission denied!i, "list_field by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_field',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_field" );
    ok( $out =~ m!Permission denied!i, "list_field by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list_field',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_field" );
    ok( $out =~ m!Permission denied!i, "list_field by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_field',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_field" );
    ok( $out =~ m!Permission denied!i, "list_field on system by non permitted user" );
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'field',
            name             => 'NewField',
            object_type      => 'entry',
            tag              => 'newtag',
            type             => 'text'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'field',
            name             => 'NewField',
            object_type      => 'entry',
            tag              => 'newtag',
            type             => 'text'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'field',
            name             => 'NewField',
            object_type      => 'entry',
            tag              => 'newtag',
            type             => 'text'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'field',
            name             => 'NewField',
            object_type      => 'entry',
            tag              => 'newtag',
            type             => 'text'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => 0,
            _type            => 'field',
            name             => 'NewField',
            object_type      => 'entry',
            tag              => 'newtag',
            type             => 'text'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save on system by non permitted user" );
};

subtest 'mode = delete' => sub {
    $blog_field = MT::Test::Permission->make_field(
        blog_id => $blog->id,
        name => 'Blog CF',
        tag => 'blog_cf_1',
        basename => 'blog_cf_1',
    );
    $website_field = MT::Test::Permission->make_field(
        blog_id => $website->id,
        name => 'Website CF',
        tag => 'website_cf_1',
        basename => 'website_cf_1',
        type => 'page',
    );
    $system_field = MT::Test::Permission->make_field(
        blog_id => 0,
        name => 'System CF',
        tag => 'system_cf_1',
        basename => 'system_cf_1',
        type => 'page',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'fiedl',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission denied!i, "delete by admin" );

    $blog_field = MT::Test::Permission->make_field(
        blog_id => $blog->id,
        name => 'Blog CF',
        tag => 'blog_cf_1',
        basename => 'blog_cf_1',
    );
    $website_field = MT::Test::Permission->make_field(
        blog_id => $website->id,
        name => 'Website CF',
        tag => 'website_cf_1',
        basename => 'website_cf_1',
        type => 'page',
    );
    $system_field = MT::Test::Permission->make_field(
        blog_id => 0,
        name => 'System CF',
        tag => 'system_cf_1',
        basename => 'system_cf_1',
        type => 'page',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'fiedl',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission denied!i, "delete by permitted user" );

    $blog_field = MT::Test::Permission->make_field(
        blog_id => $blog->id,
        name => 'Blog CF',
        tag => 'blog_cf_1',
        basename => 'blog_cf_1',
    );
    $website_field = MT::Test::Permission->make_field(
        blog_id => $website->id,
        name => 'Website CF',
        tag => 'website_cf_1',
        basename => 'website_cf_1',
        type => 'page',
    );
    $system_field = MT::Test::Permission->make_field(
        blog_id => 0,
        name => 'System CF',
        tag => 'system_cf_1',
        basename => 'system_cf_1',
        type => 'page',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'fiedl',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete by other blog" );

    $blog_field = MT::Test::Permission->make_field(
        blog_id => $blog->id,
        name => 'Blog CF',
        tag => 'blog_cf_1',
        basename => 'blog_cf_1',
    );
    $website_field = MT::Test::Permission->make_field(
        blog_id => $website->id,
        name => 'Website CF',
        tag => 'website_cf_1',
        basename => 'website_cf_1',
        type => 'page',
    );
    $system_field = MT::Test::Permission->make_field(
        blog_id => 0,
        name => 'System CF',
        tag => 'system_cf_1',
        basename => 'system_cf_1',
        type => 'page',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'fiedl',
            blog_id          => $blog->id,
            id               => $blog_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete by other permission" );

    $blog_field = MT::Test::Permission->make_field(
        blog_id => $blog->id,
        name => 'Blog CF',
        tag => 'blog_cf_1',
        basename => 'blog_cf_1',
    );
    $website_field = MT::Test::Permission->make_field(
        blog_id => $website->id,
        name => 'Website CF',
        tag => 'website_cf_1',
        basename => 'website_cf_1',
        type => 'page',
    );
    $system_field = MT::Test::Permission->make_field(
        blog_id => 0,
        name => 'System CF',
        tag => 'system_cf_1',
        basename => 'system_cf_1',
        type => 'page',
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'fiedl',
            blog_id          => 0,
            id               => $system_field->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete on system by non permitted user" );
};

done_testing();
