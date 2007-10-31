#!perl
use strict;
use warnings;

use MT::Test tests => 4;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

use_ok('MT::App::FeedsSidebar');
use_ok('MT::Feeds::Lite::CacheMgr');
use_ok('MT::Feeds::Find');
use_ok('MT::Feeds::Lite');
