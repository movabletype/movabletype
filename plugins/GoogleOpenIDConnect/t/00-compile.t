#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More;
use MT::Test;

# Core module
use_ok('GoogleOpenIDConnect');
use_ok('GoogleOpenIDConnect::Auth::OIDC');
use_ok('GoogleOpenIDConnect::Auth::GoogleOIDC');

# L10N modules
use_ok('GoogleOpenIDConnect::L10N');
use_ok('GoogleOpenIDConnect::L10N::en_us');
use_ok('GoogleOpenIDConnect::L10N::ja');

done_testing();

