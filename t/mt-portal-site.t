#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'ja',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
MT->instance;

my @test_suite = ({
        product_name => 'Movable Type',
        product_code => 'MT',
        portal_url   => 'https://www.sixapart.jp/movabletype/',
    },
    {
        product_name => 'Movable Type Advanced',
        product_code => 'MT',
        portal_url   => 'https://www.sixapart.jp/movabletype/solutions/mta.html',
    },
    {
        product_name => 'Movable Type',
        product_code => 'MTP',
        portal_url   => 'https://www.sixapart.jp/movabletype/solutions/mtpremium.html',
    },
    {
        product_name => 'Movable Type Advanced',
        product_code => 'MTP',
        portal_url   => 'https://www.sixapart.jp/movabletype/solutions/mtpremium.html',
    },
);

for my $test (@test_suite) {
    subtest '$PRODUCT_NAME: ' . $test->{product_name} . ', $PRODUCT_CODE: ' . $test->{product_code} => sub {
        $MT::PRODUCT_NAME = $test->{product_name};
        $MT::PRODUCT_CODE = $test->{product_code};
        is(MT->portal_url, $test->{portal_url}, 'MT->portal_url: ' . $test->{portal_url});
    };
}

done_testing;
