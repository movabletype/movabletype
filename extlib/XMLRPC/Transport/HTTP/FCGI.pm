package XMLRPC::Transport::HTTP::FCGI;
use 5.008005;
use strict;
use warnings;

use SOAP::Transport::HTTP;
use XMLRPC::Lite;
use XMLRPC::Transport::HTTP;

our $VERSION = "0.01";
our @ISA = qw(SOAP::Transport::HTTP::FCGI);

sub initialize; *initialize = \&XMLRPC::Server::initialize;
sub make_fault; *make_fault = \&XMLRPC::Transport::HTTP::CGI::make_fault;
sub make_response; *make_response = \&XMLRPC::Transport::HTTP::CGI::make_response;

1;
__END__

=encoding utf-8

=head1 NAME

XMLRPC::Transport::HTTP::FCGI - A FastCGI implementation of server interface to HTTP transport for XMLRPC::Lite

=head1 SYNOPSIS

  use XMLRPC::Transport::HTTP::FCGI;

  my $server = XMLRPC::Transport::HTTP::FCGI
      -> dispatch_to('methodName')
      -> handle
  ;

=head1 DESCRIPTION

XMLRPC::Transport::HTTP::FCGI is a FastCGI implementation of server interface
to HTTP transport for XMLRPC::Lite.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Copyright 2013, Six Apart Ltd. All rights reserved.

=cut

