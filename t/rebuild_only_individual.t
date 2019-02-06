#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test qw( :app :db :data );
use MT::Test::Permission;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

my $author = MT::Test::Permission->make_author(
    name     => 'author',
    nickname => 'author',
);

my $entry1 = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    author_id   => $author->id,
    authored_on => '20180829000000',
    title       => 'entry1',
);

my $entry2 = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    author_id   => $author->id,
    authored_on => '20180830000000',
    title       => 'entry2',
);

my $entry3 = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    author_id   => $author->id,
    authored_on => '20180831000000',
    title       => 'entry3',
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id => $blog_id,
    name    => 'Category Test',
    type    => 'categories',
    text =>
        '<MTEntryNext><MTEntryID></MTEntryNext><MTEntryPrevious><MTEntryID></MTEntryPrevious>',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'Individual',
    file_template => '%y/%m/%f',
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->archive_type('Individual');
$blog->save;

require MT::WeblogPublisher;
my $publisher = MT::WeblogPublisher->new;
$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'Individual',
    TemplateMap => $template_map,
);

sleep 1;

my $fmgr = MT::FileMgr->new('Local');

my $filename1 = $entry1->title;
my $archive1  = File::Spec->catfile( $test_env->root,
    "site/archive/2018/08/$filename1.html" );
ok -e $archive1;
is $fmgr->get_data($archive1) => '2', 'output1';

my $filename2 = $entry2->title;
my $archive2  = File::Spec->catfile( $test_env->root,
    "site/archive/2018/08/$filename2.html" );
ok -e $archive2;
is $fmgr->get_data($archive2) => '31', 'output2';

my $filename3 = $entry3->title;
my $archive3  = File::Spec->catfile( $test_env->root,
    "site/archive/2018/08/$filename3.html" );
ok -e $archive3;
is $fmgr->get_data($archive3) => '2', 'output3';

my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
is @finfos => 3, "three FileInfo";

my $app = _run_app(
    'MT::App::CMS',
    {   __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'delete_entry',
        blog_id          => $blog_id,
        id               => $entry2->id,
    }
);
my $out = delete $app->{__test_output};
ok( $out,                     "Request: delete_entry" );
ok( $out !~ m!permission=1!i, "delete_entry by admin" );

@finfos = MT::FileInfo->load( { blog_id => $blog_id } );
is @finfos => 2, "two FileInfo";

ok -e $archive1;
ok !-e $archive2;
ok -e $archive3;
is $fmgr->get_data($archive1) => '3', 'output1';
is $fmgr->get_data($archive3) => '1', 'output3';

done_testing;
