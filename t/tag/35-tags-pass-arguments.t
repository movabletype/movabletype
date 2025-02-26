#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture('db');

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== Pass hash variable
--- template
<mt:Var name="hsh" key="ky" value="hoge">
<mt:If name="hsh{ky}" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!

=== Pass array variable
--- template
<mt:Var name="arr" index="1" value="hoge">
<mt:If name="arr[1]" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!

=== Pass primitive variable
--- template
<mt:Var name="normal" value="hoge">
<mt:If name="normal" eq="fuga">
fuga!
<mt:ElseIf eq="hoge">
hoge!
<mt:Else>
moga!
</mt:If>
--- expected
hoge!

=== MTC-30264
--- template
<mt:setvar name="val" value="1"><mt:If name="val" eq="1"><mt:Unless>1</mt:Unless></mt:If>
<mt:setvar name="val" value="0"><mt:If name="val" eq="0"><mt:Unless>0</mt:Unless></mt:If>
--- expected
1
0

=== MTC-30264: Unless with global modifiers
--- template
<mt:setvar name="val" value="1"><mt:If name="val" eq="1"><mt:Unless regex_replace="/Melody/g","Milady"><mt:Authors need_entry="0"><mt:AuthorDisplayName><mt:AuthorName></mt:Authors></mt:Unless></mt:If>
--- expected
MiladyMilady
