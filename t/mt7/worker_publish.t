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

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $author = MT::Test::Permission->make_author(
    name => 'author',
    nickname => 'author',
);

my $entry = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    author_id => $author->id,
    authored_on => '20180906000000',
);

my $category = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    label           => 'category',
);

my $placement1 = MT::Test::Permission->make_placement(
    blog_id => $blog_id,
    entry_id => $entry->id,
    category_id => $category->id,
);

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);

my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'test category set',
);
my $category_for_set = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category for set',
);

my $cf_category = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);

my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'datetime',
    type            => 'date_and_time',
);

$ct->fields(
    [   {   id        => $cf_category->id,
            label     => 1,
            name      => $cf_category->name,
            order     => 1,
            type      => $cf_category->type,
            unique_id => $cf_category->unique_id,
        },
        {   id        => $cf_datetime->id,
            label     => 1,
            name      => $cf_datetime->name,
            order     => 1,
            type      => $cf_datetime->type,
            unique_id => $cf_datetime->unique_id,
        },
    ]
);
$ct->save or die $ct->error;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id => [ $category_for_set->id ],
        $cf_datetime->id => '20180831000000',
    },
);
my $unique_id = $cd->unique_id;

# Mapping
my $template_author = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    name            => 'Author Test',
    type            => 'author',
    text            => 'test',
);
my $template_map_author = MT::Test::Permission->make_templatemap(
    template_id   => $template_author->id,
    blog_id       => $blog_id,
    archive_type  => 'Author',
    file_template => '%a/%f',
    is_preferred  => 1,
);

my $template_category = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    name            => 'Category Test',
    type            => 'categories',
    text            => 'test',
);
my $template_map_category = MT::Test::Permission->make_templatemap(
    template_id   => $template_category->id,
    blog_id       => $blog_id,
    archive_type  => 'Category-Monthly',
    file_template => '%c/%y/%m/%f',
    is_preferred  => 1,
);

my $template_ct = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'ContentType Test',
    type            => 'ct',
    text            => 'test',
);
my $template_map_ct = MT::Test::Permission->make_templatemap(
    template_id   => $template_ct->id,
    blog_id       => $blog_id,
    archive_type  => 'ContentType',
    file_template => '%c/%y/%m/%f',
    cat_field_id  => $cf_category->id,
    dt_field_id   => $cf_datetime->id,
    is_preferred  => 1,
);

my $site_root = File::Spec->catdir( $test_env->root, "site" );
my $archive_root = File::Spec->catdir( $site_root, "archive" );
my $blog = MT::Blog->load($blog_id);
$blog->site_path($site_root);
$blog->archive_path($archive_root);
$blog->save;

# create FileInfo entries
require MT::ContentPublisher;
my $publisher = MT::ContentPublisher->new;
$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'Author',
    TemplateMap => $template_map_author,
);

$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'Category-Monthly',
    TemplateMap => $template_map_category,
);

$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'ContentType',
    TemplateMap => $template_map_ct,
);

ok -e File::Spec->catfile( $archive_root, "author/index.html" ), "author index exists";
ok -e File::Spec->catfile( $archive_root, "category/2018/09/index.html" ), "category-monthly index exists";
ok -e File::Spec->catfile( $archive_root, "category_for_set/2018/08/$unique_id.html" ), "contenttype index exists";

require File::Find;
File::Find::find({ wanted => sub { note $File::Find::name }, no_chdir => 1 }, $archive_root);

require File::Path;
File::Path::remove_tree($archive_root);
File::Path::mkpath($archive_root);

note "normal rebuild";
MT->request->reset;
$publisher->start_time( time + 1 );
$publisher->rebuild(
    BlogID => $blog_id,
    Force => 1,
);

ok -e File::Spec->catfile( $archive_root, "author/index.html" ), "author index exists";
ok -e File::Spec->catfile( $archive_root, "category/2018/09/index.html" ), "category-monthly index exists";
ok -e File::Spec->catfile( $archive_root, "category_for_set/2018/08/$unique_id.html" ), "contenttype index exists";

File::Find::find({ wanted => sub { note $File::Find::name }, no_chdir => 1 }, $archive_root);

require File::Path;
File::Path::remove_tree($archive_root);
File::Path::mkpath($archive_root);

note "aysnc rebuild";

for my $map ( MT::Template->load, MT::TemplateMap->load ) {
    $map->build_type(MT::PublishOption::ASYNC());
    $map->save;
}

MT->request->reset;
$publisher->start_time( time + 1 );
$publisher->rebuild(
    BlogID => $blog_id,
);

my @jobs = MT::TheSchwartz::Job->load;
is @jobs => 3;

note "process queue";
_run_rpt();

ok -e File::Spec->catfile( $archive_root, "author/index.html" ), "author index exists";
ok -e File::Spec->catfile( $archive_root, "category/2018/09/index.html" ), "category-monthly index exists";
ok -e File::Spec->catfile( $archive_root, "category_for_set/2018/08/$unique_id.html" ), "contenttype index exists";

File::Find::find({ wanted => sub { note $File::Find::name }, no_chdir => 1 }, $archive_root);

done_testing;
