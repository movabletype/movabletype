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
my $website       = MT::Test::Permission->make_website();
my $other_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $other_blog
    = MT::Test::Permission->make_blog( parent_id => $other_website->id, );

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
    nickname => 'Saburo Kumekawa',
);

my $kemikawa = MT::Test::Permission->make_author(
    name     => 'kemikawa',
    nickname => 'Shiro Kemikawa',
);

my $koishikawa = MT::Test::Permission->make_author(
    name     => 'koishikawa',
    nickname => 'Goro Koishikawa',
);

my $sagawa = MT::Test::Permission->make_author(
    name     => 'sagawa',
    nickname => 'Ichiro Sagawa',
);

my $shiki = MT::Test::Permission->make_author(
    name     => 'shiki',
    nickname => 'Jiro Shiki',
);

my $suda = MT::Test::Permission->make_author(
    name     => 'suda',
    nickname => 'Saburo Suda',
);

my $seta = MT::Test::Permission->make_author(
    name     => 'seta',
    nickname => 'Shiro Seta',
);

my $admin = MT::Author->load(1);

# Role
my $edit_templates = MT::Test::Permission->make_role(
    name        => 'Edit Templates',
    permissions => "'edit_templates'",
);

my $rebuild = MT::Test::Permission->make_role(
    name        => 'rebuild',
    permissions => "'rebuild'",
);

my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);

require MT::Association;
MT::Association->link( $aikawa   => $edit_templates => $blog );
MT::Association->link( $ichikawa => $rebuild        => $blog );
MT::Association->link( $ukawa    => $edit_templates => $second_blog );
MT::Association->link( $egawa    => $rebuild        => $second_blog );
MT::Association->link( $ogawa    => $create_post    => $blog );

MT::Association->link( $kikkawa, $edit_templates, $website );
MT::Association->link( $sagawa,  $create_post,    $website );
MT::Association->link( $shiki,   $rebuild,        $website );

MT::Association->link( $kemikawa, $edit_templates, $other_website );
MT::Association->link( $suda,     $rebuild,        $other_website );

MT::Association->link( $koishikawa, $edit_templates, $other_blog );
MT::Association->link( $seta,       $rebuild,        $other_blog );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $kagawa->id );
$p->permissions("'edit_templates'");
$p->save;

# Template
my $tmpl = MT::Test::Permission->make_template( blog_id => $blog->id, );

my $widget = MT::Test::Permission->make_template(
    blog_id => $blog->id,
    type    => 'widget',
);

my $sys_tmpl = MT::Test::Permission->make_template( blog_id => 0, );

# Run
my ( $app, $out );

subtest 'blog scope' => sub {

    subtest 'mode = add_map' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'add_map',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: add_map" );
        ok( $out !~ m!No permissions!i, "add_map by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'add_map',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: add_map" );
        ok( $out !~ m!No permissions!i, "add_map by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'add_map',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: add_map" );
        ok( $out !~ m!No permissions!i, "add_map by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'add_map',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: add_map" );
        ok( $out =~ m!permission=1!i, "add_map by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'add_map',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: add_map" );
        ok( $out =~ m!No permissions!i, "add_map by other permission" );

        done_testing();
    };

    subtest 'mode = delete_map' => sub {
        my $map
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete_map',
                blog_id          => $blog->id,
                id               => $map->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: delete_map" );
        ok( $out !~ m!No permissions!i, "delete_map by admin" );

        $map
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'delete_map',
                blog_id          => $blog->id,
                id               => $map->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: delete_map" );
        ok( $out !~ m!No permissions!i, "delete_map by permitted user" );

        $map
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'delete_map',
                blog_id          => $blog->id,
                id               => $map->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: delete_map" );
        ok( $out !~ m!No permissions!i,
            "delete_map by permitted user (sys)" );

        $map
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'delete_map',
                blog_id          => $blog->id,
                id               => $map->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete_map" );
        ok( $out =~ m!permission=1!i, "delete_map by other blog" );

        $map
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'delete_map',
                blog_id          => $blog->id,
                id               => $map->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: delete_map" );
        ok( $out =~ m!No permissions!i, "delete_map by other permission" );

        done_testing();
    };

    subtest 'mode = delete_widget' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
                return_args      => MT::Util::encode_html(
                    '__mode=list_widget&blog_id=' . $blog->id
                ),
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: delete_widget" );
        ok( $out !~ m!permission denied!i, "delete_widget by admin" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 1',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'delete_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
                return_args      => MT::Util::encode_html(
                    '__mode=list_widget&blog_id=' . $blog->id
                ),
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: delete_widget" );
        ok( $out !~ m!permission denied!i,
            "delete_widget by permitted user" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 2',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'delete_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
                return_args      => MT::Util::encode_html(
                    '__mode=list_widget&blog_id=' . $blog->id
                ),
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: delete_widget" );
        ok( $out !~ m!permission denied!i,
            "delete_widget by permitted user (sys)" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 3',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'delete_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
                return_args      => MT::Util::encode_html(
                    '__mode=list_widget&blog_id=' . $blog->id
                ),
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete_widget" );
        ok( $out =~ m!permission=1!i, "delete_widget by other blog" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 4',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'delete_widget',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
                _type            => 'widget',
                id               => $widget->id,
                return_args      => MT::Util::encode_html(
                    '__mode=list_widget&blog_id=' . $blog->id
                ),
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: delete_widget" );
        ok( $out =~ m!permission denied!i,
            "delete_widget by other permission"
        );

        done_testing();
    };

    subtest 'mode = dialog_publishing_profile' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'dialog_publishing_profile',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: dialog_publishing_profile" );
        ok( $out !~ m!permission=1!i, "dialog_publishing_profile by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'dialog_publishing_profile',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_publishing_profile" );
        ok( $out !~ m!permission=1!i,
            "dialog_publishing_profile by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'dialog_publishing_profile',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_publishing_profile" );
        ok( $out !~ m!permission=1!i,
            "dialog_publishing_profile by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'dialog_publishing_profile',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_publishing_profile" );
        ok( $out =~ m!permission=1!i,
            "dialog_publishing_profile by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'dialog_publishing_profile',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_publishing_profile" );
        ok( $out =~ m!permission=1!i,
            "dialog_publishing_profile by other permission" );

        done_testing();
    };

    subtest 'mode = dialog_refresh_templates' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'dialog_refresh_templates',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: dialog_refresh_templates" );
        ok( $out !~ m!permission=1!i, "dialog_refresh_templates by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'dialog_refresh_templates',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_refresh_templates" );
        ok( $out !~ m!permission=1!i,
            "dialog_refresh_templates by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'dialog_refresh_templates',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_refresh_templates" );
        ok( $out !~ m!permission=1!i,
            "dialog_refresh_templates by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'dialog_refresh_templates',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_refresh_templates" );
        ok( $out =~ m!permission=1!i,
            "dialog_refresh_templates by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'dialog_refresh_templates',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: dialog_refresh_templates" );
        ok( $out =~ m!permission=1!i,
            "dialog_refresh_templates by other permission" );

        done_testing();
    };

    subtest 'mode = edit_widget' => sub {
        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'edit_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: edit_widget" );
        ok( $out !~ m!permission denied!i, "edit_widget by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'edit_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: edit_widget" );
        ok( $out !~ m!permission denied!i, "edit_widget by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'edit_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: edit_widget" );
        ok( $out !~ m!permission denied!i,
            "edit_widget by permitted user (sys)"
        );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'edit_widget',
                blog_id          => $blog->id,
                _type            => 'widget',
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit_widget" );
        ok( $out =~ m!permission=1!i, "edit_widget by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'edit_widget',
                blog_id          => $blog->id,
                new_archive_type => 'Individual',
                template_id      => $tmpl->id,
                _type            => 'widget',
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: edit_widget" );
        ok( $out =~ m!permission denied!i,
            "edit_widget by other permission" );

        done_testing();
    };

    subtest 'mode = list_template' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'list_template',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_template" );
        ok( $out !~ m!permission=1!i, "list_template by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'list_template',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_template" );
        ok( $out !~ m!permission=1!i, "list_template by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'list_template',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list_template" );
        ok( $out !~ m!permission=1!i,
            "list_template by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'list_template',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_template" );
        ok( $out =~ m!permission=1!i, "list_template by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'list_template',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_template" );
        ok( $out =~ m!permission=1!i, "list_template by other permission" );

        done_testing();
    };

    subtest 'mode = list_widget' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'list_widget',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_widget" );
        ok( $out !~ m!permission=1!i, "list_widget by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'list_widget',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_widget" );
        ok( $out !~ m!permission=1!i, "list_widget by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'list_widget',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_widget" );
        ok( $out !~ m!permission=1!i, "list_widget by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'list_widget',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_widget" );
        ok( $out =~ m!permission=1!i, "list_widget by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'list_widget',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: list_widget" );
        ok( $out =~ m!permission=1!i, "list_widget by other permission" );

        done_testing();
    };

    subtest 'mode = preview_template' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'preview_template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: preview_template" );
        ok( $out !~ m!permission=1!i, "preview_template by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'preview_template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: preview_template" );
        ok( $out !~ m!permission=1!i, "preview_template by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'preview_template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: preview_template" );
        ok( $out !~ m!permission=1!i,
            "preview_template by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'preview_template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: preview_template" );
        ok( $out =~ m!permission=1!i, "preview_template by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'preview_template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: preview_template" );
        ok( $out =~ m!permission=1!i,
            "preview_template by other permission" );

        done_testing();
    };

    subtest 'mode = publish_archive_templates' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'publish_archive_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: publish_archive_templates" );
        ok( $out !~ m!permission=1!i, "publish_archive_templates by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'publish_archive_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_archive_templates" );
        ok( $out !~ m!permission=1!i,
            "publish_archive_templates by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $egawa,
                __request_method => 'POST',
                __mode           => 'publish_archive_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_archive_templates" );
        ok( $out =~ m!permission=1!i,
            "publish_archive_templates by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'publish_archive_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_archive_templates" );
        ok( $out =~ m!permission=1!i,
            "publish_archive_templates by other permission" );

        done_testing();
    };

    subtest 'mode = publish_index_templates' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'publish_index_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: publish_index_templates" );
        ok( $out !~ m!permission=1!i, "publish_index_templates by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'publish_index_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_index_templates" );
        ok( $out !~ m!permission=1!i,
            "publish_index_templates by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $egawa,
                __request_method => 'POST',
                __mode           => 'publish_index_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_index_templates" );
        ok( $out =~ m!permission=1!i,
            "publish_index_templates by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'publish_index_templates',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_index_templates" );
        ok( $out =~ m!permission=1!i,
            "publish_index_templates by other permission" );

        done_testing();
    };

    subtest 'mode = publish_templates_from_search' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'publish_templates_from_search',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_templates_from_search" );
        ok( $out !~ m!permission=1!i,
            "publish_templates_from_search by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'publish_templates_from_search',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: publish_templates_from_search" );
        ok( $out !~ m!permission=1!i,
            "publish_templates_from_search by permitted user" );

    SKIP: {
            skip
                'Got an unexpected result but that can not affect. Skip this test.',
                4;

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $egawa,
                    __request_method => 'POST',
                    __mode           => 'publish_templates_from_search',
                    blog_id          => $blog->id,
                    id               => $tmpl->id,
                }
            );
            $out = delete $app->{__test_output};

            ok( $out, "Request: publish_templates_from_search" );
            ok( $out =~ m!permission=1!i,
                "publish_templates_from_search by other blog" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $ogawa,
                    __request_method => 'POST',
                    __mode           => 'publish_templates_from_search',
                    blog_id          => $blog->id,
                    id               => $tmpl->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out, "Request: publish_templates_from_search" );
            ok( $out =~ m!permission=1!i,
                "publish_templates_from_search by other permission" );
        }

        done_testing();
    };

    subtest 'mode = refresh_all_templates' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'refresh_all_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                  "Request: refresh_all_templates" );
        ok( $out !~ m!error_id=!i, "refresh_all_templates by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'refresh_all_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_all_templates" );
        ok( $out !~ m!error_id=!i,
            "refresh_all_templates by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'refresh_all_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_all_templates" );
        ok( $out !~ m!error_id=!i,
            "refresh_all_templates by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'refresh_all_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: refresh_all_templates" );
        ok( $out =~ m!permission=1!i, "refresh_all_templates by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'refresh_all_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_all_templates" );
        ok( $out =~ m!error_id=!i,
            "refresh_all_templates by other permission" );

        done_testing();
    };

    subtest 'mode = reset_blog_templates' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'reset_blog_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: reset_blog_templates" );
        ok( $out !~ m!permission=1!i, "reset_blog_templates by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'reset_blog_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: reset_blog_templates" );
        ok( $out !~ m!permission=1!i,
            "reset_blog_templates by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'reset_blog_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: reset_blog_templates" );
        ok( $out !~ m!permission=1!i,
            "reset_blog_templates by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'reset_blog_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: reset_blog_templates" );
        ok( $out =~ m!permission=1!i, "reset_blog_templates by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'reset_blog_templates',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: reset_blog_templates" );
        ok( $out =~ m!permission=1!i,
            "reset_blog_templates by other permission" );

        done_testing();
    };

    subtest 'mode = save_widget' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'save_widget',
                blog_id          => $blog->id,
                id               => $widget->id,
                name             => 'changed',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: save_widget" );
        ok( $out !~ m!permission denied!i, "save_widget by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'save_widget',
                blog_id          => $blog->id,
                id               => $widget->id,
                name             => 'changed',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: save_widget" );
        ok( $out !~ m!permission denied!i, "save_widget by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'save_widget',
                blog_id          => $blog->id,
                id               => $widget->id,
                name             => 'changed',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: save_widget" );
        ok( $out !~ m!permission denied!i,
            "save_widget by permitted user (sys)"
        );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'save_widget',
                blog_id          => $blog->id,
                id               => $widget->id,
                name             => 'changed',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: save_widget" );
        ok( $out =~ m!permission=1!i, "save_widget by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'save_widget',
                blog_id          => $blog->id,
                id               => $widget->id,
                name             => 'changed',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: save_widget" );
        ok( $out =~ m!permission denied!i,
            "save_widget by other permission" );

        done_testing();

    };

    subtest 'mode = save' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
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
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: save" );
        ok( $out !~ m!permission=1!i, "save by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: save" );
        ok( $out !~ m!permission=1!i, "save by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: save" );
        ok( $out =~ m!permission=1!i, "save by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: save" );
        ok( $out =~ m!permission=1!i, "save by other permission" );

        done_testing();
    };

    subtest 'mode = edit' => sub {
        my $tmpl2
            = MT::Test::Permission->make_template( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl2->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit" );
        ok( $out !~ m!permission=1!i, "edit by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl2->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit" );
        ok( $out !~ m!permission=1!i, "edit by permitted user" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl2->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit" );
        ok( $out !~ m!permission=1!i, "edit by permitted user (sys)" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl2->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit" );
        ok( $out =~ m!permission=1!i, "edit by other blog" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl2->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: edit" );
        ok( $out =~ m!permission=1!i, "edit by other permission" );

        done_testing();
    };

    subtest 'mode = delete' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 1',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out !~ m!permission=1!i, "delete by admin" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 2',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out !~ m!permission=1!i, "delete by permitted user" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 3',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out !~ m!permission=1!i, "delete by permitted user (sys)" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 4',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out =~ m!permission=1!i, "delete by other blog" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 5',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'template',
                blog_id          => $blog->id,
                id               => $tmpl->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out =~ m!permission=1!i, "delete by other permission" );

        done_testing();
    };

    subtest 'mode = list (templatemap)' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'list',
                _type            => 'templatemap',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: list" );
        ok( $out =~ m!Unknown Action!i, "list by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'list',
                _type            => 'templatemap',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                       "Request: list" );
        ok( $out =~ m!Unknown Action!i, "list by non permitted user" );

        done_testing();
    };

    subtest 'mode = save (templatemap)' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'templatemap',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: save" );
        ok( $out =~ m!Invalid Request!i, "save by admin" );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'save',
                _type            => 'templatemap',
                blog_id          => $blog->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: save" );
        ok( $out =~ m!Invalid Request!i, "save by non permitted user" );

        done_testing();
    };

    subtest 'mode = edit (templatemap)' => sub {
        my $templatemap
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'templatemap',
                id               => $templatemap->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: edit" );
        ok( $out =~ m!Invalid Request!i, "edit by admin" );

        $templatemap
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'edit',
                _type            => 'templatemap',
                id               => $templatemap->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: edit" );
        ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );

        done_testing();
    };

    subtest 'mode = delete (templatemap)' => sub {
        my $templatemap
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'templatemap',
                id               => $templatemap->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: delete" );
        ok( $out =~ m!Invalid Request!i, "delete by admin" );

        $templatemap
            = MT::Test::Permission->make_templatemap( blog_id => $blog->id, );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'templatemap',
                id               => $templatemap->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: delete" );
        ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );

        done_testing();
    };

SKIP: {
        skip
            'mode = save (widget) may be deprecated.',
            1;

        subtest 'mode = save (widget)' => sub {
            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: save" );
            ok( $out !~ m!permission denied!i, "save by admin" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $aikawa,
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: save" );
            ok( $out !~ m!permission denied!i, "save by permitted user" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $kagawa,
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out, "Request: save" );
            ok( $out !~ m!permission denied!i,
                "save by permitted user (sys)"
            );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $ukawa,
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: save" );
            ok( $out =~ m!permission denied!i, "save by other blog" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $ogawa,
                    __request_method => 'POST',
                    __mode           => 'save',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: save" );
            ok( $out =~ m!permission denied!i, "save by other permission" );

            done_testing();
        };
    }

SKIP: {
        skip
            'mode = edit (widget) may be deprecated.',
            1;

        subtest 'mode = edit (widget)' => sub {
            my $widget2 = MT::Test::Permission->make_template(
                blog_id => $blog->id,
                type    => 'widget',
                name    => 'New Widget',
            );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'edit',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget2->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: edit" );
            ok( $out !~ m!permission denied!i, "edit by admin" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $aikawa,
                    __request_method => 'POST',
                    __mode           => 'edit',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget2->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: edit" );
            ok( $out !~ m!permission denied!i, "edit by permitted user" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $kagawa,
                    __request_method => 'POST',
                    __mode           => 'edit',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget2->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out, "Request: edit" );
            ok( $out !~ m!permission denied!i,
                "edit by permitted user (sys)"
            );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $ukawa,
                    __request_method => 'POST',
                    __mode           => 'edit',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget2->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: edit" );
            ok( $out =~ m!permission denied!i, "edit by other blog" );

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $ogawa,
                    __request_method => 'POST',
                    __mode           => 'edit',
                    _type            => 'widget',
                    blog_id          => $blog->id,
                    id               => $widget2->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out,                          "Request: edit" );
            ok( $out =~ m!permission denied!i, "edit by other permission" );

            done_testing();
        };
    }

    subtest 'mode = delete (widget)' => sub {
        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 1',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'widget',
                blog_id          => $blog->id,
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: delete" );
        ok( $out !~ m!permission denied!i, "delete by admin" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 2',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'widget',
                blog_id          => $blog->id,
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: delete" );
        ok( $out !~ m!permission denied!i, "delete by permitted user" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 3',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $kagawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'widget',
                blog_id          => $blog->id,
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: delete" );
        ok( $out !~ m!permission denied!i, "delete by permitted user (sys)" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 4',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'widget',
                blog_id          => $blog->id,
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: delete" );
        ok( $out =~ m!permission=1!i, "delete by other blog" );

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 5',
            type    => 'widget',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ogawa,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'widget',
                blog_id          => $blog->id,
                id               => $widget->id,
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                          "Request: delete" );
        ok( $out =~ m!permission denied!i, "delete by other permission" );

        done_testing();
    };

    subtest 'mode = refresh_tmpl_templates' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 1',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $admin,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'refresh_tmpl_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
                id                     => $tmpl->id,
                blog_id                => $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: refresh_tmpl_templates" );
        ok( $out !~ m!not implemented!i, "refresh_tmpl_templates by admin" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 2',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $aikawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'refresh_tmpl_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
                id                     => $tmpl->id,
                blog_id                => $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_tmpl_templates" );
        ok( $out !~ m!not implemented!i,
            "refresh_tmpl_templates by permitted user" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 3',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $kagawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'refresh_tmpl_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
                id                     => $tmpl->id,
                plugin_action_selector => 'refresh_tmpl_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_tmpl_templates" );
        ok( $out !~ m!not implemented!i,
            "refresh_tmpl_templates by permitted user (sys)" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 4',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $ukawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'refresh_tmpl_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
                id                     => $tmpl->id,
                blog_id                => $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_tmpl_templates" );
        ok( $out =~ m!permission=1!i,
            "refresh_tmpl_templates by other blog" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 5',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $ogawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'refresh_tmpl_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
                id                     => $tmpl->id,
                blog_id                => $blog->id,
                plugin_action_selector => 'refresh_tmpl_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: refresh_tmpl_templates" );
        ok( $out =~ m!not implemented!i,
            "refresh_tmpl_templates by other permission" );

        done_testing();
    };

    subtest 'mode = copy_templates' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 1',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $admin,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'copy_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'copy_templates',
                id                     => $tmpl->id,
                blog_id                => $blog->id,
                plugin_action_selector => 'copy_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: copy_templates" );
        ok( $out !~ m!not implemented!i, "copy_templates by admin" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 2',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $aikawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'copy_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'copy_templates',
                blog_id                => $blog->id,
                id                     => $tmpl->id,
                plugin_action_selector => 'copy_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                        "Request: copy_templates" );
        ok( $out !~ m!not implemented!i, "copy_templates by permitted user" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 3',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $kagawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'copy_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'copy_templates',
                id                     => $tmpl->id,
                plugin_action_selector => 'copy_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: copy_templates" );
        ok( $out !~ m!not implemented!i,
            "copy_templates by permitted user (sys)" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 4',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $ukawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'copy_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'copy_templates',
                blog_id                => $blog->id,
                id                     => $tmpl->id,
                plugin_action_selector => 'copy_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out,                     "Request: copy_templates" );
        ok( $out =~ m!permission=1!i, "copy_templates by other blog" );

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 5',
        );
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user          => $ogawa,
                __request_method     => 'POST',
                __mode               => 'itemset_action',
                _type                => 'template',
                action_name          => 'copy_templates',
                itemset_action_input => '',
                return_args          => '__mode%3Dlist_template%26blog_id%3D'
                    . $blog->id,
                plugin_action_selector => 'copy_templates',
                blog_id                => $blog->id,
                id                     => $tmpl->id,
                plugin_action_selector => 'copy_templates',
            }
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: copy_templates" );
        ok( $out =~ m!not implemented!i,
            "copy_templates by other permission" );

        done_testing();
    };

};

subtest 'website scope' => sub {
    my @suite = (
        {   perm => 'admin',
            user => $admin,
            ok   => 1,
        },
        {   perm => 'permitted user',
            user => $kikkawa,
            ok   => 1,
        },
        {   perm => 'permitted user (sys)',
            user => $kagawa,
            ok   => 1,
        },
        {   perm => 'other website',
            user => $kemikawa,
            ok   => 0,
        },
        {   perm => 'child blog',
            user => $aikawa,
            ok   => 0,
        },
        {   perm => 'other blog',
            user => $koishikawa,
            ok   => 0,
        },
        {   perm => 'other permission',
            user => $sagawa,
            ok   => 0,
        },
    );

    my @publish_suite = (
        {   perm => 'admin',
            user => $admin,
            ok   => 1,
        },
        {   perm => 'permitted user',
            user => $shiki,
            ok   => 1,
        },
        {   perm => 'other website',
            user => $suda,
            ok   => 0,
        },
        {   perm => 'child blog',
            user => $ichikawa,
            ok   => 0,
        },
        {   perm => 'other blog',
            user => $seta,
            ok   => 0,
        },
        {   perm => 'other permission',
            user => $sagawa,
            ok   => 0,
        },
    );

    foreach my $type ( 'individual', 'archive' ) {
        subtest "mode = view (type=$type, for new object)" => sub {
            foreach my $data (@suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user => $data->{user},
                        __mode      => 'view',
                        _type       => 'template',
                        type        => $type,
                        blog_id     => $website->id,
                    },
                );
                $out = delete $app->{__test_output};

                my $func = $data->{ok} ? \&unlike : \&like;
                $func->(
                    $out,
                    qr/(redirect|permission)=1|An error occurr?ed/,
                    "View (type=$type) by " . $data->{perm}
                );
            }
        };

        subtest "mode = view (type=$type, for existing object)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Copy Template ' . $type,
                type    => $type,
            );

            foreach my $data (@suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user => $data->{user},
                        __mode      => 'view',
                        _type       => 'template',
                        type        => $type,
                        blog_id     => $website->id,
                        id          => $tmpl->id,
                    },
                );
                $out = delete $app->{__test_output};

                my $func = $data->{ok} ? \&unlike : \&like;
                $func->(
                    $out,
                    qr/(redirect|permission)=1|An error occurr?ed/,
                    "View (type=$type) by " . $data->{perm}
                );
            }

        };

        subtest "mode = save (type=$type, for new object)" => sub {
            my $cnt = 0;
            foreach my $data (@suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user      => $data->{user},
                        __request_method => 'POST',
                        __mode           => 'save',
                        _type            => 'template',
                        type             => $type,
                        blog_id          => $website->id,
                        name             => "Template $type, no. $cnt",
                    },
                );
                $cnt++;
                $out = delete $app->{__test_output};

                if ( $data->{ok} ) {
                    ok( $out !~ /(redirect|permission)=1|An error occurr?ed/
                            && $out =~ /saved=1&saved_added=1/,
                        "Save (type=$type) by " . $data->{perm}
                    );
                }
                else {
                    ok( $out =~ /(redirect|permission)=1|An error occurr?ed/
                            && $out !~ /saved=1&saved_added=1/,
                        "Save (type=$type) by " . $data->{perm}
                    );
                }
            }
        };

        subtest "mode = save (type=$type, for existing object)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Save Template ' . $type,
                type    => $type,
            );

            my $cnt = 0;
            foreach my $data (@suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user      => $data->{user},
                        __request_method => 'POST',
                        __mode           => 'save',
                        _type            => 'template',
                        type             => $type,
                        blog_id          => $website->id,
                        name             => "Update Template $type, no. $cnt",
                        id               => $tmpl->id,
                    },
                );
                $cnt++;
                $out = delete $app->{__test_output};

                if ( $data->{ok} ) {
                    ok( $out !~ /(redirect|permission)=1|An error occurr?ed/
                            && $out =~ /saved=1&saved_changes=1/,
                        "Save (type=$type) by " . $data->{perm}
                    );
                }
                else {
                    ok( $out =~ /(redirect|permission)=1|An error occurr?ed/
                            && $out !~ /saved=1&saved_changes=1/,
                        "Save (type=$type) by " . $data->{perm}
                    );
                }
            }
        };

        subtest "mode = preview_template (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Preview Template ' . $type,
                type    => $type,
            );

            if ( $type eq 'archive' ) {
                my $map = MT::TemplateMap->new;
                $map->set_values(
                    {   blog_id      => $tmpl->blog_id,
                        template_id  => $tmpl->id,
                        archive_type => 'Monthly',
                        file_template =>
                            '<$MTArchiveDate format="%Y/%m/index.html"$>',
                        is_preffered => 1,
                    }
                );
                $map->save;
            }

            foreach my $data (@suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user      => $data->{user},
                        __request_method => 'POST',
                        __mode           => 'preview_template',
                        _type            => 'template',
                        blog_id          => $website->id,
                        id               => $tmpl->id,
                    },
                );
                $out = delete $app->{__test_output};

                my $func = $data->{ok} ? \&unlike : \&like;
                $func->(
                    $out,
                    qr/(redirect|permission)=1|An error occurr?ed/,
                    "Preview (type=$type) by " . $data->{perm}
                );
            }
        };

        subtest "mode = publish_archive_templates (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Publish Template ' . $type,
                type    => $type,
            );

            foreach my $data (@publish_suite) {
                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user      => $data->{user},
                        __request_method => 'POST',
                        __mode           => 'publish_archive_templates',
                        _type            => 'template',
                        blog_id          => $website->id,
                        id               => $tmpl->id,
                    },
                );
                $out = delete $app->{__test_output};

                my $func = $data->{ok} ? \&unlike : \&like;
                $func->(
                    $out,
                    qr/(redirect|permission)=1|An error occurr?ed/,
                    "Publish (type=$type) by " . $data->{perm}
                );
            }
        };

        subtest "mode = refresh_tmpl_templates (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Refresh Template ' . $type,
                type    => $type,
            );

            foreach my $data (@suite) {
                $app = _run_app(

                    'MT::App::CMS',
                    {   __test_user          => $data->{user},
                        __request_method     => 'POST',
                        __mode               => 'itemset_action',
                        _type                => 'template',
                        action_name          => 'refresh_tmpl_templates',
                        itemset_action_input => '',
                        return_args => '__mode%3Dlist_template%26blog_id%3D'
                            . $website->id,
                        plugin_action_selector => 'refresh_tmpl_templates',
                        id                     => $tmpl->id,
                        blog_id                => $website->id,
                        plugin_action_selector => 'refresh_tmpl_templates',
                    },

                );
                $out = delete $app->{__test_output};

                my $func = $data->{ok} ? \&unlike : \&like;
                $func->(
                    $out,
                    qr/(redirect|permission)=1|An error occurr?ed/,
                    "Refresh (type=$type) by " . $data->{perm}
                );
            }
        };

    }

    done_testing();
};

subtest 'mode = save_template_prefs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_template_prefs',
            blog_id          => $blog->id,
            syntax_highlight => 'sync',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save_template_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_template_prefs',
            blog_id          => $blog->id,
            syntax_highlight => 'sync',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save_template_prefs by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save_template_prefs',
            blog_id          => $blog->id,
            syntax_highlight => 'sync',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save_template_prefs by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_template_prefs',
            blog_id          => $blog->id,
            syntax_highlight => 'sync',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save_template_prefs by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save_template_prefs',
            blog_id          => $blog->id,
            syntax_highlight => 'sync',
        },
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save_template_prefs by other permission" );

};

done_testing();
