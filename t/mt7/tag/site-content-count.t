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

plan tests => 2 * blocks;

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
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $ct1 = MT::Test::Permission->make_content_type(
            name    => 'test content type 1',
            blog_id => $blog_id,
        );
        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'test content type 2',
            blog_id => $blog_id,
        );
        my $ct3 = MT::Test::Permission->make_content_type(
            name    => 'test content type 3',
            blog_id => $blog_id,
        );
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct1->id,
            status          => MT::ContentStatus::RELEASE(),
        ) for ( 1 .. 5 );
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id + 1,
            content_type_id => $ct1->id,
            status          => MT::ContentStatus::RELEASE(),
        );
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct2->id,
            status          => MT::ContentStatus::RELEASE(),
        );
    }
);

my $ct1 = MT::ContentType->load( { name => 'test content type 1' } );
my $ct2 = MT::ContentType->load( { name => 'test content type 2' } );
my $ct3 = MT::ContentType->load( { name => 'test content type 3' } );

$vars->{ct1_id}   = $ct1->id;
$vars->{ct1_uid}  = $ct1->unique_id;
$vars->{ct1_name} = $ct1->name;
$vars->{ct2_uid}  = $ct2->unique_id;
$vars->{ct3_uid}  = $ct3->unique_id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::SiteContentCount no modifier
--- template
<mt:SiteContentCount>
--- expected
6

=== MT::SiteContentCount with content_type="unique_id"
--- template
<mt:SiteContentCount content_type="[% ct1_uid %]">
--- expected
5

=== MT::SiteContentCount with content_type="id"
--- template
<mt:SiteContentCount content_type="[% ct1_id %]">
--- expected
5

=== MT::SiteContentCount with content_type="name"
--- template
<mt:SiteContentCount content_type="[% ct1_name %]">
--- expected
5

=== MT::SiteContentCount with content_type modifier and wrong name
--- template
<mt:SiteContentCount content_type="test content type 5">
--- expected_error
No Content Type could be found.

=== MT::SiteContentCount with plural
--- template
<mt:SiteContentCount content_type="[% ct1_uid %]" plural="plural #">
--- expected
plural 5


=== MT::SiteContentCount with singular
--- template
<mt:SiteContentCount content_type="[% ct2_uid %]" singular="singular">
--- expected
singular

=== MT::SiteContentCount with none
--- template
<mt:SiteContentCount content_type="[% ct3_uid %]" none="none">
--- expected
none

