#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 13;

use MT;
use MT::Test;
use MT::FileMgr;

my $File = 'test.file';
my $String = 'testing';

my $fmgr = MT::FileMgr->new('Local');
isa_ok($fmgr, 'MT::FileMgr');
ok($fmgr->can_write('.'), 'can_write');
ok($fmgr->content_is_updated($File, \$String), "content_is_updated($File,$String)");

ok($fmgr->put_data($String, $File), "put_data($String, $File)");
ok(!$fmgr->content_is_updated($File, \$String), "content_is_updated($File,$String)");
my $str2 = $String . 'bar';
ok($fmgr->content_is_updated($File, \$str2), "content_is_updated($File,$str2)");
ok($str2, $String . 'bar');

my($copy) = $String = "bj淡rn";
ok($fmgr->put_data($String, $File), "put_data($String, $File)");
ok(!$fmgr->content_is_updated($File, \$String), "content_is_updated($File,$String)");
is($copy, $String, "$copy is $String");

ok(-f $File, "$File is a regular file");
ok($fmgr->delete($File), "delete($File)");
ok(!-f $File, "$File is gone");
