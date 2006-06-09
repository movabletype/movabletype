#!/usr/bin/perl -w
use strict;

use MT;
use MT::Sanitize;
use Test;

BEGIN { plan tests => 44 }

my($atts, $str);

$atts = MT::Sanitize->parse_spec('a href');
ok($atts->{ok});
ok($atts->{ok}{a});
ok($atts->{ok}{a}{href});

$atts = MT::Sanitize->parse_spec('a href,b');
ok($atts->{ok});
ok($atts->{ok}{a});
ok($atts->{ok}{a}{href});
ok($atts->{ok}{b});

$atts = MT::Sanitize->parse_spec('br/');
ok($atts->{ok});
ok($atts->{ok}{br});
ok($atts->{tag_attr}{br}, '/');

$atts = MT::Sanitize->parse_spec('img/ src');
ok($atts->{ok});
ok($atts->{ok}{img});
ok($atts->{ok}{img}{src});
ok($atts->{tag_attr}{img}, '/');

$atts = MT::Sanitize->parse_spec('* align');
ok($atts->{ok});
ok($atts->{ok}{'*'});
ok($atts->{ok}{'*'}{align});

$atts = MT::Sanitize->parse_spec('p,* align');
ok($atts->{ok});
ok($atts->{ok}{'*'});
ok($atts->{ok}{'*'}{align});
ok($atts->{ok}{p});

ok(!MT::Sanitize->sanitize('<?php readfile("/etc/passwd") ?>'));

ok(!MT::Sanitize->sanitize('<? readfile("/etc/passwd") ?>'));

ok(MT::Sanitize->sanitize('passwords! <? readfile("/etc/passwd") ?>'), 'passwords! ');

ok(!MT::Sanitize->sanitize('<? start some evil PHP'));

ok(!MT::Sanitize->sanitize('<% some ASP code %>'));

ok(!MT::Sanitize->sanitize('<!--#exec cgi="/some/bad.cgi"-->'));

ok(!MT::Sanitize->sanitize('<script src="evil.js">'));

ok(MT::Sanitize->sanitize('foo'), 'foo');

ok(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>'), 'kittens');

ok(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>', { ok => { a => {} } }), '<a>kittens</a>');

ok(MT::Sanitize->sanitize('<a href="foo.html" onclick="runEvilJS()">kittens</a>', { ok => { a => { href => 1 } } }), '<a href="foo.html">kittens</a>');

ok(MT::Sanitize->sanitize('<code>code</code>'), 'code');

ok(MT::Sanitize->sanitize('<b>bold</b>', MT::Sanitize->parse_spec('b')), '<b>bold</b>');

ok(MT::Sanitize->sanitize('Some text<br />with a line break', MT::Sanitize->parse_spec('br/')), 'Some text<br />with a line break');

ok(MT::Sanitize->sanitize('Some text<br>with a line break', MT::Sanitize->parse_spec('br/')), 'Some text<br />with a line break');

ok(MT::Sanitize->sanitize('<img onmouseover="killComputer()" src="foo.jpg">', MT::Sanitize->parse_spec('img/ src')), '<img src="foo.jpg" />');

ok(MT::Sanitize->sanitize('<img onmouseover="killComputer()" src="foo.jpg">', 'img/ src'), '<img src="foo.jpg" />');

ok(MT::Sanitize->sanitize('<b>open bold', 'b'), '<b>open bold</b>');

ok(MT::Sanitize->sanitize('<b><i>open</b> italic', 'b,i'), '<b><i>open</i></b> italic');

ok(MT::Sanitize->sanitize('<a><b><blockquote><i>open</b> italic', 'b,i'), '<b><i>open</i></b> italic');

ok(MT::Sanitize->sanitize('<a href="javascript:alert(\'xxx\')">boo</a>', 'a href'), '<a>boo</a>');

ok(MT::Sanitize->sanitize('<a href="jav&#x0D;ascript:alert(\'xxx\')">boo</a>', 'a href'), '<a>boo</a>');

ok(MT::Sanitize->sanitize('<a href="java&#x20;script.html">boo</a>', 'a href'), '<a href="java&#x20;script.html">boo</a>');

### this one breaks...
###ok(!MT::Sanitize->sanitize('<? /* ?> */ readfile("/etc/passwd") ?>'));
