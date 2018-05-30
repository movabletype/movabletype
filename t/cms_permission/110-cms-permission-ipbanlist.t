#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        ShowIpInformation => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'second blog',
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
        nickname => 'goro Ogawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );

    my $manage_feedback = MT::Test::Permission->make_role(
        name        => 'Manage Feedback',
        permissions => "'manage_feedback'",
    );

    my $designer = MT::Role->load( { name => MT->translate('Designer') } );

    require MT::Association;
    MT::Association->link( $aikawa   => $edit_config     => $blog );
    MT::Association->link( $ichikawa => $manage_feedback => $blog );
    MT::Association->link( $ukawa    => $designer        => $blog );
    MT::Association->link( $egawa    => $edit_config     => $second_blog );
    MT::Association->link( $ogawa    => $manage_feedback => $second_blog );

    # BanList
    my $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
});

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );

my $admin = MT::Author->load(1);

my $banlist = MT::IPBanList->load( { blog_id => $blog->id } );

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'banlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'banlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i,
        "list by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'banlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'banlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i,
        "save by non permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i,
        "save by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'banlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other permission" );

    done_testing();
};

subtest 'mode = save (type is ipbanlist)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by non permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid request!i,
        "save by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            ip               => '1.1.1.1'
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by other permission" );

    done_testing();
};

subtest 'mode = edit' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other permission" );

    done_testing();
};

subtest 'mode = edit (type is ipbanlist)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid request!i,
        "edit by permitted user (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog (manage feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid request!i, "edit by other permission" );

    done_testing();
};

subtest 'mode = delete' => sub {
    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i,
        "delete by non permitted user (edit config)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i,
        "delete by permitted user (manage feedback)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (edit config)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage feedback)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'banlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );

    done_testing();
};

subtest 'mode = delete (type is ipbanlist)' => sub {
    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by non permitted user (edit config)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid request!i,
        "delete by permitted user (manage feedback)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (edit config)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog (manage feedback)" );

    $banlist = MT::Test::Permission->make_banlist( blog_id => $blog->id, );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            _type            => 'ipbanlist',
            id               => $banlist->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by other permission" );

    done_testing();
};

done_testing();
