#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 4;

use lib qw( lib plugins/MultiBlog plugins/MultiBlog/lib );

require_ok ( 'multiblog.pl' );
require_ok ( 'MultiBlog::Tags::Include' );
require_ok ( 'MultiBlog::Tags::LocalBlog' );
require_ok ( 'MultiBlog::Tags::MultiBlog' );
