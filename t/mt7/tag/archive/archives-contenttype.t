#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
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

use MT::Test::Tag;

plan tests => 2 * 3 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $archive_types = 'Individual,Page,Daily,Weekly,Monthly,Yearly,Author,Author-Daily,Author-Weekly,Author-Monthly,Author-Yearly,Category,Category-Daily,Category-Weekly,Category-Monthly,Category-Yearly,ContentType,ContentType-Daily,ContentType-Weekly,ContentType-Monthly,ContentType-Yearly,ContentType-Author,ContentType-Author-Daily,ContentType-Author-Weekly,ContentType-Author-Monthly,ContentType-Author-Yearly,ContentType-Category,ContentType-Category-Daily,ContentType-Category-Weekly,ContentType-Category-Monthly,ContentType-Category-Yearly';

my $blog = MT::Blog->load($blog_id);

# Run Perl Tests

$blog->archive_type('');
$blog->save or die $blog->error;

MT::Test::Tag->run_perl_tests($blog_id);

$blog->archive_type('None');
$blog->save or die $blog->error;

MT::Test::Tag->run_perl_tests($blog_id);

$blog->archive_type($archive_types);
$blog->save or die $blog->error;

MT::Test::Tag->run_perl_tests($blog_id);

# Run PHP Tests
#
$blog->archive_type('');
$blog->save or die $blog->error;

MT::Test::Tag->run_php_tests($blog_id);

$blog->archive_type('None');
$blog->save or die $blog->error;

MT::Test::Tag->run_php_tests($blog_id);

$blog->archive_type($archive_types);
$blog->save or die $blog->error;

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== archive_type with ContentType
--- skip
1
--- template
<mt:Archives type="ContentType">
<mt:ArchiveType>
- archive_template: '<mt:var name="template_params" key="archive_template">'
- archive_listing: '<mt:var name="template_params" key="archive_listing">'
- datebased_archive: '<mt:var name="template_params" key="datebased_archive">'
- entry_archive: '<mt:var name="template_params" key="entry_archive">'
- entry_template: '<mt:var name="template_params" key="entry_template">'
- page_archive: '<mt:var name="template_params" key="page_archive">'
- page_template: '<mt:var name="template_params" key="page_template">'
- feedback_template: '<mt:var name="template_params" key="feedback_template">'
- datebased_only_archive: '<mt:var name="template_params" key="datebased_only_archive">'
- datebased_daily_archive: '<mt:var name="template_params" key="datebased_daily_archive">'
- datebased_weekly_archive: '<mt:var name="template_params" key="datebased_weekly_archive">'
- datebased_monthly_archive: '<mt:var name="template_params" key="datebased_monthly_archive">'
- datebased_yearly_archive: '<mt:var name="template_params" key="datebased_yearly_archive">'
- author_archive: '<mt:var name="template_params" key="author_archive">'
- author_based_archive: '<mt:var name="template_params" key="author_based_archive">'
- author_daily_archive: '<mt:var name="template_params" key="author_daily_archive">'
- author_weekly_archive: '<mt:var name="template_params" key="author_weekly_archive">'
- author_monthly_archive: '<mt:var name="template_params" key="author_monthly_archive">'
- author_yearly_archive: '<mt:var name="template_params" key="author_yearly_archive">'
- category_archive: '<mt:var name="template_params" key="category_archive">'
- category_based_archive: '<mt:var name="template_params" key="category_based_archive">'
- category_set_based_archive: '<mt:var name="template_params" key="category_set_based_archive">'
- category_daily_archive: '<mt:var name="template_params" key="category_daily_archive">'
- category_weekly_archive: '<mt:var name="template_params" key="category_weekly_archive">'
- category_monthly_archive: '<mt:var name="template_params" key="category_monthly_archive">'
- category_yearly_archive: '<mt:var name="template_params" key="category_yearly_archive">'
- archive_class: '<mt:var name="template_params" key="archive_class">'
- contenttype_archive: '<mt:var name="template_params" key="contenttype_archive">'
- contenttype_archive_listing: '<mt:var name="template_params" key="contenttype_archive_listing">'
</mt:Archives>
--- expected

=== type with ContentType
--- skip
1
--- template
<mt:Archives archive_type="ContentType">
<mt:ArchiveType>
</mt:Archives>
--- expected

=== No modifier
--- skip
1
--- template
<mt:Archives>
<mt:ArchiveType>
</mt:Archives>
--- expected
