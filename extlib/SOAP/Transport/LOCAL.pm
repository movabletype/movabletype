# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: LOCAL.pm,v 1.3 2004/11/14 19:30:50 byrnereese Exp $
#
# ======================================================================

package SOAP::Transport::LOCAL;

use strict;
use vars qw($VERSION);
#$VERSION = sprintf("%d.%s", map {s/_//g; $_} q$Name:  $ =~ /-(\d+)_([\d_]+)/);
$VERSION = $SOAP::Lite::VERSION;

# ======================================================================

package SOAP::Transport::LOCAL::Client;

use vars qw(@ISA);
@ISA = qw(SOAP::Client SOAP::Server);

sub new { 
  my $self = shift;

  unless (ref $self) {
    my $class = ref($self) || $self;
    my(@params, @methods);
    while (@_) { $class->can($_[0]) ? push(@methods, shift() => shift) : push(@params, shift) }
    $self = $class->SUPER::new(@params);
    $self->is_success(1);     # it's difficult to fail in this module
    $self->dispatch_to(@INC);
    while (@methods) { my($method, $params) = splice(@methods,0,2);
      $self->$method(ref $params eq 'ARRAY' ? @$params : $params) 
    }
  }
  return $self;
}

sub send_receive {
  my($self, %parameters) = @_;
  my($envelope, $endpoint, $action) = 
    @parameters{qw(envelope endpoint action)};

  SOAP::Trace::debug($envelope);
  my $response = $self->SUPER::handle($envelope);
  SOAP::Trace::debug($response);

  $response;
}

# ======================================================================

1;

__END__
