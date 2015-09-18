#!/usr/bin/perl

use strict;
use warnings;

use lib qw( lib extlib t/lib );

use MT::Test;
use Test::More;
use MT;

my $mt = MT->instance;
ok( $mt->component('GoogleOpenIDConnect'), 'Load plugin' );
ok( $mt->registry('commenter_authenticators')->{'GoogleOpenIDConnect'},
    'commenter_authenticators' );
ok( $mt->registry('web_services')->{'GoogleOpenIDConnect'}, 'web_services' );

done_testing();

