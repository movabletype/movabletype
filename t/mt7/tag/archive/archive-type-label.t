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
use MT::Test::Fixture::ArchiveType;

use MT;
use MT::Test;
use MT::Test::Tag;

my $app = MT->instance;

filters {
    MT::Test::ArchiveType->filter_spec
};

$test_env->prepare_fixture('db');

my $default_language = MT->config->DefaultLanguage;

my $blog_id = 1;

for my $archive_type ( MT->publisher->archive_types ) {

    # Run Perl Tests
    MT::Test::Tag->run_perl_tests(
        $blog_id,
        sub {
            my ( $ctx, $block, $tmpl ) = @_;
            my $site = MT::Blog->load($blog_id);
            $site->language(
                defined $block->language
                ? $block->language
                : $default_language
            );
            $site->archive_type($archive_type);
            $ctx->stash('blog', $site);
        },
        $archive_type
    );

    # Run PHP Tests
    MT::Test::Tag->run_php_tests(
        $blog_id,
        sub {
            my ($block) = @_;
            my $language
                = defined $block->language
                ? $block->language
                : $default_language;
            my $site = MT::Blog->load($blog_id);
            $site->language($language);
            $site->archive_type($archive_type);
            $site->save();

            return '';
            return <<"PHP";
\$site = \$db->fetch_blog(\$blog_id);
\$site->language = "$language";
\$site->archive_type = "$archive_type";
\$site->save();
PHP
        },
        $archive_type
    );
}

done_testing;

__END__

=== mt:ArchiveTypeLabel en_us
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26093
--- skip_php
1
--- language
en_us
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
Author
--- expected_author_daily
Author Daily
--- expected_author_monthly
Author Monthly
--- expected_author_weekly
Author Weekly
--- expected_author_yearly
Author Yearly
--- expected_category
Category
--- expected_category_daily
Category Daily
--- expected_category_monthly
Category Monthly
--- expected_category_weekly
Category Weekly
--- expected_category_yearly
Category Yearly
--- expected_contenttype
ContentType
--- expected_contenttype_author
ContentType Author
--- expected_contenttype_author_daily
ContentType Author Daily
--- expected_contenttype_author_monthly
ContentType Author Monthly
--- expected_contenttype_author_weekly
ContentType Author Weekly
--- expected_contenttype_author_yearly
ContentType Author Yearly
--- expected_contenttype_category
ContentType Category
--- expected_contenttype_category_daily
ContentType Category Daily
--- expected_contenttype_category_monthly
ContentType Category Monthly
--- expected_contenttype_category_weekly
ContentType Category Weekly
--- expected_contenttype_category_yearly
ContentType Category Yearly
--- expected_contenttype_daily
ContentType Daily
--- expected_contenttype_monthly
ContentType Monthly
--- expected_contenttype_weekly
ContentType Weekly
--- expected_contenttype_yearly
ContentType Yearly
--- expected_daily
Daily
--- expected_individual
Entry
--- expected_monthly
Monthly
--- expected_page
Page
--- expected_weekly
Weekly
--- expected_yearly
Yearly

=== mt:ArchiveTypeLabel ja
--- language 
ja
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
ユーザー
--- expected_author_daily
ユーザー 日別
--- expected_author_monthly
ユーザー 月別
--- expected_author_weekly
ユーザー 週別
--- expected_author_yearly
ユーザー 年別
--- expected_category
カテゴリ
--- expected_category_daily
カテゴリ 日別
--- expected_category_monthly
カテゴリ 月別
--- expected_category_weekly
カテゴリ 週別
--- expected_category_yearly
カテゴリ 年別
--- expected_contenttype
コンテンツタイプ別
--- expected_contenttype_author
コンテンツタイプ ユーザー別
--- expected_contenttype_author_daily
コンテンツタイプ ユーザー 日別
--- expected_contenttype_author_monthly
コンテンツタイプ ユーザー 月別
--- expected_contenttype_author_weekly
コンテンツタイプ ユーザー 週別
--- expected_contenttype_author_yearly
コンテンツタイプ ユーザー 年別
--- expected_contenttype_category
コンテンツタイプ カテゴリ別
--- expected_contenttype_category_daily
コンテンツタイプ カテゴリ 日別
--- expected_contenttype_category_monthly
コンテンツタイプ カテゴリ 月別
--- expected_contenttype_category_weekly
コンテンツタイプ カテゴリ 週別
--- expected_contenttype_category_yearly
コンテンツタイプ カテゴリ 年別
--- expected_contenttype_daily
コンテンツタイプ 日別
--- expected_contenttype_monthly
コンテンツタイプ 月別
--- expected_contenttype_weekly
コンテンツタイプ 週別
--- expected_contenttype_yearly
コンテンツタイプ 年別
--- expected_daily
日別
--- expected_individual
記事
--- expected_monthly
月別
--- expected_page
ウェブページ
--- expected_weekly
週別
--- expected_yearly
年別

