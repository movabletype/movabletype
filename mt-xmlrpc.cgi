#!/usr/bin/env perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
my $MT_DIR;

sub BEGIN {
    require File::Spec;
    if ( !( $MT_DIR = $ENV{MT_HOME} ) ) {
        if ( $0 =~ m!(.*[/\\])! ) {
            $MT_DIR = $1;
        }
        else {
            $MT_DIR = './';
        }
        $ENV{MT_HOME} = $MT_DIR;
    }
    unshift @INC, File::Spec->catdir( $MT_DIR, 'lib' );
    unshift @INC, File::Spec->catdir( $MT_DIR, 'extlib' );
}

use XMLRPC::Transport::HTTP;
use XMLRPC::Transport::HTTP::FCGI;
use MT::XMLRPCServer;

$MT::XMLRPCServer::MT_DIR = $MT_DIR;

use vars qw($server);
{
    ## Shut off warnings, because SOAP::Lite 0.55 causes some
    ## unitialized value warnings that seem to be connected to
    ## the soap->action
    local $SIG{__WARN__} = sub { };

    my $not_fast_cgi = 0;
    $not_fast_cgi ||= exists $ENV{$_}
        for qw(HTTP_HOST GATEWAY_INTERFACE SCRIPT_FILENAME SCRIPT_URL);
    $server
        = $not_fast_cgi
        ? XMLRPC::Transport::HTTP::CGI->new
        : do {

        # Avoid imitating nph- cgi for IIS in SOAP::Transport::HTTP::CGI,
        # because imitating makes some HTTP status code incorrect.
        {
            my $handle = \&SOAP::Transport::HTTP::CGI::handle;
            no warnings;
            *SOAP::Transport::HTTP::CGI::handle = sub {
                local $ENV{SERVER_SOFTWARE};
                $handle->(@_);
            };
        }

        MT::XMLRPCServer::Util::mt_new;
        XMLRPC::Transport::HTTP::FCGI->new;
        };
    $server->dispatch_with( {
        'mt'         => 'MT::XMLRPCServer',
        'blogger'    => 'blogger',
        'metaWeblog' => 'metaWeblog',
        'wp'         => 'wp',
    } );
    $server->on_action(sub {
        my ($action, $method_uri, $method_name) = @_;

        my $class =
                $server->dispatch_with->{$method_uri}
            || $server->dispatch_with->{ $action || '' }
            || defined($action) && $action =~ /^"(.+)"$/ && $server->dispatch_with->{$1};

        die "Denied access to method ($method_name)\n"
            unless $class && $class->can($method_name);
    });
    $server->handle;
}
