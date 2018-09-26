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
    blog_id  => [qw( var chomp )],
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my $site_path = $test_env->root . "/site";
my $blog      = MT::Test::Permission->make_blog( site_path => $site_path );
my $blog_id   = $blog->id;

my $site_path2 = $test_env->root . "/site2";
my $blog2      = MT::Test::Permission->make_blog( site_path => $site_path2 );
my $blog_id2   = $blog2->id;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);
my $ct2 = MT::Test::Permission->make_content_type(
    name    => 'Content Type',
    blog_id => $blog_id,
);
my $ct3 = MT::Test::Permission->make_content_type(
    name    => 'Content Type',
    blog_id => $blog_id2,
);
my $cf_single_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text2 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $cf_single_line_text3 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id2,
    content_type_id => $ct3->id,
    name            => 'single',
    type            => 'single_line_text',
);

my $cf_multi_line_text = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    name            => 'multiline',
    type            => 'multi_line_text',
);

$ct->fields(
    [   {   id        => $cf_single_line_text->id,
            order     => 1,
            type      => $cf_single_line_text->type,
            options   => { label => $cf_single_line_text->name },
            unique_id => $cf_single_line_text->unique_id,
        },
    ]
);
$ct->save or die $ct->errstr;
$ct2->fields(
    [   {   id        => $cf_single_line_text2->id,
            order     => 1,
            type      => $cf_single_line_text2->type,
            options   => { label => $cf_single_line_text2->name },
            unique_id => $cf_single_line_text2->unique_id,
        },
        {   id        => $cf_multi_line_text->id,
            order     => 2,
            type      => $cf_multi_line_text->type,
            options   => { label => $cf_multi_line_text->name },
            unique_id => $cf_multi_line_text->unique_id,
        },
    ]
);
$ct2->save or die $ct2->errstr;
$ct3->fields(
    [   {   id        => $cf_single_line_text3->id,
            order     => 1,
            type      => $cf_single_line_text3->type,
            options   => { label => $cf_single_line_text3->name },
            unique_id => $cf_single_line_text3->unique_id,
        },
    ]
);
$ct3->save or die $ct3->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    label           => 'Content Data1',
    data            => { $cf_single_line_text->id => 'single', },
);
my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    author_id       => 1,
    label           => 'Content Data2',
    data            => { $cf_single_line_text2->id => 'single', },
);
my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id2,
    content_type_id => $ct3->id,
    author_id       => 1,
    label           => 'Content Data3',
    data            => { $cf_single_line_text3->id => 'single', },
);
my $cd4 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    author_id       => 1,
    label           => 'Content Data4',
    data            => {
        $cf_single_line_text2->id => 'single',
        $cf_multi_line_text->id => 'multiline',
    },
);

$vars->{blog_id}  = $blog_id;
$vars->{blog_id2} = $blog_id2;

MT::Test::Tag->run_perl_tests($blog_id);

MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:Contents with field and sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data2
Content Data4

=== mt:Contents with field and sort_by
--- blog_id
[% blog_id2 %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id2 %]" field:single="single" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data3

=== mt:Contents with multiple fields and sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" field:multiline="multiline" sort_by="field:single"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data4

=== mt:Contents with a field and a different field sort_by
--- blog_id
[% blog_id %]
--- template
<mt:Contents content_type="Content Type" blog_id="[% blog_id %]" field:single="single" sort_by="field:multiline"><mt:ContentLabel>
</mt:Contents>
--- expected
Content Data4
Content Data2

