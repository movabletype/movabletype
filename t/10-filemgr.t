#!/usr/bin/perl
# $Id: 10-filemgr.t 2562 2008-06-12 05:12:23Z bchoate $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Temp;

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
is($copy, Encode::encode_utf8($fmgr->get_data($File)), "get_data($File)");

ok(-f $File, "$File is a regular file");
ok($fmgr->delete($File), "delete($File)");
ok(!-f $File, "$File is gone");

my ($fh, $filename) = File::Temp::tempfile('XXXXXX', UNLINK => 1);
$fmgr->rename( $filename, $filename );
ok( -f $filename, '$file should not remove' );

done_testing();
