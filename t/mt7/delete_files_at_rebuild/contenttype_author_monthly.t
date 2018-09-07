#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete => 1,
    );
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
my $author_basename = $author->basename;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);

my $cf_category = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'categories',
    type            => 'categories',
);

my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'datetime',
    type            => 'date_and_time',
);

my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'test category set',
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
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
    author_id       => $author->id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id => [ $category1->id ],
        $cf_datetime->id => '20180831000000',
    },
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'ContentType Test',
    type            => 'ct',
    text            => 'test',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'ContentType-Author-Monthly',
    file_template => '%a/%y/%m/%f',
    cat_field_id  => $cf_category->id,
    dt_field_id   => $cf_datetime->id,
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->save;

require MT::ContentPublisher;
my $publisher = MT::ContentPublisher->new;
$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'ContentType-Author-Monthly',
    TemplateMap => $template_map,
);

my $archive = File::Spec->catfile( $test_env->root,
    "site/archive/$author_basename/2018/08/index.html" );
ok -e $archive;

my @finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @finfos => 1, "only one FileInfo";

require File::Find;
File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

$cd->data(
    {   $cf_category->id => [ $category1->id ],
        $cf_datetime->id => '20181031000000',
    },
);
$cd->save or die $cd->error;

$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'ContentType-Author-Monthly',
    TemplateMap => $template_map,
);

ok !-e $archive;

my $updated_archive = File::Spec->catfile( $test_env->root,
    "site/archive/$author_basename/2018/10/index.html" );
ok -e $updated_archive;

my @updated_finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @updated_finfos => 1, "only one FileInfo";

File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    author_id       => $author->id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id => [ $category1->id ],
        $cf_datetime->id => '20181231000000',
    },
);

$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'ContentType-Author-Monthly',
    TemplateMap => $template_map,
);

ok !-e $archive;
ok -e $updated_archive;

my $new_archive = File::Spec->catfile( $test_env->root,
    "site/archive/$author_basename/2018/12/index.html" );
ok -e $new_archive;

my @new_finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @new_finfos => 2, "two FileInfo";

File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

done_testing;
