# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: TCP.pm 374 2010-05-14 08:12:25Z kutterma $
#
# ======================================================================

package XMLRPC::Transport::TCP;

use strict;

our $VERSION = 0.712;
use XMLRPC::Lite;


use SOAP::Transport::TCP;

# ======================================================================

package XMLRPC::Transport::TCP::Server;

@XMLRPC::Transport::TCP::Server::ISA = qw(SOAP::Transport::TCP::Server);

sub initialize; *initialize = \&XMLRPC::Server::initialize;

# ======================================================================

1;

__END__

=head1 NAME

XMLRPC::Transport::TCP - Server/Client side TCP support for XMLRPC::Lite

=head1 SYNOPSIS

  use XMLRPC::Transport::TCP;

  my $daemon = XMLRPC::Transport::TCP::Server
    -> new (LocalAddr => 'localhost', LocalPort => 82, Listen => 5, Reuse => 1)
    -> objects_by_reference(qw(My::PersistentIterator My::SessionIterator My::Chat))
    -> dispatch_to('/Your/Path/To/Deployed/Modules', 'Module::Name', 'Module::method');
  print "Contact to XMLRPC server at ", join(':', $daemon->sockhost, $daemon->sockport), "\n";
  $daemon->handle;

=head1 DESCRIPTION

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
