#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use MT::L10N::ja;
use Test::More;

use utf8;


MT->set_language('ja');

sub test {
    my ( $label, $tmpl, $expected, %lexicon ) = @_;
    # local() for hash slice. it's good way to do localize some of hash keys.
    local @MT::L10N::ja::Lexicon{keys %lexicon} = values %lexicon;
    my $translated = MT->translate_templatized($tmpl);
    is( $translated, $expected, $label );
}

test(
    'Hello world',
    q{<__trans phrase="Hello [_1]" params="World">},
    q{こんにちは World},
    q{Hello [_1]} => q{こんにちは [_1]},
);

test(
    'Multiple params',
    q{<__trans phrase="Seven [_1] [_2]" params="Eight%%Nine">},
    q{7がNineをEight},
    q{Seven [_1] [_2]} => q{7が[_2]を[_1]},
);

test(
    'Include HTML in params ',
    q{<__trans phrase="Foo [_1]" params="<a href="http://example.com/">Bar</a>">},
    q{ふう <a href="http://example.com/">Bar</a>},
    q{Foo [_1]} => q{ふう [_1]},
);

test(
    'Mixed params ',
    qq{What a <__trans phrase="Foo [_1]" params="<a href="http://example.com/"> a <__trans phrase="Entry">\n z </a> is test">},
    qq{What a ふう <a href="http://example.com/"> a ブログ記事\n z </a> is test},
    q{Foo [_1]} => q{ふう [_1]},
);

my $awesome = MT->component('Awesome');
is(
    $awesome->translate_templatized(q{<__trans phrase="Entry">}),
    q{エントリー},
    q{Using plugin's L10N dictionary},
);

is(
    MT->translate_templatized(q{
Awesome: <__trans_section component="Awesome"><__trans phrase="Entry"></__trans_section>
Core: <__trans phrase="Entry">}),
    q{
Awesome: エントリー
Core: ブログ記事},
    q{Using plugin's dictionary via __trans_section block},
);

test( q{__trans tag can be nested in other __trans tag},
    q{<__trans phrase="Foo [_1]" params="<__trans phrase="Bar">">},
    q{ふう ばあ},
    q{Foo [_1]} => q{ふう [_1]},
    q{Bar}      => q{ばあ},
);

test( q{Multiple __trans tags},
    q{<__trans phrase="Foo [_1]" params="Bar"> <__trans phrase="Fizz [_1]" params="Buzz">},
    q{ふう Bar ふぃず Buzz},
    q{Foo [_1]}  => q{ふう [_1]},
    q{Fizz [_1]} => q{ふぃず [_1]},
);

{
## STRESS TEST: is OK for the stack overflow in perl regex performance bug. bugzid:106348.
my $pre  = q{<__trans phrase="void" params="カテゴリ%%<select class="category_id-value">};
my $opt  = q{<option value="0">Category</option>};
my $post = q{</select>%%が">};

my $times = 1000;
my $text = $pre . ( $opt x $times ) . $post;
my $result = 'void';

test( 'Stress test',
    $text,
    $result,
    void => 'void',
);
}

done_testing();

