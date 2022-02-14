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
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );
    my $other_website = MT::Test::Permission->make_website(
        name => 'other website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
    );
    my $other_blog = MT::Test::Permission->make_blog(
        parent_id => $other_website->id,
        name      => 'other blog',
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
    MT::Association->link($aikawa   => $edit_templates => $blog);
    MT::Association->link($ichikawa => $rebuild        => $blog);
    MT::Association->link($ukawa    => $edit_templates => $second_blog);
    MT::Association->link($egawa    => $rebuild        => $second_blog);
    MT::Association->link($ogawa    => $create_post    => $blog);

    MT::Association->link($kikkawa, $edit_templates, $website);
    MT::Association->link($sagawa,  $create_post,    $website);
    MT::Association->link($shiki,   $rebuild,        $website);

    MT::Association->link($kemikawa, $edit_templates, $other_website);
    MT::Association->link($suda,     $rebuild,        $other_website);

    MT::Association->link($koishikawa, $edit_templates, $other_blog);
    MT::Association->link($seta,       $rebuild,        $other_blog);

    $kagawa->can_edit_templates(1);
    $kagawa->save();

    # Template
    my $tmpl = MT::Test::Permission->make_template(
        blog_id => $blog->id,
        name    => 'my template',
    );

    my $widget = MT::Test::Permission->make_template(
        blog_id => $blog->id,
        type    => 'widget',
        name    => 'my widget',
    );

    my $sys_tmpl = MT::Test::Permission->make_template(blog_id => 0,);
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa     = MT::Author->load({ name => 'aikawa' });
my $ichikawa   = MT::Author->load({ name => 'ichikawa' });
my $ukawa      = MT::Author->load({ name => 'ukawa' });
my $egawa      = MT::Author->load({ name => 'egawa' });
my $ogawa      = MT::Author->load({ name => 'ogawa' });
my $kagawa     = MT::Author->load({ name => 'kagawa' });
my $kikkawa    = MT::Author->load({ name => 'kikkawa' });
my $kumekawa   = MT::Author->load({ name => 'kumekawa' });
my $kemikawa   = MT::Author->load({ name => 'kemikawa' });
my $koishikawa = MT::Author->load({ name => 'koishikawa' });
my $sagawa     = MT::Author->load({ name => 'sagawa' });
my $shiki      = MT::Author->load({ name => 'shiki' });
my $suda       = MT::Author->load({ name => 'suda' });
my $seta       = MT::Author->load({ name => 'seta' });

my $admin = MT::Author->load(1);

my $tmpl   = MT::Template->load({ name => 'my template' });
my $widget = MT::Template->load({ name => 'my widget' });

subtest 'blog scope' => sub {

    subtest 'mode = add_map' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode           => 'add_map',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("add_map by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode           => 'add_map',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("add_map by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode           => 'add_map',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("add_map by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode           => 'add_map',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_permission_error("add_map by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode           => 'add_map',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        ok($app->generic_error =~ m!No permissions!i, "add_map by other permission");
    };

    subtest 'mode = delete_map' => sub {
        my $map = MT::Test::Permission->make_templatemap(blog_id => $blog->id,);
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'delete_map',
            blog_id => $blog->id,
            id      => $map->id,
        });
        $app->has_no_permission_error("delete_map by admin");

        $map = MT::Test::Permission->make_templatemap(blog_id => $blog->id,);
        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'delete_map',
            blog_id => $blog->id,
            id      => $map->id,
        });
        $app->has_no_permission_error("delete_map by permitted user");

        $map = MT::Test::Permission->make_templatemap(blog_id => $blog->id,);
        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'delete_map',
            blog_id => $blog->id,
            id      => $map->id,
        });
        $app->has_no_permission_error("delete_map by permitted user (sys)");

        $map = MT::Test::Permission->make_templatemap(blog_id => $blog->id,);
        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'delete_map',
            blog_id => $blog->id,
            id      => $map->id,
        });
        $app->has_permission_error("delete_map by other blog");

        $map = MT::Test::Permission->make_templatemap(blog_id => $blog->id,);
        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'delete_map',
            blog_id => $blog->id,
            id      => $map->id,
        });
        $app->has_permission_error("delete_map by other permission");
    };

    subtest 'mode = delete_widget' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode      => 'delete_widget',
            blog_id     => $blog->id,
            _type       => 'widget',
            id          => $widget->id,
            return_args => MT::Util::encode_html('__mode=list_widget&blog_id=' . $blog->id),
        });
        $app->has_no_permission_error("delete_widget by admin");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 1',
            type    => 'widget',
        );
        $app->login($aikawa);
        $app->post_ok({
            __mode      => 'delete_widget',
            blog_id     => $blog->id,
            _type       => 'widget',
            id          => $widget->id,
            return_args => MT::Util::encode_html('__mode=list_widget&blog_id=' . $blog->id),
        });
        $app->has_no_permission_error("delete_widget by permitted user");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 2',
            type    => 'widget',
        );
        $app->login($kagawa);
        $app->post_ok({
            __mode      => 'delete_widget',
            blog_id     => $blog->id,
            _type       => 'widget',
            id          => $widget->id,
            return_args => MT::Util::encode_html('__mode=list_widget&blog_id=' . $blog->id),
        });
        $app->has_no_permission_error("delete_widget by permitted user (sys)");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 3',
            type    => 'widget',
        );
        $app->login($ukawa);
        $app->post_ok({
            __mode      => 'delete_widget',
            blog_id     => $blog->id,
            _type       => 'widget',
            id          => $widget->id,
            return_args => MT::Util::encode_html('__mode=list_widget&blog_id=' . $blog->id),
        });
        $app->has_permission_error("delete_widget by other blog");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'delete widget 4',
            type    => 'widget',
        );
        $app->login($ogawa);
        $app->post_ok({
            __mode           => 'delete_widget',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
            _type            => 'widget',
            id               => $widget->id,
            return_args      => MT::Util::encode_html('__mode=list_widget&blog_id=' . $blog->id),
        });
        $app->has_permission_error("delete_widget by other permission");
    };

    subtest 'mode = dialog_publishing_profile' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode           => 'dialog_publishing_profile',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_publishing_profile by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode           => 'dialog_publishing_profile',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_publishing_profile by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode           => 'dialog_publishing_profile',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_publishing_profile by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode           => 'dialog_publishing_profile',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_permission_error("dialog_publishing_profile by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode           => 'dialog_publishing_profile',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_permission_error("dialog_publishing_profile by other permission");
    };

    subtest 'mode = dialog_refresh_templates' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode           => 'dialog_refresh_templates',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_refresh_templates by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode           => 'dialog_refresh_templates',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_refresh_templates by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode           => 'dialog_refresh_templates',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_no_permission_error("dialog_refresh_templates by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode           => 'dialog_refresh_templates',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_permission_error("dialog_refresh_templates by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode           => 'dialog_refresh_templates',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
        });
        $app->has_permission_error("dialog_refresh_templates by other permission");
    };

    subtest 'mode = edit_widget' => sub {
        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            type    => 'widget',
        );
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'edit_widget',
            blog_id => $blog->id,
            _type   => 'widget',
            id      => $widget->id,
        });
        $app->has_no_permission_error("edit_widget by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'edit_widget',
            blog_id => $blog->id,
            _type   => 'widget',
            id      => $widget->id,
        });
        $app->has_no_permission_error("edit_widget by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'edit_widget',
            blog_id => $blog->id,
            _type   => 'widget',
            id      => $widget->id,
        });
        $app->has_no_permission_error("edit_widget by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'edit_widget',
            blog_id => $blog->id,
            _type   => 'widget',
            id      => $widget->id,
        });
        $app->has_permission_error("edit_widget by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode           => 'edit_widget',
            blog_id          => $blog->id,
            new_archive_type => 'Individual',
            template_id      => $tmpl->id,
            _type            => 'widget',
            id               => $widget->id,
        });
        $app->has_permission_error("edit_widget by other permission");
    };

    subtest 'mode = list_template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'list_template',
            blog_id => $blog->id,
        });
        $app->has_no_permission_error("list_template by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'list_template',
            blog_id => $blog->id,
        });
        $app->has_no_permission_error("list_template by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'list_template',
            blog_id => $blog->id,
        });
        $app->has_no_permission_error("list_template by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'list_template',
            blog_id => $blog->id,
        });
        $app->has_permission_error("list_template by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'list_template',
            blog_id => $blog->id,
        });
        $app->has_permission_error("list_template by other permission");
    };

    subtest 'mode = preview_template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'preview_template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("preview_template by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'preview_template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("preview_template by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'preview_template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("preview_template by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'preview_template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("preview_template by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'preview_template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("preview_template by other permission");
    };

    subtest 'mode = publish_archive_templates' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'publish_archive_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("publish_archive_templates by admin");

        {
            # XXX: This test is somewhat broken. $ichikawa can only publish and can't edit templates,
            # so the first publishing succeeds but the following listing fails.
            local $app->{max_redirect} = 1;
            $app->login($ichikawa);
            $app->post_ok({
                __mode  => 'publish_archive_templates',
                blog_id => $blog->id,
                id      => $tmpl->id,
            });
            $app->has_no_permission_error("publish_archive_templates by permitted user");
        }

        $app->login($egawa);
        $app->post_ok({
            __mode  => 'publish_archive_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("publish_archive_templates by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'publish_archive_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("publish_archive_templates by other permission");
    };

    subtest 'mode = publish_index_templates' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'publish_index_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("publish_index_templates by admin");

        $app->login($ichikawa);
        $app->post_ok({
            __mode  => 'publish_index_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("publish_index_templates by permitted user");

        $app->login($egawa);
        $app->post_ok({
            __mode  => 'publish_index_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("publish_index_templates by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'publish_index_templates',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("publish_index_templates by other permission");
    };

    subtest 'mode = publish_templates_from_search' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'publish_templates_from_search',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("publish_templates_from_search by admin");

        $app->login($ichikawa);
        $app->post_ok({
            __mode  => 'publish_templates_from_search',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("publish_templates_from_search by permitted user");
    };

    subtest 'mode = refresh_all_templates' => sub {
        # XXX: refresh_all_templates doesn't return permission error properly
        # This block needs further investigation/modification
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'refresh_all_templates',
            blog_id => $blog->id,
        });
        ok(!$app->last_location->query_param('error_id'), "refresh_all_templates by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'refresh_all_templates',
            blog_id => $blog->id,
        });
        ok(
            !$app->last_location->query_param('error_id'),
            "refresh_all_templates by permitted user"
        );

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'refresh_all_templates',
            blog_id => $blog->id,
        });
        ok(
            !$app->last_location->query_param('error_id'),
            "refresh_all_templates by permitted user (sys)"
        );

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'refresh_all_templates',
            blog_id => $blog->id,
        });
        $app->has_permission_error("refresh_all_templates by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'refresh_all_templates',
            blog_id => $blog->id,
        });
        ok(
            $app->last_location->query_param('error_id'),
            "refresh_all_templates by other permission"
        );
        # XXX: and this error seems not reported properly...
    };

    subtest 'mode = save_widget' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'save_widget',
            blog_id => $blog->id,
            id      => $widget->id,
            name    => 'changed',
        });
        $app->has_no_permission_error("save_widget by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'save_widget',
            blog_id => $blog->id,
            id      => $widget->id,
            name    => 'changed',
        });
        $app->has_no_permission_error("save_widget by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'save_widget',
            blog_id => $blog->id,
            id      => $widget->id,
            name    => 'changed',
        });
        $app->has_no_permission_error("save_widget by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'save_widget',
            blog_id => $blog->id,
            id      => $widget->id,
            name    => 'changed',
        });
        $app->has_permission_error("save_widget by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'save_widget',
            blog_id => $blog->id,
            id      => $widget->id,
            name    => 'changed',
        });
        $app->has_permission_error("save_widget by other permission");
    };

    subtest 'mode = save' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'save',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("save by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'save',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("save by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'save',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("save by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'save',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("save by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'save',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("save by other permission");
    };

    subtest 'mode = edit' => sub {
        my $tmpl2 = MT::Test::Permission->make_template(blog_id => $blog->id,);
        my $app   = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'edit',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl2->id,
        });
        $app->has_no_permission_error("edit by admin");

        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'edit',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl2->id,
        });
        $app->has_no_permission_error("edit by permitted user");

        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'edit',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl2->id,
        });
        $app->has_no_permission_error("edit by permitted user (sys)");

        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'edit',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl2->id,
        });
        $app->has_permission_error("edit by other blog");

        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'edit',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl2->id,
        });
        $app->has_permission_error("edit by other permission");
    };

    subtest 'mode = delete' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 1',
        );
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("delete by admin");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 2',
        );
        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("delete by permitted user");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 3',
        );
        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_no_permission_error("delete by permitted user (sys)");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 4',
        );
        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("delete by other blog");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 5',
        );
        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'template',
            blog_id => $blog->id,
            id      => $tmpl->id,
        });
        $app->has_permission_error("delete by other permission");
    };

    subtest 'mode = delete (widget)' => sub {
        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 1',
            type    => 'widget',
        );
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'widget',
            blog_id => $blog->id,
            id      => $widget->id,
        });
        $app->has_no_permission_error("delete by admin");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 2',
            type    => 'widget',
        );
        $app->login($aikawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'widget',
            blog_id => $blog->id,
            id      => $widget->id,
        });
        $app->has_no_permission_error("delete by permitted user");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 3',
            type    => 'widget',
        );
        $app->login($kagawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'widget',
            blog_id => $blog->id,
            id      => $widget->id,
        });
        $app->has_no_permission_error("delete by permitted user (sys)");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 4',
            type    => 'widget',
        );
        $app->login($ukawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'widget',
            blog_id => $blog->id,
            id      => $widget->id,
        });
        $app->has_permission_error("delete by other blog");

        $widget = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Template 5',
            type    => 'widget',
        );
        $app->login($ogawa);
        $app->post_ok({
            __mode  => 'delete',
            _type   => 'widget',
            blog_id => $blog->id,
            id      => $widget->id,
        });
        $app->has_permission_error("delete by other permission");
    };

    subtest 'mode = refresh_tmpl_templates' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 1',
        );
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'refresh_tmpl_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'refresh_tmpl_templates',
        });
        $app->has_no_permission_error("refresh_tmpl_templates by admin");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 2',
        );
        $app->login($aikawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'refresh_tmpl_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'refresh_tmpl_templates',
        });
        $app->has_no_permission_error("refresh_tmpl_templates by permitted user");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 3',
        );
        $app->login($kagawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'refresh_tmpl_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            plugin_action_selector => 'refresh_tmpl_templates',
        });
        $app->has_no_permission_error("refresh_tmpl_templates by permitted user (sys)");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 4',
        );
        $app->login($ukawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'refresh_tmpl_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'refresh_tmpl_templates',
        });
        $app->has_permission_error("refresh_tmpl_templates by other blog");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Refresh Template 5',
        );
        $app->login($ogawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'refresh_tmpl_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'refresh_tmpl_templates',
        });
        $app->has_permission_error("refresh_tmpl_templates by other permission");
    };

    subtest 'mode = copy_templates' => sub {
        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 1',
        );
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'copy_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'copy_templates',
        });
        $app->has_no_permission_error("copy_templates by admin");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 2',
        );
        $app->login($aikawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'copy_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            blog_id                => $blog->id,
            id                     => $tmpl->id,
            plugin_action_selector => 'copy_templates',
        });
        $app->has_no_permission_error("copy_templates by permitted user");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 3',
        );
        $app->login($kagawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'copy_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            id                     => $tmpl->id,
            plugin_action_selector => 'copy_templates',
        });
        $app->has_no_permission_error("copy_templates by permitted user (sys)");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 4',
        );
        $app->login($ukawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'copy_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            blog_id                => $blog->id,
            id                     => $tmpl->id,
            plugin_action_selector => 'copy_templates',
        });
        $app->has_permission_error("copy_templates by other blog");

        $tmpl = MT::Test::Permission->make_template(
            blog_id => $blog->id,
            name    => 'Copy Template 5',
        );
        $app->login($ogawa);
        $app->post_ok({
            __mode                 => 'itemset_action',
            _type                  => 'template',
            action_name            => 'copy_templates',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_template%26blog_id%3D' . $blog->id,
            blog_id                => $blog->id,
            id                     => $tmpl->id,
            plugin_action_selector => 'copy_templates',
        });
        $app->has_permission_error("copy_templates by other permission");
    };
};

subtest 'website scope' => sub {
    my @suite = ({
            perm => 'admin',
            user => $admin,
            ok   => 1,
        },
        {
            perm => 'permitted user',
            user => $kikkawa,
            ok   => 1,
        },
        {
            perm => 'permitted user (sys)',
            user => $kagawa,
            ok   => 1,
        },
        {
            perm => 'other website',
            user => $kemikawa,
            ok   => 0,
        },
        {
            perm => 'child blog',
            user => $aikawa,
            ok   => 0,
        },
        {
            perm => 'other blog',
            user => $koishikawa,
            ok   => 0,
        },
        {
            perm => 'other permission',
            user => $sagawa,
            ok   => 0,
        },
    );

    my @publish_suite = ({
            perm => 'admin',
            user => $admin,
            ok   => 1,
        },
        {
            perm => 'permitted user',
            user => $shiki,
            ok   => 1,
        },
        {
            perm => 'other website',
            user => $suda,
            ok   => 0,
        },
        {
            perm => 'child blog',
            user => $ichikawa,
            ok   => 0,
        },
        {
            perm => 'other blog',
            user => $seta,
            ok   => 0,
        },
        {
            perm => 'other permission',
            user => $sagawa,
            ok   => 0,
        },
    );

    foreach my $type ('individual', 'archive') {
        subtest "mode = view (type=$type, for new object)" => sub {
            foreach my $data (@suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->get_ok({
                    __mode  => 'view',
                    _type   => 'template',
                    type    => $type,
                    blog_id => $website->id,
                });

                if ($data->{ok}) {
                    $app->has_no_permission_error("View (type=$type) new by $data->{perm}");
                } else {
                    $app->has_permission_error("View (type=$type) new by $data->{perm}");
                }
            }
        };

        subtest "mode = view (type=$type, for existing object)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Copy Template ' . $type,
                type    => $type,
            );

            foreach my $data (@suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->get_ok({
                    __mode  => 'view',
                    _type   => 'template',
                    type    => $type,
                    blog_id => $website->id,
                    id      => $tmpl->id,
                });

                if ($data->{ok}) {
                    $app->has_no_permission_error("View (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("View (type=$type) by " . $data->{perm});
                }
            }

        };

        subtest "mode = save (type=$type, for new object)" => sub {
            my $cnt = 0;
            foreach my $data (@suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->post_ok({
                    __mode  => 'save',
                    _type   => 'template',
                    type    => $type,
                    blog_id => $website->id,
                    name    => "Template $type, no. $cnt",
                });
                $cnt++;

                if ($data->{ok}) {
                    $app->has_no_permission_error("Save (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("Save (type=$type) by " . $data->{perm});
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
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->post_ok({
                    __mode  => 'save',
                    _type   => 'template',
                    type    => $type,
                    blog_id => $website->id,
                    name    => "Update Template $type, no. $cnt",
                    id      => $tmpl->id,
                });
                $cnt++;

                if ($data->{ok}) {
                    $app->has_no_permission_error("Save (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("Save (type=$type) by " . $data->{perm});
                }
            }
        };

        subtest "mode = preview_template (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Preview Template ' . $type,
                type    => $type,
            );

            if ($type eq 'archive') {
                my $map = MT::TemplateMap->new;
                $map->set_values({
                    blog_id       => $tmpl->blog_id,
                    template_id   => $tmpl->id,
                    archive_type  => 'Monthly',
                    file_template => '<$MTArchiveDate format="%Y/%m/index.html"$>',
                    is_preffered  => 1,
                });
                $map->save;
            }

            foreach my $data (@suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->post_ok({
                    __mode  => 'preview_template',
                    _type   => 'template',
                    blog_id => $website->id,
                    id      => $tmpl->id,
                });

                if ($data->{ok}) {
                    $app->has_no_permission_error("Preview (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("Preview (type=$type) by " . $data->{perm});
                }
            }
        };

        subtest "mode = publish_archive_templates (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Publish Template ' . $type,
                type    => $type,
            );

            foreach my $data (@publish_suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});

                # XXX: This test is somewhat broken. Some of the users can only publish and can't edit templates,
                # so the first publishing succeeds but the following listing fails.
                local $app->{max_redirect} = 1;

                $app->post_ok({
                    __mode  => 'publish_archive_templates',
                    _type   => 'template',
                    blog_id => $website->id,
                    id      => $tmpl->id,
                });

                if ($data->{ok}) {
                    $app->has_no_permission_error("Publish (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("Publish (type=$type) by " . $data->{perm});
                }
            }
        };

        subtest "mode = refresh_tmpl_templates (type=$type)" => sub {
            $tmpl = MT::Test::Permission->make_template(
                blog_id => $website->id,
                name    => 'Refresh Template ' . $type,
                type    => $type,
            );

            foreach my $data (@suite) {
                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($data->{user});
                $app->post_ok({
                    __mode                 => 'itemset_action',
                    _type                  => 'template',
                    action_name            => 'refresh_tmpl_templates',
                    itemset_action_input   => '',
                    return_args            => '__mode%3Dlist_template%26blog_id%3D' . $website->id,
                    id                     => $tmpl->id,
                    blog_id                => $website->id,
                    plugin_action_selector => 'refresh_tmpl_templates',
                });

                if ($data->{ok}) {
                    $app->has_no_permission_error("Refresh (type=$type) by " . $data->{perm});
                } else {
                    $app->has_permission_error("Refresh (type=$type) by " . $data->{perm});
                }
            }
        };
    }
};

subtest 'mode = save_template_prefs' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $blog->id,
        syntax_highlight => 'sync',
    });
    $app->has_no_permission_error("save_template_prefs by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $blog->id,
        syntax_highlight => 'sync',
    });
    $app->has_no_permission_error("save_template_prefs by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $blog->id,
        syntax_highlight => 'sync',
    });
    $app->has_no_permission_error("save_template_prefs by permitted user (sys)");

    $app->login($ukawa);
    $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $blog->id,
        syntax_highlight => 'sync',
    });
    $app->has_permission_error("save_template_prefs by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $blog->id,
        syntax_highlight => 'sync',
    });
    $app->has_permission_error("save_template_prefs by other permission");
};

done_testing();
