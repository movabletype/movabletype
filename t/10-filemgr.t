#!/usr/bin/perl -w
use strict;

use Test;
use MT::FileMgr;
use MT;

BEGIN { plan tests => 12 }

my $File = "test.file";
my $String = "testing";

my $fmgr = MT::FileMgr->new('Local');
ok($fmgr->can_write('.'));
ok($fmgr->content_is_updated($File, \$String));

ok($fmgr->put_data($String, $File));
ok(!$fmgr->content_is_updated($File, \$String));
my $str2 = $String . 'bar';
ok($fmgr->content_is_updated($File, \$str2));
ok($str2, $String . 'bar');

my($copy) = $String = "bjørn";
ok($fmgr->put_data($String, $File));
ok(!$fmgr->content_is_updated($File, \$String));
ok($copy eq $String);

ok(-f $File);
ok($fmgr->delete($File));
ok(!-f $File);
