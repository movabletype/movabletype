#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::BackupRestore::Session;

$test_env->prepare_fixture('db');

my $sess = MT::BackupRestore::Session->start('name', 'id');
is(ref $sess->sess, 'MT::Session', 'right class');

subtest 'progress' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    $sess->progress(['msg1'], 1);
    is(@{ $sess->progress }, 1, 'right number');

    my $progress;
    $sess->progress(['msg2'], 1);
    $progress = $sess->progress;
    is(@$progress, 2, 'right number');
    is_deeply($progress, [{ 'message' => 'msg1' }, { 'message' => 'msg2' }], 'right structure');

    $sess->progress(['msg3']);
    $progress = $sess->progress;
    is(@$progress, 1, 'right number');
    is_deeply($progress, [{ 'message' => 'msg3' }], 'right structure');

    $sess->progress(['msg4', 'id']);
    $progress = $sess->progress;
    is_deeply($progress, [{ 'message' => 'msg4', id => 'id' }], 'right structure');

    $sess->progress(['msg5', 'id2'], 1);
    $progress = $sess->progress;
    is_deeply($progress, [{ 'message' => 'msg4', id => 'id' }, { 'message' => 'msg5', id => 'id2' }], 'right structure');

    $sess->progress([['msg6'],['msg7']]);
    $progress = $sess->progress;
    is_deeply($progress, [{ 'message' => 'msg6' }, { 'message' => 'msg7' }], 'right structure');
};

subtest 'get_offset_progress' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    $sess->progress([['a'], ['b'], ['c']]);
    is_deeply(
        $sess->get_offset_progress,
        [{ message => 'a' }, { message => 'b' }, { message => 'c' }], 'right offset data'
    );
    $sess->progress([['d'], ['e'], ['f']], 1);
    is_deeply(
        $sess->get_offset_progress,
        [{ message => 'd' }, { message => 'e' }, { message => 'f' }], 'right offset data'
    );
    is_deeply($sess->get_offset_progress, [], 'right offset data');
};

subtest 'urls' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    my $urls;
    $sess->urls(['http://example.com/1']);
    $urls = $sess->urls;
    is(scalar @$urls, 1, 'right number');
    $sess->urls(['http://example.com/2']);
    $sess->urls(['http://example.com/3'], 1);
    $urls = $sess->urls;
    is(scalar @$urls, 2,                      'right number');
    is($urls->[0],    'http://example.com/2', 'right url');
};

subtest 'file' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    $sess->file('1.png');
    is_deeply($sess->file, { '1.png' => 1 }, 'file registered');
    $sess->file('2.png');
    is_deeply($sess->file, { '1.png' => 1, '2.png' => 1 }, 'right structure');
    is($sess->check_file('1.png'), '1.png', 'file registered');
    is($sess->check_file('1.png'), undef,   'file unregistered');
};

subtest 'asset_ids' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    my $asset_ids;
    $sess->asset_ids(['asset1']);
    $asset_ids = $sess->asset_ids;
    is(scalar @$asset_ids, 1, 'right number');
    $sess->asset_ids(['asset2']);
    $sess->asset_ids(['asset3'], 1);
    $asset_ids = $sess->asset_ids;
    is(scalar @$asset_ids, 2,        'right number');
    is($asset_ids->[0],    'asset2', 'right asset id');
};

subtest 'dir' => sub {
    my $sess = MT::BackupRestore::Session->start('name', 'id');
    $sess->dir('/path/to/dir1');
    my $dir1 = $sess->dir;
    is($dir1, '/path/to/dir1', 'right path');
    ok(-d $dir1, 'directory exists');

    my $sess2 = MT::BackupRestore::Session->start('name', 'id');
    ok(!-d $dir1, 'directory deleted');
    $sess2->dir('/path/to/dir2');
    my $dir2 = $sess2->dir;
    ok(-d $dir2, 'directory exists');
    $sess2->purge(-1);
    ok(!-d $dir2, 'directory deleted');
};

done_testing;
