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
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

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

    my $admin = MT::Author->load(1);

    # Role
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $manage_pages => $blog);
    MT::Association->link($ichikawa => $manage_pages => $second_blog);
    MT::Association->link($ukawa    => $designer     => $blog);

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
        title     => 'my entry',
    );

    # Page
    my $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
        title     => 'my page',
    );
});

my $blog        = MT::Blog->load({ name => 'my blog' });
my $second_blog = MT::Blog->load({ name => 'second blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });

my $admin = MT::Author->load(1);

my $entry = MT::Entry->load({ title => 'my entry' });
my $page  = MT::Page->load({ title => 'my page' });

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'page',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'page',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'page',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'page',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by other permission");
};

subtest 'mode = save_pages' => sub {
    my $author_id = "author_id_" . $page->id;
    my $col_name  = "title_" . $page->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode     => 'save_pages',
        _type      => 'page',
        blog_id    => $blog->id,
        $author_id => $page->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_pages by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode     => 'save_pages',
        _type      => 'page',
        blog_id    => $blog->id,
        $author_id => $page->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_pages by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'save_pages',
        _type      => 'page',
        blog_id    => $blog->id,
        $author_id => $page->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_pages by other permission");

    $app->login($ichikawa);
    $app->post_ok({
        __mode     => 'save_pages',
        _type      => 'page',
        blog_id    => $second_blog->id,
        $author_id => $page->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_pages by other blog");

    $author_id = "author_id_" . $entry->id;
    $col_name  = "title_" . $entry->id;
    $app->login($ichikawa);
    $app->post_ok({
        __mode     => 'save_pages',
        _type      => 'page',
        blog_id    => $blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_pages by type mismatch");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("save by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("save by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("save by other permission");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        blog_id => $blog->id,
        id      => $entry->id,
        _type   => 'page',
    });
    $app->has_permission_error("save by type mismatch");
};

subtest 'mode = edit' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("edit by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("edit by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("edit by other permission");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        blog_id => $blog->id,
        id      => $entry->id,
        _type   => 'page',
    });
    $app->has_permission_error("edit by type mismatch");
};

subtest 'mode = delete' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("delete by admin");

    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_no_permission_error("delete by permitted user");

    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
    );
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("delete by other blog");

    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
    );
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        id      => $page->id,
        _type   => 'page',
    });
    $app->has_permission_error("delete by other permission");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => $blog->id,
        id      => $entry->id,
        _type   => 'page',
    });
    $app->has_permission_error("delete by type mismatch");
};

subtest 'action = set_draft' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other permission");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by type mismatch");
};

subtest 'action = add_tags' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other permission");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by type mismatch");
};

subtest 'action = remove_tags' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other permission");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by type mismatch");
};

subtest 'action = open_batch_editor' => sub {
    $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by permitted user");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other permission");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other blog");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'page',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_page%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by type mismatch");
};

subtest 'mode = save_entry_prefs (page)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'page',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_no_permission_error("save_entry_prefs by admin");

    $app->login($aikawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'page',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_no_permission_error("save_entry_prefs by permitted user");

    $app->login($ukawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'page',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_permission_error("save_entry_prefs by other permission");

    $app->login($ichikawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'page',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_permission_error("save_entry_prefs by other blog");
};

done_testing();
