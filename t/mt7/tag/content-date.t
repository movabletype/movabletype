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
        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            authored_on     => '20170530203000',
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentDate
--- template
<mt:Contents content_type="test content data"><mt:ContentDate></mt:Contents>
--- expected
May 30, 2017  8:30 PM

=== MT::ContentDate with date formats
--- template
<mt:Contents content_type="test content data">
<mt:ContentDate format="%Y">
<mt:ContentDate format="%y">
<mt:ContentDate format="%b">
<mt:ContentDate format="%B">
<mt:ContentDate format="%m">
<mt:ContentDate format="%d">
<mt:ContentDate format="%e">
<mt:ContentDate format="%j">
<mt:ContentDate format="%H">
<mt:ContentDate format="%k">
<mt:ContentDate format="%I">
<mt:ContentDate format="%l">
<mt:ContentDate format="%M">
<mt:ContentDate format="%S">
<mt:ContentDate format="%p">
<mt:ContentDate format="%a">
<mt:ContentDate format="%A">
<mt:ContentDate format="%w">
<mt:ContentDate format="%x">
<mt:ContentDate format="%X">
<mt:ContentDate format_name="iso8601">
<mt:ContentDate format_name="rfc822">
<mt:ContentDate language="en">
<mt:ContentDate utc="1">
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
20
20
08
 8
30
00
PM
Tue
Tuesday
2
May 30, 2017
 8:30 PM
2017-05-30T20:30:00+00:00
Tue, 30 May 2017 20:30:00 +0000
May 30, 2017  8:30 PM
May 30, 2017  8:30 PM

