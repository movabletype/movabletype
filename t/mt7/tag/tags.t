#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
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
        my $cf_tag1 = MT::Test::Permission->make_content_field(
            blog_id         => $ct1->blog_id,
            content_type_id => $ct1->id,
            name            => 'tags',
            type            => 'tags',
        );
        my $tag1 = MT::Test::Permission->make_tag( name => 'tag1' );
        my $tag2 = MT::Test::Permission->make_tag( name => 'tag2' );

        my $fields1 = [
            {   id      => $cf_tag1->id,
                order   => 14,
                type    => $cf_tag1->type,
                options => {
                    label    => $cf_tag1->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
            },
        ];
        $ct1->fields($fields1);
        $ct1->save or die $ct1->errstr;

        my $cd01 = MT::Test::Permission->make_content_data(
            blog_id         => $ct1->blog_id,
            content_type_id => $ct1->id,
            author_id       => 1,
            data            => { $cf_tag1->id => [ $tag2->id, $tag1->id ], },
        );
        my $cd02 = MT::Test::Permission->make_content_data(
            blog_id         => $ct1->blog_id,
            content_type_id => $ct1->id,
            author_id       => 1,
            data            => { $cf_tag1->id => [ $tag2->id ], },
        );

        my $ct2 = MT::Test::Permission->make_content_type(
            name    => 'test content type 2',
            blog_id => $blog_id,
        );
        my $cf_tag2 = MT::Test::Permission->make_content_field(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            name            => 'tags',
            type            => 'tags',
        );
        my $tag3 = MT::Test::Permission->make_tag( name => 'tag3' );
        my $tag4 = MT::Test::Permission->make_tag( name => 'tag4' );

        my $fields2 = [
            {   id      => $cf_tag2->id,
                order   => 1,
                type    => $cf_tag2->type,
                options => {
                    label    => $cf_tag2->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
            },
        ];
        $ct2->fields($fields2);
        $ct2->save or die $ct2->errstr;

        my $cd03 = MT::Test::Permission->make_content_data(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            author_id       => 1,
            data            => { $cf_tag2->id => [ $tag4->id, $tag3->id ], },
        );
        my $cd04 = MT::Test::Permission->make_content_data(
            blog_id         => $ct2->blog_id,
            content_type_id => $ct2->id,
            author_id       => 1,
            data            => { $cf_tag2->id => [ $tag4->id ], },
        );
    }
);

my $ct = MT::ContentType->load( { name => 'test content type 1' } );

$vars->{ct_uid}  = $ct->unique_id;
$vars->{ct_name} = $ct->name;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:Tags
--- template
<mt:Tags top="20" type="content_type" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag2:2,tag4:2,tag1:1,tag3:1

=== mt:Tags with content_type unique_id
--- template
<mt:Tags top="20" type="content_type" content_type="[% ct_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag2:2,tag1:1

=== mt:Tags with content_type name
--- template
<mt:Tags top="20" type="content_type" content_type="[% ct_name %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag2:2,tag1:1

=== mt:Tags with wrong content_type
--- template
<mt:Tags top="20" type="content_type" content_type="aaa" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- error
No Content Type could be found.

=== mt:Tags with wrong type
--- template
<mt:Tags type="entry" content_type="[% ct_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- error
content_type modifier cannot be used with type "entry".

=== mt:Tags without type
--- template
<mt:Tags content_type="[% ct_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag1:1,tag2:2

