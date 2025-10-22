#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/MyWebsiteTheme/theme.yaml', <<'YAML');
id: my_website_theme
name: my_website_theme
label: My Website Theme
class: website
thumbnail: my_thumbnail.png
elements:
    template_set:
        component: core
        importer: template_set
        label: Template set
        require: 1
        data:
            label: MyTheme
            base_path: t/theme_templates
            templates:
                index:
                    main_index:
                        label: Main Index
                        outfile: index.html
                        rebuild_me: 1
    core_configs:
        component: core
        importer: default_prefs
        label: core configs
        require: 0
        data:
            allow_comment_html: 0
            allow_pings: 0
    default_categories:
        component: core
        importer: default_categories
        require: 1
        data:
            foo:
                label: another_foo
            xxx:
                label: moge
                description: category description.
                children:
                    yyy:
                        label: foobar
                        description: some other category.
YAML

    $test_env->save_file('themes/MyBlogTheme/theme.yaml', <<'YAML');
id: my_blog_theme
name: my_blog_theme
label: My Blog Theme
class: blog
thumbnail: my_thumbnail.png
elements:
    template_set:
        component: core
        importer: template_set
        label: Template set
        require: 1
        data:
            label: MyTheme
            base_path: t/theme_templates
            templates:
                index:
                    main_index:
                        label: Main Index
                        outfile: index.html
                        rebuild_me: 1
    core_configs:
        component: core
        importer: default_prefs
        label: core configs
        require: 0
        data:
            allow_comment_html: 0
            allow_pings: 0
    default_categories:
        component: core
        importer: default_categories
        require: 1
        data:
            foo:
                label: another_foo
            xxx:
                label: moge
                description: category description.
                children:
                    yyy:
                        label: foobar
                        description: some other category.
YAML

    $test_env->save_file('themes/very_old_theme/theme.yaml', <<'YAML');
id: old_theme
name: OLD Theme
label: Old theme
required_components:
    core: 1.0
optional_components:
    commercial: 2.0
YAML
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::Cms::Common1;
use MT::Test::App;
use MT::Theme;

### Make test data

MT->instance;

$test_env->prepare_fixture('cms/common1');

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });
my $admin   = MT->model('author')->load(1);

my $all_themes           = MT::Theme->load_all_themes;
my %all_available_themes = map { $_ => $all_themes->{$_} }
    grep { !$all_themes->{$_}{deprecated} }
    keys %{$all_themes};

subtest 'Check applying a blog theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $website->id,
        theme_id => 'MyBlogTheme',
    });
    $app->has_no_permission_error;
    ok($app->last_location->query_param('applied'), 'Theme has been applied.');

    $website = MT->model('website')->load($website->id);
    is(
        $website->theme_id, 'MyBlogTheme',
        'Website\'s theme has correct theme_id.'
    );
};

subtest 'Check All Themes screen' => sub {
    subtest 'System' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list_theme',
            blog_id => 0,
        });
        $app->has_no_permission_error;

        my $expected_theme_count = scalar keys %all_available_themes;
        my @titles               = $app->content =~ /theme-title/g;
        is scalar @titles, $expected_theme_count, "${expected_theme_count} themes";

        for my $theme (values %all_available_themes) {
            my $theme_label = $theme->name || $theme->label->();
            $app->content_like(qr/\Q${theme_label}\E/, $theme_label);
        }
    };

    subtest 'Parente Site' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list_theme',
            blog_id => $website->id,
        });
        $app->has_no_permission_error;

        my $expected_theme_count = scalar keys %all_available_themes;
        my @titles               = $app->content =~ /theme-title/g;
        is scalar @titles, $expected_theme_count, "${expected_theme_count} themes";

        for my $theme (values %all_available_themes) {
            my $theme_label = $theme->name || $theme->label->();
            $app->content_like(qr/\Q${theme_label}\E/, $theme_label);
        }
    };

    subtest 'Child Site' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list_theme',
            blog_id => $blog->id,
        });
        $app->has_no_permission_error;

        my (@expected_themes, @unexpected_themes);
        for my $theme (values %all_available_themes) {
            if (($theme->{class} || '') eq 'website') {
                push @unexpected_themes, $theme;
            } else {
                push @expected_themes, $theme;
            }
        }

        my $expected_theme_count = scalar @expected_themes;
        my @titles               = $app->content =~ /theme-title/g;
        is scalar @titles, $expected_theme_count, "${expected_theme_count} themes";

        for my $theme (@expected_themes) {
            my $theme_label = $theme->name || $theme->label->();
            $app->content_like(qr/\Q${theme_label}\E/, $theme_label);
        }

        for my $theme (@unexpected_themes) {
            my $theme_label = $theme->name || $theme->label->();
            $app->content_unlike(qr/\Q${theme_label}\E/, "no ${theme_label}");
        }
    };
};

done_testing;
