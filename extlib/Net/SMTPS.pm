# ====
#  SSL/STARTTLS extention for G.Barr's Net::SMTP.
#    plus, enable arbitrary SMTP auth mechanism selection.
#      IO::Socket::SSL (also Net::SSLeay openssl),
#      Authen::SASL, MIME::Base64 should be installed.
#
package Net::SMTPS;

use vars qw ( $VERSION @ISA );

$VERSION = '0.10';

use strict;
use base qw ( Net::SMTP );
use Net::Cmd;  # import CMD_OK, CMD_MORE, ...
use Net::Config;

eval {
    require IO::Socket::IP
	and unshift @ISA, 'IO::Socket::IP';
} or eval {
    require IO::Socket::INET6
	and unshift @ISA, 'IO::Socket::INET6';
} or do {
    require IO::Socket::INET
	and unshift @ISA, 'IO::Socket::INET';
};

# Override to support SSL/TLS.
sub new {
  my $self = shift;
  my $type = ref($self) || $self;
  my ($host, %arg);
  if (@_ % 2) {
      $host = shift;
      %arg  = @_;
  }
  else {
      %arg  = @_;
      $host = delete $arg{Host};
  }
  my $ssl = delete $arg{doSSL};
  if ($ssl =~ /ssl/i) {
      $arg{Port} ||= 465;
  }

  my $hosts = defined $host ? $host : $NetConfig{smtp_hosts};
  my $obj;

  # eliminate IO::Socket::SSL from @ISA for multiple call of new.
  @ISA = grep { !/IO::Socket::SSL/ } @ISA;

  my %_args = map { +"$_" => $arg{$_} } grep {! /^SSL/} keys %arg;

  my $h;
  $_args{PeerPort} = $_args{Port} || 'smtp(25)';
  $_args{Proto} = 'tcp';
  $_args{Timeout} = defined $_args{Timeout} ? $_args{Timeout} : 120;

  foreach $h (@{ref($hosts) ? $hosts : [$hosts]}) {
      $_args{PeerAddr} = ($host = $h);

      #if ($_args{Debug}) {
	#  foreach my $i (keys %_args) {
	#     print STDERR "$type>>> arg $i: $_args{$i}\n";
	#  }
      #}

      $obj = $type->SUPER::new(
	  %_args
      )
      and last;
  }

  return undef
    unless defined $obj;

  $obj->autoflush(1);

  $obj->debug(exists $arg{Debug} ? $arg{Debug} : undef);

  ${*$obj}{'net_smtp_arg'} = \%arg;

# OverSSL
  if (defined($ssl) && $ssl =~ /ssl/i) {
    $obj->ssl_start()
      or do {
	$obj->set_status(500, ["Cannot start SSL"]);
	$obj->close;
	return undef;
      };
  }

  unless ($obj->response() == CMD_OK) {
    $obj->close();
    return undef;
  }

  ${*$obj}{'net_smtp_exact_addr'} = $arg{ExactAddresses};
  ${*$obj}{'net_smtp_host'}       = $host;

  (${*$obj}{'net_smtp_banner'}) = $obj->message;
  (${*$obj}{'net_smtp_domain'}) = $obj->message =~ /\A\s*(\S+)/;

  unless ($obj->hello($arg{Hello} || "")) {
    $obj->close();
    return undef;
  }

# STARTTLS
  if (defined($ssl) && $ssl =~ /starttls/i && defined($obj->supports('STARTTLS')) ) {
      #123006 $obj->supports('STARTTLS') returns '' issue.
      unless ($obj->starttls()) {
	  return undef;
      }
      $obj->hello($arg{Hello} || "");
  }

  $obj;
}

sub ssl_start {
    my $self = shift;
    my $type = ref($self);
    my %arg = %{ ${*$self}{'net_smtp_arg'} };
    my %ssl_args = map { +"$_" => $arg{$_} } grep {/^SSL/} keys %arg;

    eval {
      require IO::Socket::SSL;
    } or do {
      $self->set_status(500, ["Need working IO::Socket::SSL"]);
      $self->close;
      return undef;
    };

    my $ssl_debug = (exists $arg{Debug} ? $arg{Debug} : undef);
    $ssl_debug = (exists $arg{Debug_SSL} ? $arg{Debug_SSL} : $ssl_debug);
    
    local $IO::Socket::SSL::DEBUG = $ssl_debug; 
     
    (unshift @ISA, 'IO::Socket::SSL'
     and IO::Socket::SSL->start_SSL($self, %ssl_args, @_)
     and $self->isa('IO::Socket::SSL')
     and bless $self, $type     # re-bless 'cause IO::Socket::SSL blesses himself.
    ) or return undef;
}

sub starttls {
    my $self = shift;
    (
     $self->_STARTTLS()
     and $self->ssl_start(@_)
    ) or do {
	$self->set_status(500, ["Cannot start SSL session"]);
	$self->close();
	return undef;
    };
}


# Override to specify a certain auth mechanism.
sub auth {
    my ($self, $username, $password, $mech) = @_;

    if ($mech) {
	$self->debug_print(1, "AUTH-my favorite: ". $mech . "\n") if $self->debug;

	my @cl_mech = split /\s+/, $mech;
	my @matched = ();
	if (exists ${*$self}{'net_smtp_esmtp'}->{'AUTH'}) {
	    my $sv = ${*$self}{'net_smtp_esmtp'}->{'AUTH'};
	    $self->debug_print(1, "AUTH-server offerred: ". $sv . "\n") if $self->debug;

	    foreach my $i (@cl_mech) {
		if (index($sv, $i) >= 0 && !grep(/$i/i, @matched)) {
		    push @matched, uc($i);
		}
	    }
	}
	if (@matched) {
	    ## override AUTH mech as specified.
	    ## if multiple mechs are specified, priority is still up to Authen::SASL module.
	    ${*$self}{'net_smtp_esmtp'}->{'AUTH'} = join " ", @matched;
	    $self->debug_print(1, "AUTH-negotiated: ". ${*$self}{'net_smtp_esmtp'}->{'AUTH'} . "\n") if $self->debug;
	}
    }
    $self->SUPER::auth($username, $password);
}


# Fix #121006 no timeout issue.
sub getline {
    my $self = shift;
    $self->Net::Cmd::getline(@_);
}

sub _STARTTLS { shift->command("STARTTLS")->response() == CMD_OK }

1;

__END__

=head1 NAME

Net::SMTPS - SSL/STARTTLS support for Net::SMTP

=head1 SYNOPSYS

    use Net::SMTPS;

    my $ssl = 'starttls';   # 'ssl' / 'starttls' / undef

    my $smtp = Net::SMTPS->new("smtp.example.com", Port => 587, doSSL => $ssl);

=head1 DESCRIPTION

This module implements a wrapper for Net::SMTP, enabling over-SSL/STARTTLS support.
This module inherits most of all the methods from Net::SMTP(2.X). You may use all
the friendly options that came bundled with Net::SMTP.
You can control the SSL usage with the options of new() constructor method.
'doSSL' option is the switch, and, If you would like to control detailed SSL settings,
you can set SSL_* options that are brought from IO::Socket::SSL. Please see the
document of IO::Socket::SSL about these options detail.

Just one method difference from the Net::SMTP, you can select SMTP AUTH mechanism
as the third option of auth() method.

As of Version 3.10 of Net::SMTP(libnet) includes SSL/STARTTLS capabilities, so
this wrapper module's significance disappareing.

=head1 CONSTRUCTOR

=over 4

=item new ( [ HOST ] [, OPTIONS ] )

A few options added to Net::SMTP(2.X).

B<doSSL> { C<ssl> | C<starttls> | undef } - to specify SSL connection type.
C<ssl> makes connection wrapped with SSL, C<starttls> uses SMTP command C<STARTTLS>.

=back

=head1 METHODS

Most of all methods of Net::SMTP are inherited as is, except auth().


=over 4

=item auth ( USERNAME, PASSWORD [, AUTHMETHOD])

Attempt SASL authentication through Authen::SASL module. AUTHMETHOD is your required
method of authentication, like 'CRAM-MD5', 'LOGIN', ... etc. If your selection does
not match the server-offerred AUTH mechanism, authentication negotiation may fail.

=item starttls ( SSLARGS )

Upgrade existing plain connection to SSL.

=back

=head1 BUGS

Constructor option 'Debug => (N)' (for Net::Cmd) also sets $IO::Socket::SSL::DEBUG when SSL is enabled. You can set 'Debug_SSL => {0-3}' separately.


=head1 SEE ALSO

L<Net::SMTP>,
L<IO::Socket::SSL>,
L<Authen::SASL>

=head1 AUTHOR

Tomo.M <tomo at cpan.org>

=head1 COPYRIGHT

Copyright (c) 2020 Tomo.M All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
