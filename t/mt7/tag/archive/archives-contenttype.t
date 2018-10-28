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
        RebuildAtDelete      => 1,
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

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my $archive_types
    = 'Individual,Page,Daily,Weekly,Monthly,Yearly,Author,Author-Daily,Author-Weekly,Author-Monthly,Author-Yearly,Category,Category-Daily,Category-Weekly,Category-Monthly,Category-Yearly,ContentType,ContentType-Daily,ContentType-Weekly,ContentType-Monthly,ContentType-Yearly,ContentType-Author,ContentType-Author-Daily,ContentType-Author-Weekly,ContentType-Author-Monthly,ContentType-Author-Yearly,ContentType-Category,ContentType-Category-Daily,ContentType-Category-Weekly,ContentType-Category-Monthly,ContentType-Category-Yearly';

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

=== type with ContentType
--- template
<mt:Archives type="ContentType">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
ContentType
***
archive_class: contenttype-archive
archive_template: 1
contenttype_archive: 1

=== archive_type with ContentType
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
