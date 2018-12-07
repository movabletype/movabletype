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


=== mt:ArchiveTypeLabel de
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26093
--- skip_php
1
--- language 
de
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
Autorenarchiv
--- expected_author_daily
tägliches Autorenarchiv
--- expected_author_monthly
monatliches Autorenarchiv
--- expected_author_weekly
wöchentliches Autorenarchiv
--- expected_author_yearly
jährliches Autorenarchiv
--- expected_category
Kategoriearchiv
--- expected_category_daily
tägliches Kategoriearchiv
--- expected_category_monthly
monatliches Kategoriearchiv
--- expected_category_weekly
wöchentliches Kategoriearchiv
--- expected_category_yearly
jährliches Kategoriearchiv
--- expected_contenttype
Inhaltstyparchiv
--- expected_contenttype_author
Inhaltstyparchiv nach Autor
--- expected_contenttype_author_daily
tägliches Inhaltstyparchiv nach Autor
--- expected_contenttype_author_monthly
monatliches Inhaltstyparchiv nach Autor
--- expected_contenttype_author_weekly
wöchentliches Inhaltstyparchiv nach Autor
--- expected_contenttype_author_yearly
jährliches Inhaltstyparchiv nach Autor
--- expected_contenttype_category
Inhaltstyparchiv nach Kategorie
--- expected_contenttype_category_daily
tägliches Inhaltstyparchiv nach Kategorie
--- expected_contenttype_category_monthly
monatliches Inhaltstyparchiv nach Kategorie
--- expected_contenttype_category_weekly
wöchentliches Inhaltstyparchiv nach Kategorie
--- expected_contenttype_category_yearly
jährliches Inhaltstyparchiv nach Kategorie
--- expected_contenttype_daily
tägliches Inhaltstyparchiv
--- expected_contenttype_monthly
monatliches Inhaltstyparchiv
--- expected_contenttype_weekly
wöchentliches Inhaltstyparchiv
--- expected_contenttype_yearly
jährliches Inhaltstyparchiv
--- expected_daily
Tagesarchiv
--- expected_individual
Einzelarchiv
--- expected_monthly
Monatsarchiv
--- expected_page
Seitenarchiv
--- expected_weekly
Wochenarchiv
--- expected_yearly
Jahresarchiv


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


=== mt:ArchiveTypeLabel es
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26093
--- language 
es
--- skip_php
1
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
por autor
--- expected_author_daily
por día y autor
--- expected_author_monthly
por mes y autor
--- expected_author_weekly
por semana y autor
--- expected_author_yearly
por año y autor
--- expected_category
por categoría
--- expected_category_daily
por día y categoría
--- expected_category_monthly
por mes y categoría
--- expected_category_weekly
por semana y categoría
--- expected_category_yearly
por año y categoría
--- expected_contenttype
ContentType
--- expected_contenttype_author
ContentType autor
--- expected_contenttype_author_daily
ContentType autor diario
--- expected_contenttype_author_monthly
ContentType autor mensual
--- expected_contenttype_author_weekly
ContentType autor semanal
--- expected_contenttype_author_yearly
ContenType autor anual
--- expected_contenttype_category
ContentType categoría
--- expected_contenttype_category_daily
ContentType categoría diario
--- expected_contenttype_category_monthly
ContentType categoría mensual
--- expected_contenttype_category_weekly
ContentType categoría semanal
--- expected_contenttype_category_yearly
ContentType categoría anual
--- expected_contenttype_daily
ContentType diario
--- expected_contenttype_monthly
ContenType mensual
--- expected_contenttype_weekly
ContentType semanal
--- expected_contenttype_yearly
ContentType anual
--- expected_daily
diarios
--- expected_individual
por entrada
--- expected_monthly
mensuales
--- expected_page
por página
--- expected_weekly
semanales
--- expected_yearly
anuales


=== mt:ArchiveTypeLabel fr
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26093
--- language 
fr
--- skip_php
1
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
par auteurs
--- expected_author_daily
par auteurs et jours
--- expected_author_monthly
par auteurs et semaines
--- expected_author_weekly
par auteurs et années
--- expected_author_yearly
par auteurs et années
--- expected_category
par catégories
--- expected_category_daily
par catégories et jours
--- expected_category_monthly
par catégories et mois
--- expected_category_weekly
par catégories et semaines
--- expected_category_yearly
par catégories et années
--- expected_contenttype
ContentType
--- expected_contenttype_author
ContentType Auteur
--- expected_contenttype_author_daily
ContentType Auteur journalières
--- expected_contenttype_author_monthly
ContentType Auteur mensuelles
--- expected_contenttype_author_weekly
ContentType Auteur hebdomadaires
--- expected_contenttype_author_yearly
ContentType Auteur annuelles
--- expected_contenttype_category
ContentType Catégorie
--- expected_contenttype_category_daily
ContentType Catégorie journalières
--- expected_contenttype_category_monthly
ContentType Catégorie mensuelles
--- expected_contenttype_category_weekly
ContentType Catégorie hebdomadaires
--- expected_contenttype_category_yearly
ContentType Catégorie annuelles
--- expected_contenttype_daily
ContentType journalières
--- expected_contenttype_monthly
ContentType mensuelles
--- expected_contenttype_weekly
ContentType hebdomadaires
--- expected_contenttype_yearly
ContentType annuelles
--- expected_daily
journalières
--- expected_individual
par notes
--- expected_monthly
mensuelles
--- expected_page
par pages
--- expected_weekly
hebdomadaires
--- expected_yearly
annuelles


=== mt:ArchiveTypeLabel nl
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26093
--- language 
nl
--- skip_php
1
--- stash
{ cd => 'cd_same_apple_orange', cat_field => 'cf_same_catset_fruit', category => 'cat_apple' }
--- template
<mt:Archives type="[% archive_type %]"><mt:ArchiveTypeLabel></mt:Archives>
--- expected_author
per auteur
--- expected_author_daily
per auteur per dag
--- expected_author_monthly
per auteur per maand
--- expected_author_weekly
per auteur per week
--- expected_author_yearly
per auteur per jaar
--- expected_category
per categorie
--- expected_category_daily
per categorie per dag
--- expected_category_monthly
per categorie per maand
--- expected_category_weekly
per categorie per week
--- expected_category_yearly
per categorie per jaar
--- expected_contenttype
InhoudsType
--- expected_contenttype_author
InhoudsType Auteur
--- expected_contenttype_author_daily
InhoudsType Auteur per dag
--- expected_contenttype_author_monthly
InhoudsType Auteur per maand
--- expected_contenttype_author_weekly
InhoudsType Auteur per week
--- expected_contenttype_author_yearly
InhoudsType Auteur per jaar
--- expected_contenttype_category
InhoudsType Categorie
--- expected_contenttype_category_daily
InhoudsType Categorie per dag
--- expected_contenttype_category_monthly
InhoudsType Categorie per maand
--- expected_contenttype_category_weekly
InhoudsType Categorie per week
--- expected_contenttype_category_yearly
InhoudsType Categorie per jaar
--- expected_contenttype_daily
InhoudsType per dag
--- expected_contenttype_monthly
InhoudsType per maand
--- expected_contenttype_weekly
InhoudsType per week
--- expected_contenttype_yearly
InhoudsType per jaar
--- expected_daily
per dag
--- expected_individual
per bericht
--- expected_monthly
per maand
--- expected_page
per pagina
--- expected_weekly
per week
--- expected_yearly
per jaar


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

