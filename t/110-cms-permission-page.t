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

my $admin = MT::Author->load(1);

# Role
my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );

require MT::Association;
MT::Association->link( $aikawa => $manage_pages => $blog );
MT::Association->link( $ichikawa => $manage_pages => $second_blog );
MT::Association->link( $ukawa => $designer => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $aikawa->id,
);

# Page
my $page = MT::Test::Permission->make_page(
    blog_id        => $blog->id,
    author_id      => $aikawa->id,
);

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'page',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'page',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'page',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'page',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = save_pages' => sub {
    my $author_id  = "author_id_" . $page->id;
    my $col_name  = "title_" . $page->id;

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_pages',
            _type            => 'page',
            blog_id          => $blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_pages" );
    ok( $out !~ m!permission=1!i, "save_pages by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_pages',
            _type            => 'page',
            blog_id          => $blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_pages" );
    ok( $out !~ m!permission=1!i, "save_pages by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_pages',
            _type            => 'page',
            blog_id          => $blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_pages" );
    ok( $out =~ m!permission=1!i, "save_pages by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_pages',
            _type            => 'page',
            blog_id          => $second_blog->id,
            $author_id       => $page->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_pages" );
    ok( $out =~ m!permission=1!i, "save_pages by other blog" );

    $author_id  = "author_id_" . $entry->id;
    $col_name  = "title_" . $entry->id;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_pages',
            _type            => 'page',
            blog_id          => $blog->id,
            $author_id       => $entry->author->id,
            $col_name        => 'changed',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_pages" );
    ok( $out =~ m!permission=1!i, "save_pages by type mismatch" );

    done_testing();
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i, "save by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            id               => $entry->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i, "save by type mismatch" );

    done_testing();
};

subtest 'mode = edit' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            id               => $entry->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by type mismatch" );

    done_testing();
};

subtest 'mode = delete' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $ukawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $ukawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by permitted user" );

    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $ukawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other blog" );

    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $ukawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $page->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => $blog->id,
            id               => $entry->id,
            _type            => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by type mismatch" );

    done_testing();
};

subtest 'action = set_draft' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i, "set_draft by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out !~ m!not implemented!i, "set_draft by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $page->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!not implemented!i, "set_draft by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'set_draft',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'set_draft',
            id               => $entry->id,
            plugin_action_selector => 'set_draft',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: set_draft" );
    ok( $out =~ m!permission=1!i, "set_draft by type mismatch" );

    done_testing();
};

subtest 'action = add_tags' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out !~ m!not implemented!i, "add_tags by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $page->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!not implemented!i, "add_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'add_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'add_tags',
            id               => $entry->id,
            plugin_action_selector => 'add_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_tags" );
    ok( $out =~ m!permission=1!i, "add_tags by type mismatch" );

    done_testing();
};

subtest 'action = remove_tags' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out !~ m!not implemented!i, "remove_tags by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $page->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!not implemented!i, "remove_tags by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'remove_tags',
            itemset_action_input => 'New Tag',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'remove_tags',
            id               => $entry->id,
            plugin_action_selector => 'remove_tags',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_tags" );
    ok( $out =~ m!permission=1!i, "remove_tags by type mismatch" );

    done_testing();
};

subtest 'action = open_batch_editor' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id        => $blog->id,
        author_id      => $aikawa->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i, "open_batch_editor by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out !~ m!not implemented!i, "open_batch_editor by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i, "open_batch_editor by other permission" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $page->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!not implemented!i, "open_batch_editor by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'page',
            action_name      => 'open_batch_editor',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_page%26blog_id%3D'.$blog->id.'%26filter_key%3Dmy_posts_on_this_context',
            blog_id          => $blog->id,
            plugin_action_selector => 'open_batch_editor',
            id               => $entry->id,
            plugin_action_selector => 'open_batch_editor',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: open_batch_editor" );
    ok( $out =~ m!permission=1!i, "open_batch_editor by type mismatch" );

    done_testing();
};

done_testing();
