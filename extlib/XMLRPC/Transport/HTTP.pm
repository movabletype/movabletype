# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: HTTP.pm,v 1.2 2004/11/14 19:30:50 byrnereese Exp $
#
# ======================================================================

package XMLRPC::Transport::HTTP;

use strict;
use vars qw($VERSION);
#$VERSION = sprintf("%d.%s", map {s/_//g; $_} q$Name:  $ =~ /-(\d+)_([\d_]+)/);
$VERSION = $XMLRPC::Lite::VERSION;

use XMLRPC::Lite;
use SOAP::Transport::HTTP;

# ======================================================================

package XMLRPC::Transport::HTTP::CGI;

@XMLRPC::Transport::HTTP::CGI::ISA = qw(SOAP::Transport::HTTP::CGI);

sub initialize; *initialize = \&XMLRPC::Server::initialize;

sub make_fault { 
  local $SOAP::Constants::HTTP_ON_FAULT_CODE = 200;
  shift->SUPER::make_fault(@_);
}

sub make_response { 
  local $SOAP::Constants::DO_NOT_USE_CHARSET = 1;
  shift->SUPER::make_response(@_);
}

# ======================================================================

package XMLRPC::Transport::HTTP::Daemon;

@XMLRPC::Transport::HTTP::Daemon::ISA = qw(SOAP::Transport::HTTP::Daemon);

sub initialize; *initialize = \&XMLRPC::Server::initialize;
sub make_fault; *make_fault = \&XMLRPC::Transport::HTTP::CGI::make_fault;
sub make_response; *make_response = \&XMLRPC::Transport::HTTP::CGI::make_response; 

# ======================================================================

package XMLRPC::Transport::HTTP::Apache;

@XMLRPC::Transport::HTTP::Apache::ISA = qw(SOAP::Transport::HTTP::Apache);

sub initialize; *initialize = \&XMLRPC::Server::initialize;
sub make_fault; *make_fault = \&XMLRPC::Transport::HTTP::CGI::make_fault;
sub make_response; *make_response = \&XMLRPC::Transport::HTTP::CGI::make_response; 

# ======================================================================

1;

__END__

=head1 NAME

XMLRPC::Transport::HTTP - Server/Client side HTTP support for XMLRPC::Lite

=head1 SYNOPSIS

=over 4

=item Client

  use XMLRPC::Lite 
    proxy => 'http://localhost/', 
  # proxy => 'http://localhost/cgi-bin/xmlrpc.cgi', # local CGI server
  # proxy => 'http://localhost/',                   # local daemon server
  # proxy => 'http://login:password@localhost/cgi-bin/xmlrpc.cgi', # local CGI server with authentication
  ;

  print getStateName(1);

=item CGI server

  use XMLRPC::Transport::HTTP;

  my $server = XMLRPC::Transport::HTTP::CGI
    -> dispatch_to('methodName')
    -> handle
  ;

=item Daemon server

  use XMLRPC::Transport::HTTP;

  my $daemon = XMLRPC::Transport::HTTP::Daemon
    -> new (LocalPort => 80)
    -> dispatch_to('methodName')
  ;
  print "Contact to XMLRPC server at ", $daemon->url, "\n";
  $daemon->handle;

=back

=head1 DESCRIPTION

This class encapsulates all HTTP related logic for a XMLRPC server,
independent of what web server it's attached to. 
If you want to use this class you should follow simple guideline
mentioned above. 

=head2 PROXY SETTINGS

You can use any proxy setting you use with LWP::UserAgent modules:

 XMLRPC::Lite->proxy('http://endpoint.server/', 
                     proxy => ['http' => 'http://my.proxy.server']);

or

 $xmlrpc->transport->proxy('http' => 'http://my.proxy.server');

should specify proxy server for you. And if you use C<HTTP_proxy_user> 
and C<HTTP_proxy_pass> for proxy authorization SOAP::Lite should know 
how to handle it properly. 

=head2 COOKIE-BASED AUTHENTICATION

  use HTTP::Cookies;

  my $cookies = HTTP::Cookies->new(ignore_discard => 1);
    # you may also add 'file' if you want to keep them between sessions

  my $xmlrpc = XMLRPC::Lite->proxy('http://localhost/');
  $xmlrpc->transport->cookie_jar($cookies);

Cookies will be taken from response and provided for request. You may
always add another cookie (or extract what you need after response)
with HTTP::Cookies interface.

You may also do it in one line:

  $xmlrpc->proxy('http://localhost/', 
                 cookie_jar => HTTP::Cookies->new(ignore_discard => 1));

=head2 COMPRESSION

XMLRPC::Lite provides you option for enabling compression on wire (for HTTP 
transport only). Both server and client should support this capability, 
but this logic should be absolutely transparent for your application. 
Server will respond with encoded message only if client can accept it 
(client sends Accept-Encoding with 'deflate' or '*' values) and client 
has fallback logic, so if server doesn't understand specified encoding 
(Content-Encoding: deflate) and returns proper error code 
(415 NOT ACCEPTABLE) client will repeat the same request not encoded and 
will store this server in per-session cache, so all other requests will 
go there without encoding.

Having options on client and server side that let you specify threshold
for compression you can safely enable this feature on both client and 
server side.

Compression will be enabled on client side IF: threshold is specified AND
size of current message is bigger than threshold AND module Compress::Zlib
is available. Client will send header 'Accept-Encoding' with value 'deflate'
if threshold is specified AND module Compress::Zlib is available.

Server will accept compressed message if module Compress::Zlib is available,
and will respond with compressed message ONLY IF: threshold is specified AND
size of current message is bigger than threshold AND module Compress::Zlib
is available AND header 'Accept-Encoding' is presented in request.

=head1 DEPENDENCIES

 Crypt::SSLeay             for HTTPS/SSL
 HTTP::Daemon              for XMLRPC::Transport::HTTP::Daemon
 Apache, Apache::Constants for XMLRPC::Transport::HTTP::Apache

=head1 SEE ALSO

 See ::CGI, ::Daemon and ::Apache for implementation details.
 See examples/XMLRPC/* for examples.

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
