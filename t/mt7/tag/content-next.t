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

        my $author2
            = MT::Test::Permission->make_author( name => 'test user2', );

        my $category_set
            = MT::Test::Permission->make_category_set( blog_id => $blog_id );

        my $category1 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category1',
        );
        my $category2 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category2',
        );

        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content type',
            blog_id => $blog_id,
        );
        my $cat_cf = MT::Test::Permission->make_content_field(
            blog_id            => $ct->blog_id,
            content_type_id    => $ct->id,
            name               => 'categories',
            type               => 'categories',
            related_cat_set_id => $category_set->id,
        );
        my $date_cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $fields = [
            {   id      => $cat_cf->id,
                order   => 1,
                type    => $cat_cf->type,
                options => {
                    label        => 1,
                    category_set => $cat_cf->related_cat_set_id,
                },
                unique_id => $cat_cf->unique_id,
            },
            {   id        => $date_cf->id,
                order     => 2,
                type      => $date_cf->type,
                options   => { label => $date_cf->name },
                unique_id => $date_cf->unique_id,
            },
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd1 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cat_cf->id  => [ $category1->id ],
                $date_cf->id => '20180308180500',
            },
        );
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            author_id       => $author2->id,
            data            => {
                $cat_cf->id  => [ $category2->id ],
                $date_cf->id => '20180307180500',
            },
        );
        my $cd3 = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $ct->id,
            author_id       => 1,
            data            => {
                $cat_cf->id  => [ $category1->id ],
                $date_cf->id => '20180306180500',
            },
        );

        $cd1->authored_on('201706011930');
        $cd1->modified_on('201706011930');
        $cd1->save or die $cd1->errstr;

        $cd2->authored_on('201706021930');
        $cd2->modified_on('201705311930');
        $cd2->save or die $cd2->errstr;

        $cd3->authored_on('201706031930');
        $cd3->modified_on('201705301930');
        $cd3->save or die $cd3->errstr;
    }
);

my $author2 = MT::Author->load( { name => 'test user2' } );

my $category1 = MT::Category->load(
    { label => 'category1', category_set_id => \'> 0' } );
my $category2 = MT::Category->load(
    { label => 'category2', category_set_id => \'> 0' } );

my $ct = MT::ContentType->load( { name => 'test content type' } );

my $cat_cf  = MT::ContentField->load( { name => 'categories' } );
my $date_cf = MT::ContentField->load( { name => 'date and time' } );

my $cd1 = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $ct->id,
        author_id       => 1,
        authored_on     => '2017-06-01 19:30',
    }
);
my $cd2 = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $ct->id,
        author_id       => $author2->id,
        authored_on     => '2017-06-02 19:30',
    }
);
my $cd3 = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $ct->id,
        author_id       => 1,
        authored_on     => '2017-06-03 19:30',
    }
);

$vars->{ct_uid}  = $ct->unique_id;
$vars->{ct_name} = $ct->name;
$vars->{ct_id}   = $ct->id;

$vars->{cat1_id} = $category1->id;
$vars->{cat2_id} = $category2->id;

$vars->{cat_cf_id}  = $cat_cf->id;
$vars->{date_cf_id} = $date_cf->id;

$vars->{cd1_id} = $cd1->id;
$vars->{cd2_id} = $cd2->id;
$vars->{cd3_id} = $cd3->id;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:ContentNext with unique id
--- template
<mt:Contents content_type="[% ct_uid %]"><mt:ContentNext><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %][% cd2_id %]

=== MT:ContentNext with name
--- template
<mt:Contents content_type="[% ct_name %]"><mt:ContentNext><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %][% cd2_id %]

=== MT:ContentNext with id
--- template
<mt:Contents content_type="[% ct_id %]"><mt:ContentNext><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %][% cd2_id %]

=== MT:ContentNext with by_author="1"
--- template
<mt:Contents content_type="test content type"><mt:ContentNext by_author="1"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %]

=== MT:ContentNext with date_field="modified_on"
--- template
<mt:Contents content_type="test content type"><mt:ContentNext date_field="modified_on"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd2_id %][% cd1_id %]

=== MT:ContentNext with category_field
--- template
<mt:Contents content_type="test content type"><mt:ContentNext category_field="[% cat_cf_id %]"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd3_id %]

=== MT:ContentNext with date_field
--- template
<mt:Contents content_type="test content type"><mt:ContentNext date_field="[% date_cf_id %]"><mt:ContentID></mt:ContentNext></mt:Contents>
--- expected
[% cd2_id %][% cd1_id %]

