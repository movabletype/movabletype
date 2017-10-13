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


use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db);
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

{
    my $b = $mt->model('blog')->new;
    $b->set_values({
        id => 1,
    });
    $b->save or die $b->errstr;
}

{
    my $e = $mt->model('entry')->new;
    $e->set_values({
        blog_id => 1,
        author_id => 1,
        status => MT::Entry::RELEASE,
    });
    $e->tags(qw(@1clm TEST));
    $e->save or die $e->errstr;
}

{
    my $p = $mt->model('page')->new;
    $p->set_values({
        blog_id => 1,
        author_id => 1,
        status => MT::Entry::RELEASE,
    });
    $p->tags(qw(@1clm TEST));
    $p->save or die $p->errstr;
}

{
    my $a = $mt->model('asset')->new;
    $a->set_values({
        blog_id => 1,
        author_id => 1,
    });
    $a->tags(qw(@1clm TEST));
    $a->save or die $a->errstr;
}

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:EntryTags
--- template
<mt:Entries><mt:EntryTags><mt:TagLabel /></mt:EntryTags></mt:Entries>
--- expected
TEST

=== mt:EntryTags with include_private="1"
--- template
<mt:Entries><mt:EntryTags include_private="1" glue=","><mt:TagLabel /></mt:EntryTags></mt:Entries>
--- expected
@1clm,TEST

=== mt:EntryIfTagged called twice
--- template
<mt:Entries><mt:EntryIfTagged></mt:EntryIfTagged><mt:EntryIfTagged tag="@1clm">OK</mt:EntryIfTagged></mt:Entries>
--- expected
OK

=== mt:PageTags
--- template
<mt:Pages><mt:PageTags><mt:TagLabel /></mt:PageTags></mt:Pages>
--- expected
TEST

=== mt:PageTags with include_private="1"
--- template
<mt:Pages><mt:PageTags include_private="1" glue=","><mt:TagLabel /></mt:PageTags></mt:Pages>
--- expected
@1clm,TEST

=== mt:PageIfTagged called twice
--- template
<mt:Pages><mt:PageIfTagged></mt:PageIfTagged><mt:PageIfTagged tag="@1clm">OK</mt:PageIfTagged></mt:Pages>
--- expected
OK

=== mt:AssetTags
--- template
<mt:Assets><mt:AssetTags><mt:TagLabel /></mt:AssetTags></mt:Assets>
--- expected
TEST

=== mt:AssetTags with include_private="1"
--- template
<mt:Assets><mt:AssetTags include_private="1" glue=","><mt:TagLabel /></mt:AssetTags></mt:Assets>
--- expected
@1clm,TEST

=== mt:AssetIfTagged called twice
--- template
<mt:Assets><mt:AssetIfTagged></mt:AssetIfTagged><mt:AssetIfTagged tag="@1clm">OK</mt:AssetIfTagged></mt:Assets>
--- expected
OK

