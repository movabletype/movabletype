#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More tests => 7;

use MT;
use MT::Util;

MT->set_language('en_US');

is(MT::Util::iso_dirify('Siegfried & Roy'),
                        'siegfried_roy',
                        'siegfried_roy');
is(MT::Util::iso_dirify('Cauchy-Schwartz Inequality'),
                        'cauchyschwartz_inequality',
                        'cauchyschwartz_inequality');
is(MT::Util::utf8_dirify('Siegfried & Roy'),
                         'siegfried_roy',
                         'siegfried_roy');
is(MT::Util::utf8_dirify('Cauchy-Schwartz Inequality'),
                         'cauchyschwartz_inequality',
                         'cauchyschwartz_inequality');
is( MT::Util::iso_dirify('Some & Something'), 
   MT::Util::utf8_dirify('Some & Something'),
                         'Some & Something');
is( MT::Util::iso_dirify('Cauchy-Schwartz Inequality'),
   MT::Util::utf8_dirify('Cauchy-Schwartz Inequality'),
                         'Cauchy-Schwartz Inequality');
is(MT::Util::utf8_dirify("M\303\272m"), 'mum', 'mum');

