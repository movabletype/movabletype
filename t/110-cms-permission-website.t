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
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
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

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);
my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);
my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);
my $kemikawa = MT::Test::Permission->make_author(
    name => 'kemikawa',
    nickname => 'Shiro Kemikawa',
);

my $admin = MT::Author->load(1);

# Role
my $edit_config = MT::Test::Permission->make_role(
   name  => 'Edit Config',
   permissions => "'edit_config'",
);
my $edit_templates = MT::Test::Permission->make_role(
   name  => 'Edit Templates',
   permissions => "'edit_templates'",
);
my $website_admin = MT::Role->load({ name => MT->translate('Website Administrator') });
my $designer = MT::Role->load({ name => MT->translate('Designer') });

require MT::Association;
MT::Association->link( $aikawa => $website_admin => $website );
MT::Association->link( $ichikawa => $designer => $blog );
MT::Association->link( $egawa => $website_admin => $second_website );
MT::Association->link( $ogawa => $edit_config => $website );
MT::Association->link( $kagawa => $edit_config => $second_website );

MT::Association->link( $kikkawa => $edit_templates => $website );
MT::Association->link( $kumekawa => $edit_templates => $second_website );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id( 0 );
$p->author_id( $ukawa->id );
$p->permissions( "'create_website'" );
$p->save;

$p = MT::Permission->new;
$p->blog_id( 0 );
$p->author_id( $kemikawa->id );
$p->permissions( "'edit_templates'" );
$p->save;

# Run
my ( $app, $out );

subtest 'mode = list_website' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_website" );
    ok( $out !~ m!permission=1!i, "list_website by admin" ); #TODO: should use 'Permission Denied' instead

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_website" );
    ok( $out !~ m!permission=1!i, "list_website by permitted user" ); #TODO: should use 'Permission Denied' instead

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list_website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_website" );
    ok( $out =~ m!permission=1!i, "list_website by child blog" ); #TODO: should use 'Permission Denied' instead
};

subtest 'mode = move_blogs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'blog',
            action_name      => 'move_blogs',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_blogs%26blog_id%3D'.$website->id,
            plugin_action_selector => 'move_blogs',
            id               => $blog->id,
            plugin_action_selector => 'move_blogs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: move_blogs" );
    ok( $out !~ m!Permission denied!i, "move_blogs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'blog',
            action_name      => 'move_blogs',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_blogs%26blog_id%3D'.$website->id,
            plugin_action_selector => 'move_blogs',
            id               => $blog->id,
            plugin_action_selector => 'move_blogs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: move_blogs" );
    ok( $out =~ m!Permission denied!i, "move_blogs by non permitted user" );
};


subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'websiteName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'WebsiteName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'WebsiteName',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save (new) by blog admin" );
    done_testing();
};

subtest 'mode = save (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by permitted user (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by non permitted user (create website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by other blog (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (edit) by other permission" );
    done_testing();
};

subtest 'mode = edit (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "edit (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "edit (new) by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'website',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "edit (new) by blog admin" );
    done_testing();
};

subtest 'mode = edit (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by permitted user (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by permitted user (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by non permitted user (create website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by other blog (website admin)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by other blog (edit config)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'website',
            name             => 'BlogName',
            id               => $website->id,
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (edit) by other permission" );
    done_testing();
};

subtest 'mode = delete' => sub {
    $website = MT::Test::Permission->make_website();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission denied!i, "delete by admin" );

    $website = MT::Test::Permission->make_website();
    MT::Association->link( $aikawa => $website_admin => $website );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!Permission denied!i, "delete by permitted user (website admin)" );

    $website = MT::Test::Permission->make_website();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete by non permitted user (create website)" );

    $website = MT::Test::Permission->make_website();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete by other blog (website admin)" );

    $website = MT::Test::Permission->make_website();
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'website',
            id               => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!Permission denied!i, "delete by other permission" );
    done_testing();
};

subtest 'action = refresh_website_templates' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'website',
            action_name      => 'refresh_website_templates',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_website%26blog_id%3D'.$website->id,
            plugin_action_selector => 'refresh_website_templates',
            id               => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out !~ m!Permission denied!i, "refresh_website_templates by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'website',
            action_name      => 'refresh_website_templates',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_website%26blog_id%3D'.$website->id,
            plugin_action_selector => 'refresh_website_templates',
            id               => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out !~ m!Permission denied!i, "refresh_website_templates by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kemikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'website',
            action_name      => 'refresh_website_templates',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_website%26blog_id%3D'.$website->id,
            plugin_action_selector => 'refresh_website_templates',
            id               => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out !~ m!Permission denied!i, "refresh_website_templates by permitted user (system)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'website',
            action_name      => 'refresh_website_templates',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_website%26blog_id%3D'.$website->id,
            plugin_action_selector => 'refresh_website_templates',
            id               => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out =~ m!Permission denied!i, "refresh_website_templates by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'website',
            action_name      => 'refresh_website_templates',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_website%26blog_id%3D'.$website->id,
            plugin_action_selector => 'refresh_website_templates',
            id               => $website->id,
            plugin_action_selector => 'refresh_website_templates',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: refresh_website_templates" );
    ok( $out =~ m!Permission denied!i, "refresh_website_templates by other permission" );
};

done_testing();

