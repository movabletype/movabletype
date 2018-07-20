#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content data',
            blog_id => $blog_id,
        );
        my $cd1 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            unpublished_on  => '20170530190100',
        );
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            unpublished_on  => undef,
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentUnpublishedDate
--- template
<mt:Contents content_type="test content data"><mt:ContentUnpublishedDate></mt:Contents>
--- expected
May 30, 2017  7:01 PM

=== MT::ContentUnpublishedDate with date formats
--- template
<mt:Contents content_type="test content data">
<mt:ContentUnpublishedDate format="%Y">
<mt:ContentUnpublishedDate format="%y">
<mt:ContentUnpublishedDate format="%b">
<mt:ContentUnpublishedDate format="%B">
<mt:ContentUnpublishedDate format="%m">
<mt:ContentUnpublishedDate format="%d">
<mt:ContentUnpublishedDate format="%e">
<mt:ContentUnpublishedDate format="%j">
<mt:ContentUnpublishedDate format="%H">
<mt:ContentUnpublishedDate format="%k">
<mt:ContentUnpublishedDate format="%I">
<mt:ContentUnpublishedDate format="%l">
<mt:ContentUnpublishedDate format="%M">
<mt:ContentUnpublishedDate format="%S">
<mt:ContentUnpublishedDate format="%p">
<mt:ContentUnpublishedDate format="%a">
<mt:ContentUnpublishedDate format="%A">
<mt:ContentUnpublishedDate format="%w">
<mt:ContentUnpublishedDate format="%x">
<mt:ContentUnpublishedDate format="%X">
<mt:ContentUnpublishedDate format_name="iso8601">
<mt:ContentUnpublishedDate format_name="rfc822">
<mt:ContentUnpublishedDate language="en">
<mt:ContentUnpublishedDate utc="1">
</mt:Contents>
--- expected
2017
17
May
May
05
30
30
150
19
19
07
 7
01
00
PM
Tue
Tuesday
2
May 30, 2017
 7:01 PM
2017-05-30T19:01:00+00:00
Tue, 30 May 2017 19:01:00 +0000
May 30, 2017  7:01 PM
May 30, 2017  7:01 PM

