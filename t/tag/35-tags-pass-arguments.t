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

use MT::Template;
MT->instance;

subtest 'Pass hash variable' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:Var name="hsh" key="ky" value="hoge">
    <mt:If name="hsh{ky}" eq="fuga">
fuga!
    <mt:ElseIf eq="hoge">
hoge!
    <mt:Else>
moga!
    </mt:If>
__TMPL__

    my $html = $tmpl->output;
    $html =~ s/\s//gs;
    is $html => 'hoge!', 'Pass succeeds';
};

subtest 'Pass array variable' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:Var name="arr" index="1" value="hoge">
    <mt:If name="arr[1]" eq="fuga">
fuga!
    <mt:ElseIf eq="hoge">
hoge!
    <mt:Else>
moga!
    </mt:If>
__TMPL__

    my $html = $tmpl->output;
    $html =~ s/\s//gs;
    is $html => 'hoge!', 'Pass succeeds';
};

subtest 'Pass primitive variable' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:Var name="normal" value="hoge">
    <mt:If name="normal" eq="fuga">
fuga!
    <mt:ElseIf eq="hoge">
hoge!
    <mt:Else>
moga!
    </mt:If>
__TMPL__

    my $html = $tmpl->output;
    $html =~ s/\s//gs;
    is $html => 'hoge!', 'Pass succeeds';
};

done_testing();
