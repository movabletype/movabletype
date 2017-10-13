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


use lib qw(lib t/lib);

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

my $mt = MT->instance;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content data',
    blog_id => $blog_id,
);

my $cf1 = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'single1',
    type            => 'single_line_text',
);
my $cf2 = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'single2',
    type            => 'single_line_text',
);

my $fields = [
    {   id        => $cf1->id,
        order     => 1,
        type      => $cf1->type,
        options   => { label => $cf1->name },
        unique_id => $cf1->unique_id,
    },
    {   id        => $cf2->id,
        order     => 10,
        type      => $cf2->type,
        options   => { label => $cf2->name },
        unique_id => $cf2->unique_id,
    },
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    author_id       => 1,
    data            => {
        $cf1->id => 'test1',
        $cf2->id => 'test2',
    },
);

MT::Test::Tag->run_perl_tests($blog_id);
# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::ContentFields
--- template
<mt:Contents blog_id="1" name="test content data"><mt:ContentFields>
<mt:if name="content_field_options{label}" eq="single1"><mt:ContentField><mt:var name="__value__"></mt:ContentField><mt:else><mt:var name="content_field_order"></mt:if></mt:ContentFields></mt:Contents>
--- expected
test1
10

