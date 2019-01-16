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
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $user2 = MT::Test::Permission->make_author;
        my $ct1   = MT::Test::Permission->make_content_type(
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
            blog_id         => $blog_id,
            content_type_id => $ct1->id,
            status          => MT::ContentStatus::HOLD(),
        );
        MT::Test::Permission->make_content_data(
            author_id       => $user2->id,
            blog_id         => $blog_id,
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

=== MT::AuthorContentCount with content_type="unique_id"
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct1_uid %]"></mt:Authors>
--- expected
5

=== MT::AuthorContentCount with content_type="id"
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct1_id %]"></mt:Authors>
--- expected
5

=== MT::AuthorContentCount with content_type="name"
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct1_name %]"></mt:Authors>
--- expected
5

=== MT::AuthorContentCount without author context
(Content data author is actually used in an individual content page, not with Contents tag)
--- template
<mt:Contents content_type="test content type 1"><mt:AuthorContentCount></mt:Contents>
--- expected
166666

=== MT::AuthorContentCount with plural
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct1_uid %]" plural="plural #"></mt:Authors>
--- expected
plural 5

=== MT::AuthorContentCount with singular
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct2_uid %]" singular="singular"></mt:Authors>
--- expected
singular

=== MT::AuthorContentCount with none
--- template
<mt:Authors id="1"><mt:AuthorContentCount content_type="[% ct3_uid %]" none="none"></mt:Authors>
--- expected
none

