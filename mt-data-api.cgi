#!/usr/bin/perl -w

# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';

BEGIN {
    require MT::Util;
    if ( !MT::Util::check_fast_cgi() ) {
        require MT::DataAPI::ResponseCache;
        if ( my $response = MT::DataAPI::ResponseCache->get ) {
            print $response->{rendered_headers};
            print $response->{body};
            exit();
        }
        MT::DataAPI::ResponseCache->disable unless $ENV{MOD_PERL};
    }
}

use MT::Bootstrap App => 'MT::App::DataAPI';
