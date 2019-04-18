#!/usr/bin/perl
# $Id: 11-sanitize.t 3219 2008-12-03 07:58:25Z fumiakiy $
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

plan tests => 58;

use MT;
use MT::Test;
use MT::Sanitize;

my $atts;

$atts = MT::Sanitize->parse_spec('a href');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{a}, '{ok}{a}');
ok($atts->{ok}{a}{href}, '{ok}{a}{href}');

$atts = MT::Sanitize->parse_spec('a href,b');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{a}, '{ok}{a}');
ok($atts->{ok}{a}{href}, '{ok}{a}{href}');
ok($atts->{ok}{b}, '{ok}{b}');

$atts = MT::Sanitize->parse_spec('br/');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{br}, '{ok}{br}');
is($atts->{tag_attr}{br}, '/', '{tag_attr}{br}=/');

$atts = MT::Sanitize->parse_spec('img/ src');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{img}, '{ok}{img}');
ok($atts->{ok}{img}{src}, '{ok}{img}{src}');
is($atts->{tag_attr}{img}, '/', '{tag_attr}{img}=/');

$atts = MT::Sanitize->parse_spec('* align');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{'*'}, "{ok}{'*'}");
ok($atts->{ok}{'*'}{align}, "{ok}{'*'}{align}");

$atts = MT::Sanitize->parse_spec('p,* align');
isa_ok($atts, 'HASH');
ok($atts->{ok}, '{ok}');
ok($atts->{ok}{'*'}, "{ok}{'*'}");
ok($atts->{ok}{'*'}{align}, "{ok}{'*'}{align}");
ok($atts->{ok}{p}, '{ok}{p}');

is(MT::Sanitize->sanitize('<?php readfile("/etc/passwd") ?>'), '', 'php passwd');

is(MT::Sanitize->sanitize('<? readfile("/etc/passwd") ?>'), '', 'passwd');

is(MT::Sanitize->sanitize('passwords! <? readfile("/etc/passwd") ?>'), 'passwords! ', 'passwords! ');

is(MT::Sanitize->sanitize('<? start some evil PHP'), '', 'evil PHP');

is(MT::Sanitize->sanitize('<% some ASP code %>'), '', 'ASP code');

is(MT::Sanitize->sanitize('<!--#exec cgi="/some/bad.cgi"-->'), '', 'exec cgi');

is(MT::Sanitize->sanitize('<script src="evil.js">'), '', 'evil.js');

is(MT::Sanitize->sanitize('foo'), 'foo', 'foo');

is(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>'), 'kittens', 'kittens');

is(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>', { ok => { a => {} } }), '<a>kittens</a>', '<a>kittens</a>');

is(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>', { ok => { a => { href => 1 } } }), '<a href="foo.html">kittens</a>', '<a href="foo.html">kittens</a>');

is(MT::Sanitize->sanitize('<code>code</code>'), 'code', 'code');

is(MT::Sanitize->sanitize('<b>bold</b>', MT::Sanitize->parse_spec('b')), '<b>bold</b>', '<b>bold</b>');

is(MT::Sanitize->sanitize('Some text<br />with a line break', MT::Sanitize->parse_spec('br/')), 'Some text<br />with a line break', 'Some text<br />with a line break');

is(MT::Sanitize->sanitize('Some text<br>with a line break', MT::Sanitize->parse_spec('br/')), 'Some text<br />with a line break', 'Some text<br />with a line break');

is(MT::Sanitize->sanitize('<img onmouseover="killComputer()" src="foo.jpg">', MT::Sanitize->parse_spec('img/ src')), '<img src="foo.jpg" />', '<img src="foo.jpg" />');

is(MT::Sanitize->sanitize('<img onmouseover="killComputer()" src="foo.jpg">', 'img/ src'), '<img src="foo.jpg" />', '<img src="foo.jpg" />');

is(MT::Sanitize->sanitize('<b>open bold', 'b'), '<b>open bold</b>', '<b>open bold</b>');

is(MT::Sanitize->sanitize('<b><i>open</b> italic', 'b,i'), '<b><i>open</i></b> italic', '<b><i>open</i></b> italic');

is(MT::Sanitize->sanitize('<a><b><blockquote><i>open</b> italic', 'b,i'), '<b><i>open</i></b> italic', '<b><i>open</i></b> italic');

is(MT::Sanitize->sanitize('<a href="javascript:alert(\'xxx\')">boo</a>', 'a href'), '<a>boo</a>', '<a>boo</a>');

is(MT::Sanitize->sanitize('<a href="jav&#x0D;ascript:alert(\'xxx\')">boo</a>', 'a href'), '<a>boo</a>', '<a>boo</a>');

is(MT::Sanitize->sanitize('<a href="java&#x20;script.html">boo</a>', 'a href'), '<a href="java&#x20;script.html">boo</a>', '<a href="java&#x20;script.html">boo</a>');

is(MT::Sanitize->sanitize('<a href="javascript&#5' . chr(0) . '8;alert(\'boo\')">click</a>', 'a href'), '<a>click</a>', '<a href="javascript&5(null)8;alert(\'boo\')">click</a>');

is(MT::Sanitize->sanitize('<p><i style="x:expression:alert(\'xss\')"', 'p,i'), '<p></p>', '<p><i style="x:expression:alert(\'xss\')"');

### this one breaks...
is(MT::Sanitize->sanitize('<? /* ?> */ readfile("/etc/passwd") ?>'), ' */ readfile("/etc/passwd") ?>', 'php cloaking attempt');

is(MT::Sanitize->sanitize("<a href='
javascript:alert(123)'>boo</a>", 'a href'), '<a>boo</a>', '<a>boo</a>'); 

### Remove template engine tag from the attribute value
is(MT::Sanitize->sanitize(q{<a href="<?php /*">*/ echo '">' . htmlspecialchars_decode("&lt;script&gt;alert('test')&lt;/script&gt;"); ?>test</a>}, 'a href'), q{<a>*/ echo '">' . htmlspecialchars_decode("&lt;script&gt;alert('test')&lt;/script&gt;"); ?>test</a>}, 'PHP tag in the attribute');

is(MT::Sanitize->sanitize(q{<a href="<% /** "> **/ some jsp code %>test</a>}, 'a href'), q{<a> **/ some jsp code %>test</a>}, 'JSP tag in the attribute');

is(MT::Sanitize->sanitize(q{<a href='javascr<% "padding '>" %>ipt:alert("test");'>test</a>}, 'a href'), q{<a>" %>ipt:alert("test");'>test</a>}, 'ASP tag in the attribute');

is(MT::Sanitize->sanitize(q{<a href="javascr<!--#config timefmt=' padding ">' -->ipt:alert('test');">test</a>}, 'a href'), q{<a>' -->ipt:alert('test');">test</a>}, 'SSI tag in the attribute');
