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

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $edit_tags = MT::Test::Permission->make_role(
   name  => 'Edit Tags',
   permissions => "'edit_tags'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $create_post => $blog );
MT::Association->link( $ichikawa => $edit_tags => $blog );
MT::Association->link( $ukawa => $create_post => $second_blog );
MT::Association->link( $egawa => $edit_tags => $second_blog );
MT::Association->link( $ogawa => $designer => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $ichikawa->id,
);
$entry->tags( 'alpha', 'beta' );
$entry->save;

# Tag
require MT::Tag;
my $tag = MT::Tag->load({ name => 'alpha' });

# Run
my ( $app, $out );

subtest 'mode = js_recent_entries_for_tag' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'js_recent_entries_for_tag',
            blog_id          => $blog->id,
            tag              => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_recent_entries_for_tag" );
    ok( $out !~ m!permission denied!i, "js_recent_entries_for_tag by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'js_recent_entries_for_tag',
            blog_id          => $blog->id,
            tag              => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_recent_entries_for_tag" );
    ok( $out !~ m!permission denied!i, "js_recent_entries_for_tag by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'js_recent_entries_for_tag',
            blog_id          => $blog->id,
            tag              => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_recent_entries_for_tag" );
    ok( $out =~ m!permission denied!i, "js_recent_entries_for_tag by other blog" );

    done_testing();
};

subtest 'mode = js_tag_check' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'js_tag_check',
            blog_id          => $blog->id,
            tag_name         => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_check" );
    ok( $out !~ m!permission denied!i, "js_tag_check by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'js_tag_check',
            blog_id          => $blog->id,
            tag_name         => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_check" );
    ok( $out !~ m!permission denied!i, "js_tag_check by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'js_tag_check',
            blog_id          => $blog->id,
            tag_name         => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_check" );
    ok( $out =~ m!permission denied!i, "js_tag_check by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'js_tag_check',
            blog_id          => $blog->id,
            tag_name         => 'alpha',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_check" );
    ok( $out =~ m!permission denied!i, "js_tag_check by other permission" );

    done_testing();
};

subtest 'mode = js_tag_list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'js_tag_list',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_list" );
    ok( $out !~ m!permission denied!i, "js_tag_list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'js_tag_list',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_list" );
    ok( $out !~ m!permission denied!i, "js_tag_list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'js_tag_list',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_list" );
    ok( $out =~ m!permission denied!i, "js_tag_list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'js_tag_list',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: js_tag_list" );
    ok( $out =~ m!permission denied!i, "js_tag_list by other permission" );

    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'tag',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'tag',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'tag',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'tag',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = rename_tag' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'rename_tag',
            blog_id          => $blog->id,
            tag_name         => 'Alpha One',
            __id             => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rename_tag" );
    ok( $out !~ m!permission=1!i, "rename_tag by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'rename_tag',
            blog_id          => $blog->id,
            tag_name         => 'Alpha One',
            __id             => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rename_tag" );
    ok( $out !~ m!permission=1!i, "rename_tag by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'rename_tag',
            blog_id          => $blog->id,
            tag_name         => 'Alpha One',
            __id             => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rename_tag" );
    ok( $out =~ m!permission=1!i, "rename_tag by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'rename_tag',
            blog_id          => $blog->id,
            tag_name         => 'Alpha One',
            __id             => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: rename_tag" );
    ok( $out =~ m!permission=1!i, "rename_tag by other permission" );

    done_testing();
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'tag',
            name             => 'tag name',
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
            _type            => 'tag',
            name             => 'tag name',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );

    done_testing();
};

subtest 'mode = edit' => sub {
    my $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'tag',
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'session',
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );

    done_testing();
};

subtest 'mode = delete' => sub {
    my $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'tag',
            blog_id          => $blog->id,
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'tag',
            blog_id          => $blog->id,
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by permitted user" );

    $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'tag',
            blog_id          => $blog->id,
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog" );

    $tag = MT::Test::Permission->make_tag();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'tag',
            blog_id          => $blog->id,
            id               => $tag->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );

    done_testing();
};

done_testing();
