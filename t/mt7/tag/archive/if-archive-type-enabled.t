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

=== mt:IfArchiveTypeEnabled without content_type (always error)
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
--- expected_error
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.

=== mt:IfArchiveTypeEnabled without content_type (contenttype_* is error)
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
<mt:IfArchiveTypeEnabled archive_type="[% archive_type %]">true</mt:IfArchiveTypeEnabled>
--- expected
[% expected %]
--- expected_error_contenttype
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_author
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_author
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_author_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_author_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_author_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_author_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_author_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_author_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_author_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_author_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_category
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_category
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_category_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_category_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_category_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_category_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_category_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_category_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_category_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_category_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_daily
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_monthly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_weekly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_error_contenttype_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.
--- expected_php_error_contenttype_yearly
You used an <MTIfArchiveTypeEnabled> tag without a valid content_type attribute.

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
<mt:IfArchiveTypeEnabled archive_type="ContentType" content_type="ct_null">true<mt:Else>false</mt:IfArchiveTypeEnabled>
--- expected
false
