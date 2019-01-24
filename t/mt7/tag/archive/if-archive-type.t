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

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:IfArchiveType with type
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}

--- template
<mt:IfArchiveType type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveType></mt:IfArchiveType>
--- expected
[% archive_type %]

=== mt:IfArchiveType with archive_type
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}
--- template
<mt:IfArchiveType archive_type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveType></mt:IfArchiveType>
--- expected
[% archive_type %]

=== mt:IfArchiveType with else
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}
--- template
<mt:IfArchiveType archive_type="ContentType" content_type="ct_with_same_catset">true<mt:Else>false</mt:IfArchiveType>
--- expected
false
--- expected_contenttype
true

=== mt:IfArchiveType archive_type="ContentType" without content_type (always false or error)
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}
--- template
<mt:IfArchiveType archive_type="ContentType">true<mt:Else>false</mt:IfArchiveType>
--- expected
false
--- expected_error_contenttype
You used an <MTIfArchiveType> tag without a valid content_type attribute.
--- expected_php_error_contenttype
You used an <MTIfArchiveType> tag without a valid content_type attribute.

=== mt:IfArchiveType archive_type="ContentType-Daily" without content_type (always false or error)
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}
--- template
<mt:IfArchiveType archive_type="ContentType-Daily">true<mt:Else>false</mt:IfArchiveType>
--- expected
false
--- expected_error_contenttype_daily
You used an <MTIfArchiveType> tag without a valid content_type attribute.
--- expected_php_error_contenttype_daily
You used an <MTIfArchiveType> tag without a valid content_type attribute.

=== mt:IfArchiveType with an inconsistent content type
--- stash
{   cd             => 'cd_same_apple_orange',
    category       => 'cat_apple',
    cat_field      => 'cf_same_catset_fruit',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee'
}
--- template
<mt:IfArchiveType archive_type="ContentType" content_type="ct_with_other_catset">true<mt:Else>false</mt:IfArchiveType>
--- expected
false
