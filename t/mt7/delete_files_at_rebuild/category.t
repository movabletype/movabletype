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

my $entry1 = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    author_id => $author->id,
    authored_on => '20180831000000',
);

my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    label           => 'category1',
);

my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    label           => 'category2',
);

my $placement1 = MT::Test::Permission->make_placement(
    blog_id => $blog_id,
    entry_id => $entry1->id,
    category_id => $category1->id,
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    name            => 'Category Test',
    type            => 'categories',
    text            => 'test',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'Category',
    file_template => '%c/%f',
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->save;

require MT::ContentPublisher;
my $publisher = MT::ContentPublisher->new;
$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'Category',
    TemplateMap => $template_map,
);

my $archive = File::Spec->catfile( $test_env->root,
    "site/archive/category1/index.html" );
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

$placement1->category_id($category2->id); $placement1->save or die $placement1->error;

$app->request->reset;
$publisher->start_time(time + 1); # to avoid early return due to mod_time
$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'Category',
    TemplateMap => $template_map,
);

ok !-e $archive;

my $updated_archive = File::Spec->catfile( $test_env->root,
    "site/archive/category2/index.html" );
ok -e $updated_archive;

my @updated_finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @updated_finfos => 1, "only one FileInfo";

require File::Find;
File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

my $entry2 = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    author_id => $author->id,
    authored_on => '20181031000000',
);

my $placement2 = MT::Test::Permission->make_placement(
    blog_id => $blog_id,
    entry_id => $entry2->id,
    category_id => $category2->id,
);

$app->request->reset;
$publisher->start_time(time + 1);
$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'Category',
    TemplateMap => $template_map,
);

ok !-e $archive;
ok -e $updated_archive;

my @new_finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @new_finfos => 1, "two FileInfo";

File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

done_testing;
