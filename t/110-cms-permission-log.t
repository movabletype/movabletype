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

use MT::Test qw( :app :db );
use MT::Test::Permission;

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

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $admin = MT::Author->load( 1 );

# Role
my $view_blog_log = MT::Test::Permission->make_role(
   name  => 'View Blog Log',
   permissions => "'view_blog_log'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $view_blog_log => $blog );
MT::Association->link( $ichikawa => $view_blog_log => $website );
MT::Association->link( $ukawa => $view_blog_log => $second_blog );
MT::Association->link( $egawa => $designer => $blog );

$ogawa->can_view_log(1);
$ogawa->save();


# Run
my ( $app, $out );

subtest 'mode = export_log' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'export_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_log" );
    ok( $out =~ m!Content-disposition: attachment;!i, "export_log by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'export_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_log" );
    ok( $out =~ m!Content-disposition: attachment;!i, "export_log by permitted_user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'export_log',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_log" );
    ok( $out =~ m!Content-disposition: attachment;!i, "export_log by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'export_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_log" );
    ok( $out =~ m!Content-disposition: attachment;!i, "export_log by permitted user on system" );

    SKIP: {
        skip 'https://movabletype.fogbugz.com/default.asp?106840', 4;

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'export_log',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: export_log" );
        ok( $out =~ m!permission=1!i, "export_log by child blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'export_log',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: export_log" );
        ok( $out =~ m!permission=1!i, "export_log by other blog" );
    };

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'export_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export_log" );
    ok( $out =~ m!permission=1!i, "export_log by other permission" );

    done_testing();
};

subtest 'mode = reset_log' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by permitted_user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by permitted user on system" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by parent website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!permission=1!i, "reset_log by child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!reset=1!i, "reset_log by permitted user on system" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!permission=1!i, "reset_log by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'reset_log',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_log" );
    ok( $out =~ m!permission=1!i, "reset_log by other permission" );

    done_testing();
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'log',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'log',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );

    done_testing();
};

subtest 'mode = edit' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'log',
            id               => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'log',
            id               => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );

    done_testing();
};

subtest 'mode = delete' => sub {
    my $log = MT::Test::Permission->make_log( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'log',
            id               => $log->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $log = MT::Test::Permission->make_log( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'log',
            id               => $log->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );

    done_testing();
};

done_testing();
