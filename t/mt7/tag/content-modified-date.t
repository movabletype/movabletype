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
            created_on      => '20170530190000',
            modified_on     => '20170530193000',
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentModifieddDate
--- template
<mt:Contents content_type="test content data"><mt:ContentModifiedDate></mt:Contents>
--- expected
May 30, 2017  7:30 PM

=== MT::ContentModifiedDate with date formats
--- template
<mt:Contents content_type="test content data">
<mt:ContentModifiedDate format="%Y">
<mt:ContentModifiedDate format="%y">
<mt:ContentModifiedDate format="%b">
<mt:ContentModifiedDate format="%B">
<mt:ContentModifiedDate format="%m">
<mt:ContentModifiedDate format="%d">
<mt:ContentModifiedDate format="%e">
<mt:ContentModifiedDate format="%j">
<mt:ContentModifiedDate format="%H">
<mt:ContentModifiedDate format="%k">
<mt:ContentModifiedDate format="%I">
<mt:ContentModifiedDate format="%l">
<mt:ContentModifiedDate format="%M">
<mt:ContentModifiedDate format="%S">
<mt:ContentModifiedDate format="%p">
<mt:ContentModifiedDate format="%a">
<mt:ContentModifiedDate format="%A">
<mt:ContentModifiedDate format="%w">
<mt:ContentModifiedDate format="%x">
<mt:ContentModifiedDate format="%X">
<mt:ContentModifiedDate format_name="iso8601">
<mt:ContentModifiedDate format_name="rfc822">
<mt:ContentModifiedDate language="en">
<mt:ContentModifiedDate utc="1">
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
30
00
PM
Tue
Tuesday
2
May 30, 2017
 7:30 PM
2017-05-30T19:30:00+00:00
Tue, 30 May 2017 19:30:00 +0000
May 30, 2017  7:30 PM
May 30, 2017  7:30 PM

