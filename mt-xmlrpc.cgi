#!/usr/bin/perl -w

# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

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
    $server->dispatch_to('blogger', 'metaWeblog', 'mt');
    $server->handle;
}
