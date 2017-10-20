#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
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
use MT::Test qw(:db);
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

my $mt = MT->instance;

my $author2 = MT::Test::Permission->make_author;

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
$vars->{cat1_id} = $category1->id;
$vars->{cat2_id} = $category2->id;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);
my $cf = MT::Test::Permission->make_content_field(
    blog_id            => $ct->blog_id,
    content_type_id    => $ct->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);
my $fields = [
    {   id      => $cf->id,
        order   => 1,
        type    => $cf->type,
        options => {
            label        => 1,
            category_set => $cf->related_cat_set_id,
        },
        unique_id => $cf->unique_id,
    }
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => { $cf->id => [ $category1->id ] },
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => $author2->id,
    data            => { $cf->id => [ $category2->id ] },
);
my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => { $cf->id => [ $category1->id ] },
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

$vars->{cd1_id} = $cd1->id;
$vars->{cd2_id} = $cd2->id;
$vars->{cd3_id} = $cd3->id;

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT:ContentPrevious
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentPrevious><mt:ContentID></mt:ContentPrevious></mt:Contents>
--- expected
[% cd2_id %][% cd1_id %]

=== MT:ContentPrevious with by_author="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentPrevious by_author="1"><mt:ContentID></mt:ContentPrevious></mt:Contents>
--- expected
[% cd1_id %]

=== MT:ContentPrevious with by_modified_on="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentPrevious by_modified_on="1"><mt:ContentID></mt:ContentPrevious></mt:Contents>
--- expected
[% cd3_id %][% cd2_id %]

=== MT:ContentPrevious with by_category="1"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentPrevious by_category="1"><mt:ContentID></mt:ContentPrevious></mt:Contents>
--- expected
[% cd1_id %]

=== MT:ContentPrevious with by_category="1" category_id="???"
--- template
<mt:Contents blog_id="1" name="test content type"><mt:ContentPrevious by_category="1" category_id="[% cat1_id %]"><mt:ContentID></mt:ContentPrevious></mt:Contents>
--- expected
[% cd1_id %][% cd1_id %]

