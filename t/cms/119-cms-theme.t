#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::Cms::Common1;
use YAML::Tiny;
use MT::Test::App;

### Make test data

## building test themes.
my $data;
{
    local $/ = undef;
    $data = (YAML::Tiny::Load(<DATA>))[0];
}
MT->instance;
MT->component('core')->registry->{themes} = $data;

$test_env->prepare_fixture('cms/common1');

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });
my $admin   = MT->model('author')->load(1);

# Run tests
subtest 'Check visibility' => sub {
    plan 'skip_all';

    my @suite = ({
            scope   => 'System',
            blog_id => 0,
            like    => ['Themes in Use', 'Available Themes',],
        },
        {
            scope   => 'Website',
            blog_id => $website->id,
            like    => ['Current Theme', 'Available Themes',],
        },
        {
            scope   => 'Blog',
            blog_id => $blog->id,
            like    => ['Current Theme', 'Available Themes',],
        },
    );

    foreach my $data (@suite) {
        subtest 'Scope: ' . $data->{scope} => sub {
            my $app = MT::Test::App->new('MT::App::CMS');
            $app->login($admin);
            $app->get_ok({
                __mode  => 'list_theme',
                blog_id => $data->{blog_id},
            });

            if ($data->{like}) {
                if (ref($data->{like}) && ref($data->{like}) eq 'ARRAY') {
                    foreach my $like (@{ $data->{like} }) {
                        my $like_quotemeta = quotemeta('<h2 class="theme-group-name">' . $like . '</h2>');
                        $app->content_like(qr/$like_quotemeta/, $like);
                    }
                } else {
                    my $like           = '<h2 class="theme-group-name">' . $data->{like} . '</h2>';
                    my $like_quotemeta = quotemeta $like;
                    $app->content_like(qr/$like_quotemeta/, $like);
                }
            }
        };
    }

};

subtest 'Check applying a blog theme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode   => 'apply_theme',
        blog_id  => $website->id,
        theme_id => 'MyBlogTheme',
    });
    $app->content_unlike(
        qr/(redirect|permission=1)|An error occurr?ed/,
        'Has no error.'
    );
    ok($app->last_location->query_param('applied'), 'Theme has been applied.');

    $website = MT->model('website')->load($website->id);
    is(
        $website->theme_id, 'MyBlogTheme',
        'Website\'s theme has correct theme_id.'
    );
};

done_testing;

__DATA__
MyWebsiteTheme:
    id: my_website_theme
    name: my_website_theme
    label: My Website Theme
    class: website
    thumbnail: my_thumbnail.png
    elements:
        template_sGet:
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
MyBlogTheme:
    id: my_blog_theme
    name: my_blog_theme
    label: My Blog Theme
    class: blog
    thumbnail: my_thumbnail.png
    elements:
        template_sGet:
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
very_old_theme:
    id: old_theme
    name: OLD Theme
    label: Old theme
    required_components:
        core: 1.0
    optional_components:
        commercial: 2.0
