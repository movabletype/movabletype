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
use YAML::Tiny;

### Make test data

## building test themes.
my $data;
{
    local $/ = undef;
    $data = ( YAML::Tiny::Load(<DATA>) )[0];
}
MT->instance;
MT->component('core')->registry->{themes} = $data;

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );

# Author
my $admin = MT->model('author')->load(1);

# Run tests
subtest 'Check visibility' => sub {
    plan 'skip_all';

    my @suite = (
        {   scope   => 'System',
            blog_id => 0,
            like    => [ 'Themes in Use', 'Available Themes', ],
        },
        {   scope   => 'Website',
            blog_id => $website->id,
            like    => [ 'Current Theme', 'Available Themes', ],
        },
        {   scope   => 'Blog',
            blog_id => $blog->id,
            like    => [ 'Current Theme', 'Available Themes', ],
        },
    );

    foreach my $data (@suite) {
        subtest 'Scope: ' . $data->{scope} => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $admin,
                    __mode      => 'list_theme',
                    blog_id     => $data->{blog_id},
                },
            );
            my $out = delete $app->{__test_output};

            if ( $data->{like} ) {
                if ( ref( $data->{like} ) && ref( $data->{like} ) eq 'ARRAY' )
                {
                    foreach my $like ( @{ $data->{like} } ) {
                        my $like_quotemeta
                            = quotemeta( '<h2 class="theme-group-name">'
                                . $like
                                . '</h2>' );
                        ok( $out =~ m/$like_quotemeta/, $like );
                    }
                }
                else {
                    my $like = '<h2 class="theme-group-name">'
                        . $data->{like} . '</h2>';
                    my $like_quotemeta = quotemeta $like;
                    ok( $out =~ m/$like_quotemeta/, $like );
                }
            }
        };
    }

};

subtest 'Check applying a blog theme' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'apply_theme',
            blog_id     => $website->id,
            theme_id    => 'MyBlogTheme',
        },
    );
    my $out = delete $app->{__test_output};
    unlike(
        $out,
        qr/(redirect|permission=1)|An error occurr?ed/,
        'Has no error.'
    );
    ok( $out =~ /Status: 302 Found/ && $out =~ /applied=1/,
        'Theme has been applied.' );

    $website = $app->model('website')->load( $website->id );
    is( $website->theme_id, 'MyBlogTheme',
        'Website\'s theme has correct theme_id.' );
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
                          
