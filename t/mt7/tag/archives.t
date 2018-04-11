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

plan tests => 1 * blocks;

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

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog_01 = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog 01',
        );
        $blog_01->archive_type(
            'ContentType-Category,ContentType-Author,ContentType-Category-Monthly'
        );
        $blog_01->save;

        my $blog_02 = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog 02',
        );

        my $content_type_01 = MT::Test::Permission->make_content_type(
            blog_id => $blog_01->id,
            name    => 'test content type 01',
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            blog_id => $blog_01->id,
            name    => 'test content type 02',
        );

        my $cf_category_01 = MT::Test::Permission->make_content_field(
            blog_id         => $blog_01->id,
            content_type_id => $content_type_01->id,
            name            => 'Category Field 01',
            type            => 'categories',
        );

        my $cf_category_02 = MT::Test::Permission->make_content_field(
            blog_id         => $blog_01->id,
            content_type_id => $content_type_02->id,
            name            => 'Category Field 02',
            type            => 'categories',
        );

        my $category_set_01 = MT::Test::Permission->make_category_set(
            blog_id => $blog_01->id,
            name    => 'test category set 01',
        );

        my $category_set_02 = MT::Test::Permission->make_category_set(
            blog_id => $blog_01->id,
            name    => 'test category set 02',
        );

        my $category_set_03 = MT::Test::Permission->make_category_set(
            blog_id => $blog_02->id,
            name    => 'test category set 03',
        );

        my $category_01 = MT::Test::Permission->make_category(
            blog_id         => $blog_01->id,
            category_set_id => $category_set_01->id,
            label           => 'Category 01',
        );

        my $category_02 = MT::Test::Permission->make_category(
            blog_id         => $blog_01->id,
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
    }
);

my $blog_01 = MT::Blog->load( { name => 'test blog 01' } );

MT::Test::Tag->run_perl_tests( $blog_01->id );

#MT::Test::Tag->run_php_tests( $blog_01->id );

__END__

=== mt:Archives label="No ID"
--- template
<mt:Archives><mt:if name="template_params" key="category_set_based_archive"><mt:var name="template_params" key="category_set_based_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
1,0,1
