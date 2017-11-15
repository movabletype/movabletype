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

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

use MT::ContentStatus;

my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct1 = MT::Test::Permission->make_content_type(
            name    => 'test content type 1',
            blog_id => $blog_id,
        );
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct1->id,
            status          => MT::ContentStatus::RELEASE(),
        ) for ( 1 .. 5 );
    }
);

my $ct1 = MT::ContentType->load( { name => 'test content type 1' } );

$vars->{ct1_id}  = $ct1->id;
$vars->{ct1_uid} = $ct1->unique_id;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentsCount without modifier
--- template
<mt:ContentsCount>
--- error
No Content Type could be found.

=== MT::ContentsCount in contents context
--- template
<mt:Contents blog_id="1" name="test content type 1"><mt:ContentsHeader><mt:ContentsCount></mt:ContentsHeader></mt:Contents>
--- expected
5

=== MT::ContentsCount with content_type_id modifier
--- template
<mt:ContentsCount content_type_id="[% ct1_id %]">
--- expected
5

=== MT::ContentsCount with ct_unique_id modifier
--- SKIP
--- template
<mt:ContentsCount ct_unique_id="[% ct1_uid %]">
--- expected
5

=== MT::ContentsCount with name modifier
--- template
<mt:ContentsCount name="test content type 1">
--- expected
5

=== MT::ContentsCount with name modifier and wrong blog_id
--- template
<mt:ContentsCount name="test content type 1" blog_id="2">
--- error
No Content Type could be found.

