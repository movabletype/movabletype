# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: POP3.pm 51 2004-11-14 19:30:50Z byrnereese $
#
# ======================================================================

package XMLRPC::Transport::POP3;

use strict;
use vars qw($VERSION);
#$VERSION = sprintf("%d.%s", map {s/_//g; $_} q$Name$ =~ /-(\d+)_([\d_]+)/);
$VERSION = $XMLRPC::Lite::VERSION;

use XMLRPC::Lite;
use SOAP::Transport::POP3;

# ======================================================================

package XMLRPC::Transport::POP3::Server;

@XMLRPC::Transport::POP3::Server::ISA = qw(SOAP::Transport::POP3::Server);

sub initialize; *initialize = \&XMLRPC::Server::initialize;

# ======================================================================

1;

__END__

=head1 NAME

XMLRPC::Transport::POP3 - Server side POP3 support for XMLRPC::Lite

=head1 SYNOPSIS

  use XMLRPC::Transport::POP3;

  my $server = XMLRPC::Transport::POP3::Server
    -> new('pop://pop.mail.server')
    # if you want to have all in one place
    # -> new('pop://user:password@pop.mail.server') 
    # or, if you have server that supports MD5 protected passwords
    # -> new('pop://user:password;AUTH=+APOP@pop.mail.server') 
    # specify path to My/Examples.pm here
    -> dispatch_to('/Your/Path/To/Deployed/Modules', 'Module::Name', 'Module::method') 
  ;
  # you don't need to use next line if you specified your password in new()
  $server->login('user' => 'password') or die "Can't authenticate to POP3 server\n";

  # handle will return number of processed mails
  # you can organize loop if you want
  do { $server->handle } while sleep 10;

  # you may also call $server->quit explicitly to purge deleted messages

=head1 DESCRIPTION

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
