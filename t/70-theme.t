#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT::Test qw(:app :db :data);
use Test::More qw( no_plan );
use YAML::Tiny;
use File::Spec;
use FindBin qw( $Bin );
use MT;

my $mt = MT->instance;
$mt->user( MT::Author->load(1) );
$mt->config->ThemesDirectory('t/themes');
use_ok( 'MT::Theme', 'use MT::Theme' );

## building test themes.
my $data;
{
    local $/ = undef;
    $data = ( YAML::Tiny::Load(<DATA>) )[0];
}
$mt->component('core')->registry->{themes} = $data;

## create theme instance.
my $theme;
ok( $theme = MT::Theme->load('MyTheme'), 'Load theme instance' );
my $blog;
ok( $blog = MT->model('blog')->load(1) );

my ( $errors, $warnings ) = $theme->validate_versions;
ok( !scalar @$errors );
ok( !scalar @$warnings );

is( $blog->allow_comment_html, 1 );
is( $blog->allow_pings,        1 );

## apply!!
ok( $theme->apply($blog), 'apply theme' );

## prefs was changed by theme.
is( $blog->allow_comment_html, 0 );
is( $blog->allow_pings,        0 );

## only applied template set has this.
my $main_index;
ok( $main_index = MT->model('template')
        ->load( { blog_id => $blog->id, identifier => 'main_index' } ) );
is( $main_index->text, "I am MT\nI am MT", 'loaded template' );

## and backuped templates exists.
ok( MT->model('template')->load( { blog_id => $blog->id, type => 'backup' } )
);

subtest 'default_category_sets element' => sub {
    my $category_set = MT->model('category_set')
        ->load( { blog_id => $blog->id, name => 'test_category_set' } );
    ok($category_set);
    is( MT->model('category')->count(
            { blog_id => $blog->id, category_set_id => $category_set->id }
        ),
        3
    );
    my $category_a = MT->model('category')->load(
        {   blog_id         => $blog->id,
            category_set_id => $category_set->id,
            label           => 'a'
        }
    );
    my $category_b = MT->model('category')->load(
        {   blog_id         => $blog->id,
            category_set_id => $category_set->id,
            label           => 'b'
        }
    );
    ok($category_a);
    ok($category_b);
    is( $category_a->parent, $category_b->id );
    ok( MT->model('category')->exist(
            {   blog_id         => $blog->id,
                category_set_id => $category_set->id,
                label           => 'c'
            }
        )
    );
};

## ============================ Tests for loading theme package
## create second theme instance.
my $theme2;
ok( $theme2 = MT::Theme->_load_from_themes_directory('other_theme'),
    'Load from themes directory' );
is( File::Spec->rel2abs( $theme2->path ),
    File::Spec->catdir( $Bin, 'themes/other_theme' ) );
$theme2->apply($blog);
my $atom = MT->model('template')->load(
    {   blog_id => $blog->id,
        type    => 'index',
        name    => 'Atom',
    }
);
is( $atom->text, 'ATOMTEMPLATE BODY FOR TEST' );

__DATA__
MyTheme:
    id: my_theme
    name: my_theme
    label: My Theme
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
        default_category_sets:
            component: core
            importer: default_category_sets
            data:
                test_category_set:
                    name: test_category_set
                    categories:
                        b:
                            label: b
                            children:
                                a:
                                    label: a
                        c:
                            label: c
very_old_theme:
    id: old_theme
    name: OLD Theme
    label: Old theme
    required_components:
        core: 1.0
    optional_components:
        commercial: 2.0
