#!/usr/bin/perl

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


use lib 'extlib', 'lib', 't/lib';

use MT;
use MT::Test qw(:db);

use Test::More;

my $mt = MT->instance;
my $fileinfo = $mt->model('fileinfo');
my $template = $mt->model('template');
$fileinfo->remove_all;

my $a_template = $template->load({'type' => {not => 'backup'}});

my $a_fileinfo = $fileinfo->new;
$a_fileinfo->blog_id($a_template->blog_id);
$a_fileinfo->template_id($a_template->id);
$a_fileinfo->save or die;


## Cleanup

ok(eval{ $fileinfo->cleanup; 1 }, 'Do cleanup.');
is($fileinfo->count, 1, 'Any record is not removed yet.');

$a_template->type('backup');
$a_template->save;

ok(eval{ $fileinfo->cleanup; 1 }, 'Do cleanup after backup.');
is($fileinfo->count, 0, 'A record for backuped template is removed.');


done_testing();
