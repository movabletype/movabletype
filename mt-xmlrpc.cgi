#!/usr/bin/perl -w

# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: mt-xmlrpc.cgi 3531 2009-03-12 09:11:52Z fumiakiy $

use strict;
my $MT_DIR;
sub BEGIN {
    require File::Spec;
    if (!($MT_DIR = $ENV{MT_HOME})) {
        if ($0 =~ m!(.*[/\\])!) {
            $MT_DIR = $1;
        } else {
            $MT_DIR = './';
        }
        $ENV{MT_HOME} = $MT_DIR;
    }
    unshift @INC, File::Spec->catdir($MT_DIR, 'lib');
    unshift @INC, File::Spec->catdir($MT_DIR, 'extlib');
}

use XMLRPC::Transport::HTTP;
use MT::XMLRPCServer;

$MT::XMLRPCServer::MT_DIR = $MT_DIR;

use vars qw($server);
{
    ## Shut off warnings, because SOAP::Lite 0.55 causes some
    ## unitialized value warnings that seem to be connected to
    ## the soap->action
    local $SIG{__WARN__} = sub { };
    $server = XMLRPC::Transport::HTTP::CGI->new;
    $server->dispatch_to('blogger', 'metaWeblog', 'mt', 'wp');
    $server->handle;
}
