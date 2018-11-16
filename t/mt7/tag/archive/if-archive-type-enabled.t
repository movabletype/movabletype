#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my @maps = MT::Test::ArchiveType->template_maps;

MT::Test::ArchiveType->vars->{expected}      = 'true';
MT::Test::ArchiveType->vars->{expected_else} = 'true';

MT::Test::ArchiveType->run_tests(@maps);

my $site = MT::Website->load( { name => 'site_for_archive_test' } );
$site->archive_type('None');
$site->save;

for my $map (@maps) {
    $map->blog_id(9999);
    $map->save;
}

MT::Test::ArchiveType->vars->{expected}      = '';
MT::Test::ArchiveType->vars->{expected_else} = 'false';

MT::Test::ArchiveType->run_tests(@maps);

done_testing;

__END__

=== mt:IfArchiveTypeEnabled with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26062 (same for all the following tests)
--- stash
{
    cd => 'cd_same_apple_orange',
    category => 'cat_apple',
    cat_field => 'cf_same_catset_fruit',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:IfArchiveTypeEnabled type="[% archive_type %]" content_type="ct_with_same_catset">true</mt:IfArchiveTypeEnabled>
--- expected
[% expected %]
--- expected_php_todo_author
--- expected_php_todo_author_daily
--- expected_php_todo_author_monthly
--- expected_php_todo_author_weekly
--- expected_php_todo_author_yearly
--- expected_php_todo_category
--- expected_php_todo_category_daily
--- expected_php_todo_category_monthly
--- expected_php_todo_category_weekly
--- expected_php_todo_category_yearly
--- expected_php_todo_daily
--- expected_php_todo_individual
--- expected_php_todo_monthly
--- expected_php_todo_page
--- expected_php_todo_weekly
--- expected_php_todo_yearly

=== mt:IfArchiveTypeEnabled with archive_type
--- stash
{
    cd => 'cd_same_apple_orange',
    category => 'cat_apple',
    cat_field => 'cf_same_catset_fruit',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:IfArchiveTypeEnabled archive_type="[% archive_type %]" content_type="ct_with_same_catset">true</mt:IfArchiveTypeEnabled>
--- expected
[% expected %]
--- expected_php_todo_author
--- expected_php_todo_author_daily
--- expected_php_todo_author_monthly
--- expected_php_todo_author_weekly
--- expected_php_todo_author_yearly
--- expected_php_todo_category
--- expected_php_todo_category_daily
--- expected_php_todo_category_monthly
--- expected_php_todo_category_weekly
--- expected_php_todo_category_yearly
--- expected_php_todo_daily
--- expected_php_todo_individual
--- expected_php_todo_monthly
--- expected_php_todo_page
--- expected_php_todo_weekly
--- expected_php_todo_yearly

=== mt:IfArchiveTypeEnabled with else
--- stash
{
    cd => 'cd_same_apple_orange',
    category => 'cat_apple',
    cat_field => 'cf_same_catset_fruit',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:IfArchiveTypeEnabled archive_type="ContentType" content_type="ct_with_same_catset">true<mt:Else>false</mt:IfArchiveTypeEnabled>
--- expected
[% expected_else %]

=== mt:IfArchiveTypeEnabled without content_type (always false... or error?)
--- stash
{
    cd => 'cd_same_apple_orange',
    category => 'cat_apple',
    cat_field => 'cf_same_catset_fruit',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:IfArchiveTypeEnabled archive_type="ContentType">true<mt:Else>false</mt:IfArchiveTypeEnabled>
--- expected_todo
false

=== mt:IfArchiveTypeEnabled with an inconsistent content type
--- stash
{
    cd => 'cd_same_apple_orange',
    category => 'cat_apple',
    cat_field => 'cf_same_catset_fruit',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:IfArchiveTypeEnabled archive_type="ContentType" content_type="ct_with_other_catset">true<mt:Else>false</mt:IfArchiveTypeEnabled>
--- expected_todo
false
