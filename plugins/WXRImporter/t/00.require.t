#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::More;

use lib qw( extlib lib plugins/WXRImporter/lib );

use_ok('HTML::Entities::Numbered');
use_ok('HTML::Entities::Numbered::Table');
use_ok('WXRImporter::Worker::Downloader');
use_ok('WXRImporter::WXRHandler');
use_ok('WXRImporter::Import');

done_testing;
