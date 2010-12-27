#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use lib qw( extlib lib plugins/WXRImporter/lib );

use_ok('HTML::Entities::Numbered');
use_ok('HTML::Entities::Numbered::Table');
use_ok('WXRImporter::Worker::Downloader');
use_ok('WXRImporter::WXRHandler');
use_ok('WXRImporter::Import');

done_testing;
