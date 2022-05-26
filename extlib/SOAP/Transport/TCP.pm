# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: TCP.pm 384 2011-08-16 17:08:08Z kutterma $
#
# ======================================================================

package SOAP::Transport::TCP;

use strict;

our $VERSION = '1.27'; # VERSION

use URI;
use IO::Socket;
use IO::Select;
use IO::SessionData;

# ======================================================================

package # hide from PAUSE
    URI::tcp; # ok, let's do 'tcp://' scheme

our $VERSION = 0.715;

require URI::_server;
@URI::tcp::ISA=qw(URI::_server);

# ======================================================================

package SOAP::Transport::TCP::Client;

our $VERSION = 0.715;

use vars qw(@ISA);
require SOAP::Lite;
@ISA = qw(SOAP::Client);

sub DESTROY { SOAP::Trace::objects('()') }

sub new {
  my $self = shift;

  unless (ref $self) {
    my $class = ref($self) || $self;
    my(@params, @methods);
    while (@_) { $class->can($_[0]) ? push(@methods, shift() => shift) : push(@params, shift) }
    $self = bless {@params} => $class;
    while (@methods) { my($method, $params) = splice(@methods,0,2);
      $self->$method(ref $params eq 'ARRAY' ? @$params : $params)
    }
    # use SSL if there is any parameter with SSL_* in the name
    $self->SSL(1) if !$self->SSL && grep /^SSL_/, keys %$self;
    SOAP::Trace::objects('()');
  }
  return $self;
}

sub SSL {
  my $self = shift->new;
  @_ ? ($self->{_SSL} = shift, return $self) : return $self->{_SSL};
}

sub io_socket_class { shift->SSL ? 'IO::Socket::SSL' : 'IO::Socket::INET' }

sub syswrite {
  my($self, $sock, $data) = @_;

  my $timeout = $sock->timeout;

  my $select = IO::Select->new($sock);

  my $len = length $data;
  while (length $data > 0) {
    return unless $select->can_write($timeout);
    local $SIG{PIPE} = 'IGNORE';
    # added length() to make it work on Mac. Thanks to Robin Fuller <rfuller@broadjump.com>
    my $wc = syswrite($sock, $data, length($data));
    if (defined $wc) {
      substr($data, 0, $wc) = '';
    } elsif (!IO::SessionData::WOULDBLOCK($!)) {
      return;
    }
  }
  return $len;
}

sub sysread {
  my($self, $sock) = @_;

  my $timeout = $sock->timeout;
  my $select = IO::Select->new($sock);

  my $result = '';
  my $data;
  while (1) {
    return unless $select->can_read($timeout);
    my $rc = sysread($sock, $data, 4096);
    if ($rc) {
      $result .= $data;
    } elsif (defined $rc) {
      return $result;
    } elsif (!IO::SessionData::WOULDBLOCK($!)) {
      return;
    }
  }
}

sub send_receive {
  my($self, %parameters) = @_;
  my($envelope, $endpoint, $action) =
    @parameters{qw(envelope endpoint action)};

  $endpoint ||= $self->endpoint;
  warn "URLs with 'tcp:' scheme are deprecated. Use 'tcp://'. Still continue\n"
    if $endpoint =~ s!^tcp:(//)?!tcp://!i && !$1;
  my $uri = URI->new($endpoint);

  local($^W, $@, $!);
  my $socket = $self->io_socket_class;
  eval "require $socket" or Carp::croak $@ unless UNIVERSAL::can($socket => 'new');
  my $sock = $socket->new (
    PeerAddr => $uri->host, PeerPort => $uri->port, Proto => $uri->scheme, %$self
  );

  SOAP::Trace::debug($envelope);

  # bytelength hack. See SOAP::Transport::HTTP.pm for details.
  my $bytelength = SOAP::Utils::bytelength($envelope);
  $envelope = pack('C0A*', $envelope)
    if !$SOAP::Constants::DO_NOT_USE_LWP_LENGTH_HACK && length($envelope) != $bytelength;

  my $result;
  if ($sock) {
    $sock->blocking(0);
    $self->syswrite($sock, $envelope)  and
     $sock->shutdown(1)                and # stop writing
     $result = $self->sysread($sock);
  }

  SOAP::Trace::debug($result);

  my $code = $@ || $!;

  $self->code($code);
  $self->message($code);
  $self->is_success(!defined $code || $code eq '');
  $self->status($code);

  return $result;
}

# ======================================================================

package SOAP::Transport::TCP::Server;

use IO::SessionSet;

use Carp ();
use vars qw($AUTOLOAD @ISA);
@ISA = qw(SOAP::Server);

our $VERSION = 0.715;

sub DESTROY { SOAP::Trace::objects('()') }

sub new {
  my $self = shift;

  unless (ref $self) {
    my $class = ref($self) || $self;

    my(@params, @methods);
    while (@_) { $class->can($_[0]) ? push(@methods, shift() => shift) : push(@params, shift) }
    $self = $class->SUPER::new(@methods);

    # use SSL if there is any parameter with SSL_* in the name
    $self->SSL(1) if !$self->SSL && grep /^SSL_/, @params;

    my $socket = $self->io_socket_class;
    eval "require $socket" or Carp::croak $@ unless UNIVERSAL::can($socket => 'new');
    $self->{_socket} = $socket->new(Proto => 'tcp', @params)
      or Carp::croak "Can't open socket: $!";

    SOAP::Trace::objects('()');
  }
  return $self;
}

sub SSL {
  my $self = shift->new;
  @_ ? ($self->{_SSL} = shift, return $self) : return $self->{_SSL};
}

sub io_socket_class { shift->SSL ? 'IO::Socket::SSL' : 'IO::Socket::INET' }

sub AUTOLOAD {
  my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::') + 2);
  return if $method eq 'DESTROY';

  no strict 'refs';
  *$AUTOLOAD = sub { shift->{_socket}->$method(@_) };
  goto &$AUTOLOAD;
}

sub handle {
  my $self = shift->new;
  my $sock = $self->{_socket};
  my $session_set = IO::SessionSet->new($sock);
  my %data;
  while (1) {
    my @ready = $session_set->wait($sock->timeout);
    for my $session (grep { defined } @ready) {
      my $data;
      if (my $rc = $session->read($data, 4096)) {
        $data{$session} .= $data if $rc > 0;
      } else {
        $session->write($self->SUPER::handle(delete $data{$session}));
        $session->close;
      }
    }
  }
}

# ======================================================================

1;

__END__


=head1 NAME

SOAP::Transport::TCP - TCP Transport Support for SOAP::Lite

=head2 SOAP::Transport::TCP

The classes provided by this module implement direct TCP/IP communications methods for both clients and servers.

The connections don't use HTTP or any other higher-level protocol. These classes are selected when the client or server object being created uses an endpoint URI that starts with tcp://. Both client and server classes support using Secure Socket Layer if it is available. If any of the parameters to a new method from either of the classes begins with SSL_ (such as SSL_server in place of Server), the class attempts to load the IO::Socket::SSL package and use it to create socket objects.

Both of the following classes catch methods that are intended for the socket objects and pass them along, allowing calls such as $client->accept( ) without including the socket class in the inheritance tree.

=head3 SOAP::Transport::TCP::Client

Inherits from: L<SOAP::Client>.

The TCP client class defines only two relevant methods beyond new and send_receive. These methods are:

=over

=item SSL(I<optional new boolean value>)

    if ($client->SSL) # Execute only if in SSL mode

Reflects the attribute that denotes whether the client object is using SSL sockets for communications.

=item io_socket_class

    ($client->io_socket_class)->new(%options);

Returns the name of the class to use when creating socket objects for internal use in communications. As implemented, it returns one of IO::Socket::INET or IO::Socket::SSL, depending on the return value of the previous SSL method.

=back

If an application creates a subclass that inherits from this client class, either method is a likely target for overloading.

The new method behaves identically to most other classes, except that it detects the presence of SSL-targeted values in the parameter list and sets the SSL method appropriately if they are present.

The send_receive method creates a socket of the appropriate class and connects to the configured endpoint. It then sets the socket to nonblocking I/O, sends the message, shuts down the client end of the connection (preventing further writing), and reads the response back from the server. The socket object is discarded after the response and
appropriate status codes are set on the client object.

=head3 SOAP::Transport::TCP::Server

Inherits from: L<SOAP::Server>.

The server class also defines the same two additional methods as in the client class:

=over

=item SSL(I<optional new boolean value>)

    if ($client->SSL) # Execute only if in SSL mode

Reflects the attribute that denotes whether the client object is using SSL sockets for communications.

=item io_socket_class

    ($client->io_socket_class)->new(%options);

Returns the name of the class to use when creating socket objects for internal use in communications. As implemented, it returns one of IO::Socket::INET or IO::Socket::SSL, depending on the return value of the previous SSL method. The new method also manages the automatic selection of SSL in the same fashion as the client class does.

The handle method in this server implementation isn't designed to be called once with each new request. Rather, it is called with no arguments, at which time it enters into an infinite loop of waiting for a connection, reading the request, routing the request and sending back the serialized response. This continues until the process itself is interrupted by an untrapped signal or similar means.

=back

=head1 COPYRIGHT

Copyright (C) 2000-2004 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Written by Paul Kulchenko.

Split from SOAP::Lite and SOAP-Transport-TCP packaging by Martin Kutter

=cut
