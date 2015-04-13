# ====
#  SSL/STARTTLS extention for G.Barr's Net::SMTP.
#    plus, enable arbitrary SMTP auth mechanism selection.
#      IO::Socket::SSL (also Net::SSLeay openssl),
#      Authen::SASL, MIME::Base64 should be installed.
#
package Net::SMTPS;

use vars qw ( $VERSION @ISA );

$VERSION = "0.04";

use base qw ( Net::SMTP );
use Net::Cmd;  # import CMD_OK, CMD_MORE, ...
use Net::Config;

eval {
    require IO::Socket::INET6
	and unshift @ISA, 'IO::Socket::INET6';
} or do {
    require IO::Socket::INET
	and unshift @ISA, 'IO::Socket::INET';
};

use strict;

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

# common in SSL
  my %ssl_args;
  if ($ssl) {
    eval {
      require IO::Socket::SSL;
    } or do {
      $obj->set_status(500, ["Need working IO::Socket::SSL"]);
      $obj->close;
      return undef;
    };
    %ssl_args = map { +"$_" => $arg{$_} } grep {/^SSL/} keys %arg;
    $IO::Socket::SSL::DEBUG = (exists $arg{Debug} ? $arg{Debug} : undef); 
  }

# OverSSL
  if (defined($ssl) && $ssl =~ /ssl/i) {
    $obj->ssl_start(\%ssl_args)
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
  if (defined($ssl) && $ssl =~ /starttls/i && $obj->supports('STARTTLS') ) {
    (($obj->command('STARTTLS')->response() == CMD_OK)
     and $obj->ssl_start(\%ssl_args)
     and $obj->hello($arg{Hello} || ""))
       or do {
	 $obj->set_status(500, ["Cannot start SSL session"]);
	 $obj->close();
	 return undef;
       };
  }

  $obj;
}

sub ssl_start {
    my ($self, $args) = @_;
    my $type = ref($self);

    (unshift @ISA, 'IO::Socket::SSL'
     and IO::Socket::SSL->start_SSL($self, %$args)
     and $self->isa('IO::Socket::SSL')
     and bless $self, $type     # re-bless 'cause IO::Socket::SSL blesses himself.
    ) or return undef;
}

# Override to specify a certain auth mechanism.
sub auth {
  my ($self, $username, $password, $mech) = @_;

  eval {
    require MIME::Base64;
    require Authen::SASL;
  } or $self->set_status(500, ["Need MIME::Base64 and Authen::SASL todo auth"]), return 0;

  my $mechanisms = $self->supports('AUTH', 500, ["Command unknown: 'AUTH'"]);
  if ($mech) {
    $mechanisms = $mech;
  }
  return unless $mechanisms;

  my $sasl;

  if (ref($username) and UNIVERSAL::isa($username, 'Authen::SASL')) {
    $sasl = $username;
    $sasl->mechanism($mechanisms);
  }
  else {
    die "auth(username, password)" if not length $username;
    $sasl = Authen::SASL->new(
      mechanism => $mechanisms,
      callback  => {
        user     => $username,
        pass     => $password,
        authname => $username,
      }
    );
  }

  # We should probably allow the user to pass the host, but I don't
  # currently know and SASL mechanisms that are used by smtp that need it
  my $client = $sasl->client_new('smtp', ${*$self}{'net_smtp_host'}, 0);
  my $str    = $client->client_start;

  # We dont support sasl mechanisms that encrypt the socket traffic.
  # todo that we would really need to change the ISA hierarchy
  # so we dont inherit from IO::Socket, but instead hold it in an attribute

  my @cmd = ("AUTH", $client->mechanism);
  my $code;

  push @cmd, MIME::Base64::encode_base64($str, '')
    if defined $str and length $str;

  while (($code = $self->command(@cmd)->response()) == CMD_MORE) {
    @cmd = (
      MIME::Base64::encode_base64(
        $client->client_step(MIME::Base64::decode_base64(($self->message)[0])), ''
      )
    );
  }

  $code == CMD_OK;
}

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
This module inherits all the methods from Net::SMTP. You may use all the friendly
options that came bundled with Net::SMTP.
You can control the SSL usage with the options of new() constructor method.
'doSSL' option is the switch, and, If you would like to control detailed SSL settings,
you can set SSL_* options that are brought from IO::Socket::SSL. Please see the
document of IO::Socket::SSL about these options detail.

Just one method difference from the Net::SMTP, you may select SMTP AUTH mechanism
as the third option of auth() method.

=head1 METHODS

Most of all methods of Net::SMTP are inherited as is, except auth().


=over 4

=item auth ( USERNAME, PASSWORD [, AUTHMETHOD])

Attempt SASL authentication through Authen::SASL module. AUTHMETHOD is your required
method of authentication, like 'CRAM-MD5', 'LOGIN', ... etc. the default is 'CRAM-MD5'.

=back

=head1 SEE ALSO

L<Net::SMTP>,
L<IO::Socket::SSL>,
L<Authen::SASL>

=head1 AUTHOR

Tomo.M <tomo at cpan.org>

=head1 COPYRIGHT

Copyright (c) 2013 Tomo.M All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
