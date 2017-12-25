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

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $blog = MT::Test::Permission->make_blog(
        parent_id => 0,
        name => 'test blog',
    );

    my $content_type_01 = MT::Test::Permission->make_content_type(
        blog_id => $blog->id,
        name    => 'test content type 01',
    );

    my $content_type_02 = MT::Test::Permission->make_content_type(
        blog_id => $blog->id,
        name    => 'test content type 02',
    );

    my $cf_category_01 = MT::Test::Permission->make_content_field(
        blog_id         => $blog->id,
        content_type_id => $content_type_01->id,
        name            => 'Category Field 01',
        type            => 'categories',
    );

    my $cf_category_02 = MT::Test::Permission->make_content_field(
        blog_id         => $blog->id,
        content_type_id => $content_type_02->id,
        name            => 'Category Field 02',
        type            => 'categories',
    );

    my $category_set_01 = MT::Test::Permission->make_category_set(
        blog_id => $blog->id,
        name    => 'test category set 01',
    );

    my $category_set_02 = MT::Test::Permission->make_category_set(
        blog_id => $blog->id,
        name    => 'test category set 02',
    );

    my $category_01 = MT::Test::Permission->make_category(
        blog_id         => $blog->id,
        category_set_id => $category_set_01->id,
        label           => 'Category 01',
    );

    my $category_02 = MT::Test::Permission->make_category(
        blog_id         => $blog->id,
        category_set_id => $category_set_02->id,
        label           => 'Category 02',
    );

    my $fields_01 = [
        {   id      => $cf_category_01->id,
            order   => 15,
            type    => $cf_category_01->type,
            options => {
                label        => $cf_category_01->name,
                category_set => $category_set_01->id,
                multiple     => 1,
                max          => 5,
                min          => 1,
            },
        },
    ];

    my $fields_02 = [
        {   id      => $cf_category_02->id,
            order   => 15,
            type    => $cf_category_02->type,
            options => {
                label        => $cf_category_02->name,
                category_set => $category_set_02->id,
                multiple     => 1,
                max          => 5,
                min          => 1,
            },
        },
    ];

    $content_type_01->fields($fields_01);
    $content_type_01->save or die $content_type_01->errstr;

    $content_type_02->fields($fields_02);
    $content_type_02->save or die $content_type_02->errstr;
});

my $blog = MT::Blog->load( { name => 'test blog' } );

my $content_type_01 = MT::ContentType->load( { name => 'test content type 01' } );
my $content_type_02 = MT::ContentType->load( { name => 'test content type 02' } );

my $category_set_01 = MT::CategorySet->load( { name => 'test category set 01' } );

my $category_set_02 = MT::CategorySet->load( { name => 'test category set 02' } );

$vars->{blog_id}                   = $blog->id;
$vars->{category_set_01_id}        = $category_set_01->id;
$vars->{category_set_02_name}      = $category_set_02->name;
$vars->{content_type_01_name}      = $content_type_01->name;
$vars->{content_type_02_unique_id} = $content_type_02->unique_id;

MT::Test::Tag->run_perl_tests( $blog->id );
MT::Test::Tag->run_php_tests( $blog->id );

__END__

=== mt:CategorySets label="No ID"
--- template
<mt:CategorySets><mt:CategorySetName></mt:CategorySets>
--- expected
test category set 01test category set 02

=== mt:CategorySets label="Set ID"
--- template
<mt:CategorySets id="[% category_set_01_id %]"><mt:CategorySetName></mt:CategorySets>
--- expected
test category set 01

=== mt:CategorySets label="Set Content Type Unique ID"
--- template
<mt:CategorySets content_type="[% content_type_02_unique_id %]"><mt:CategorySetName></mt:CategorySets>
--- expected
test category set 02
--- skip_php
1

=== mt:CategorySets label="Set Content Type Name"
--- template
<mt:CategorySets blog_id="[% blog_id %]" content_type="[% content_type_01_name %]"><mt:CategorySetName></mt:CategorySets>
--- expected
test category set 01
--- skip_php
1

=== mt:CategorySets label="Set Category Set Name"
--- template
<mt:CategorySets blog_id="[% blog_id %]" name="[% category_set_02_name %]"><mt:CategorySetName></mt:CategorySets>
--- expected
test category set 02

