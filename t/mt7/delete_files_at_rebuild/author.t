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

my $entry1 = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    author_id => $author->id,
    authored_on => '20180831000000',
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    name            => 'Author Test',
    type            => 'author',
    text            => 'test',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'Author',
    file_template => '%a/%f',
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
    ArchiveType => 'Author',
    TemplateMap => $template_map,
);

my $archive = File::Spec->catfile( $test_env->root,
    "site/archive/$author_basename/index.html" );
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

my $entry2 = MT::Test::Permission->make_entry(
    blog_id => $blog_id,
    author_id => $author->id,
    authored_on => '20181031000000',
);

$publisher->rebuild(
    BlogID      => $blog_id,
    Author      => $author->id,
    ArchiveType => 'Author',
    TemplateMap => $template_map,
);

ok -e $archive, "old archive should be kept";

my @new_finfos = MT::FileInfo->load({ blog_id => $blog_id });
is @new_finfos => 1, "only one FileInfo";

File::Find::find(
    {   wanted => sub {
            note $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

done_testing;
