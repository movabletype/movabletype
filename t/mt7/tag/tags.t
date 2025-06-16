#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

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


        #case value 0
        my $ct3 = MT::Test::Permission->make_content_type(
            name    => 'tag name is 0',
            blog_id => $blog_id,
        );

        my $cf_tag3 = MT::Test::Permission->make_content_field(
            blog_id         => $ct3->blog_id,
            content_type_id => $ct3->id,
            name            => '0',
            type            => 'tags',
        );

        my $tag5 = MT::Test::Permission->make_tag( name => '0' );

        my $fields3 = [
            {   id      => $cf_tag3->id,
                order   => 1,
                type    => $cf_tag3->type,
                options => {
                    label    => $cf_tag3->name,
                    multiple => 1,
                    max      => 5,
                    min      => 1,
                },
            },
        ];

        $ct3->fields($fields3);
        $ct3->save or die $ct3->errstr;

        my $cd05 = MT::Test::Permission->make_content_data(
            blog_id         => $ct3->blog_id,
            content_type_id => $ct3->id,
            author_id       => 1,
            data            => { $cf_tag3->id => [ $tag5->id ], },
        );
    }
);

my $ct = MT::ContentType->load( { name => 'test content type 1' } );
my $ct3 = MT::ContentType->load( { name => 'tag name is 0' } );

$vars->{ct_uid}  = $ct->unique_id;
$vars->{ct_name} = $ct->name;
$vars->{ct_id}   = $ct->id;

$vars->{ct3_uid}  = $ct3->unique_id;
$vars->{ct3_name}  = $ct3->name;
$vars->{ct3_id}   = $ct3->id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:Tags
--- template
<mt:Tags top="20" type="content_type" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag2:2,tag4:2,0:1,tag1:1,tag3:1

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

=== mt:Tags with content_type id
--- template
<mt:Tags top="20" type="content_type" content_type="[% ct_id %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag2:2,tag1:1

=== mt:Tags with wrong content_type
--- template
<mt:Tags top="20" type="content_type" content_type="aaa" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected_error
No Content Type could be found.

=== mt:Tags with wrong type
--- template
<mt:Tags type="entry" content_type="[% ct_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected_error
content_type modifier cannot be used with type "entry".

=== mt:Tags without type
--- template
<mt:Tags content_type="[% ct_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
tag1:1,tag2:2

=== mt:Tags tag name is 0
--- template
<mt:Tags content_type="[% ct3_uid %]" glue=","><$mt:TagName$>:<$mt:TagCount$></mt:Tags>
--- expected
0:1

=== MT:Tags with content_type="ct_id" has a content_type in stash
--- template
<mt:Tags type="content_type" content_type="[% ct_id %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content type 1: tag1
test content type 1: tag2

=== MT:Tags with content_type="ct_unique_id" has a content_type in stash
--- template
<mt:Tags type="content_type" content_type="[% ct_uid %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content type 1: tag1
test content type 1: tag2

=== MT:Tags with content_type="ct_name" has a content_type in stash
--- template
<mt:Tags type="content_type" content_type="[% ct_name %]"><mt:ContentTypeName>: <mt:TagName>
</mt:Tags>
--- expected
test content type 1: tag1
test content type 1: tag2
