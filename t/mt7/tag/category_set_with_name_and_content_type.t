#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Fixture;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key (keys %{$vars}) {
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

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    author       => [qw/author/],
    website      => [{ name => 'test site' }],
    category_set => {
        catset => [qw/2020 2021 2022/],
    },
    content_type => {
        ct1 => [
            cf_title    => 'single_line_text',
            cf_category => {
                type         => 'categories',
                category_set => 'catset',
                options      => { multiple => 1 },
            },
        ],
        ct2 => [
            cf_title    => 'single_line_text',
            cf_category => {
                type         => 'categories',
                category_set => 'catset',
                options      => { multiple => 1 },
            },
        ],
    },
    content_data => {
        first_cd => {
            content_type => 'ct1',
            author       => 'author',
            data         => {
                cf_title    => 'first',
                cf_category => [qw/2020 2021 2022/] }
        },
        second_cd => {
            content_type => 'ct2',
            author       => 'author',
            data         => {
                cf_title    => 'second',
                cf_category => [qw/2022/] }
        },
        third_cd => {
            content_type => 'ct2',
            author       => 'author',
            data         => {
                cf_title    => 'third',
                cf_category => [qw/2022/] }
        },
    },
});

my $site = $objs->{website}{'test site'};

MT::Test::Tag->run_perl_tests($site->id);
MT::Test::Tag->run_php_tests($site->id);

__END__

=== mt:CategorySets
--- template
<mt:CategorySets name="catset" content_type="ct1">
<mt:TopLevelCategories>
<label><mt:CategoryLabel></label>
<count><mt:CategoryCount></count>
</mt:TopLevelCategories>
</mt:CategorySets>
--- expected
<label>2020</label>
<count>1</count>

<label>2021</label>
<count>1</count>

<label>2022</label>
<count>1</count>
