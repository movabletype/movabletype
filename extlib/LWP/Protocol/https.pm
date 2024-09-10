package LWP::Protocol::https;

use strict;
use warnings;

our $VERSION = '6.14';

use parent qw(LWP::Protocol::http);
require Net::HTTPS;

sub socket_type
{
    return "https";
}

sub _extra_sock_opts
{
    my $self = shift;
    my %ssl_opts = %{$self->{ua}{ssl_opts} || {}};
    if (delete $ssl_opts{verify_hostname}) {
	$ssl_opts{SSL_verify_mode} ||= 1;
	$ssl_opts{SSL_verifycn_scheme} = 'www';
    }
    else {
        if ( $Net::HTTPS::SSL_SOCKET_CLASS eq 'Net::SSL' ) {
            $ssl_opts{SSL_verifycn_scheme} = '';
        } else {
            $ssl_opts{SSL_verifycn_scheme} = 'none';
        }
    }
    if ($ssl_opts{SSL_verify_mode}) {
        unless (exists $ssl_opts{SSL_ca_file} || exists $ssl_opts{SSL_ca_path}) {
            if ($Net::HTTPS::SSL_SOCKET_CLASS eq 'IO::Socket::SSL'
                && defined &IO::Socket::SSL::default_ca
                && IO::Socket::SSL::default_ca() ) {
                # IO::Socket::SSL has a usable default CA
            } elsif ( my $cafile = eval {
            require Mozilla::CA;
            Mozilla::CA::SSL_ca_file()
            }) {
            # use Mozilla::CA
            $ssl_opts{SSL_ca_file} = $cafile;
            } else {
                die <<'EOT';
Can't verify SSL peers without knowing which Certificate Authorities to trust.

This problem can be fixed by either setting the PERL_LWP_SSL_CA_FILE
environment variable to the file where your trusted CA are, or by installing
the Mozilla::CA module for set of commonly trusted CAs.

To completely disable the verification that you talk to the correct SSL peer you
can set SSL_verify_mode to 0 within ssl_opts.  But, if you do this you can't be
sure that you communicate with the expected peer.
EOT
            }
        }
    }
    $self->{ssl_opts} = \%ssl_opts;
    return (%ssl_opts, MultiHomed => 1, $self->SUPER::_extra_sock_opts);
}

# This is a subclass of LWP::Protocol::http.
# That parent class calls ->_check_sock() during the
# request method. This allows us to hook in and run checks
# sub _check_sock
# {
#     my($self, $req, $sock) = @_;
# }

sub _get_sock_info
{
    my $self = shift;
    $self->SUPER::_get_sock_info(@_);
    my($res, $sock) = @_;
    if ($sock->can('get_sslversion') and my $sslversion = $sock->get_sslversion) {
        $res->header("Client-SSL-Version" => $sslversion);
    }
    $res->header("Client-SSL-Cipher" => $sock->get_cipher);
    my $cert = $sock->get_peer_certificate;
    if ($cert) {
	$res->header("Client-SSL-Cert-Subject" => $cert->subject_name);
	$res->header("Client-SSL-Cert-Issuer" => $cert->issuer_name);
    }
    if (!$self->{ssl_opts}{SSL_verify_mode}) {
	$res->push_header("Client-SSL-Warning" => "Peer certificate not verified");
    }
    elsif (!$self->{ssl_opts}{SSL_verifycn_scheme}) {
	$res->push_header("Client-SSL-Warning" => "Peer hostname match with certificate not verified");
    }
    $res->header("Client-SSL-Socket-Class" => $Net::HTTPS::SSL_SOCKET_CLASS);
}

# upgrade plain socket to SSL, used for CONNECT tunnel when proxying https
# will only work if the underlying socket class of Net::HTTPS is
# IO::Socket::SSL, but code will only be called in this case
if ( $Net::HTTPS::SSL_SOCKET_CLASS->can('start_SSL')) {
    *_upgrade_sock = sub {
	my ($self,$sock,$url) = @_;
    # SNI should be passed there only if it is not an IP address.
    # Details: https://github.com/libwww-perl/libwww-perl/issues/449#issuecomment-1896175509
	my $host = $url->host() =~ m/:|^[\d.]+$/s ? undef : $url->host();
	$sock = LWP::Protocol::https::Socket->start_SSL( $sock,
	    SSL_verifycn_name => $url->host,
	    SSL_hostname => $host,
	    $self->_extra_sock_opts,
	);
	$@ = LWP::Protocol::https::Socket->errstr if ! $sock;
	return $sock;
    }
}

#-----------------------------------------------------------
package LWP::Protocol::https::Socket;

use parent -norequire, qw(Net::HTTPS LWP::Protocol::http::SocketMethods);

1;

__END__

=head1 NAME

LWP::Protocol::https - Provide https support for LWP::UserAgent

=head1 SYNOPSIS

  use LWP::UserAgent;

  $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 });
  $res = $ua->get("https://www.example.com");

  # specify a CA path
  $ua = LWP::UserAgent->new(
      ssl_opts => {
          SSL_ca_path     => '/etc/ssl/certs',
          verify_hostname => 1,
      }
  );

=head1 DESCRIPTION

The LWP::Protocol::https module provides support for using https schemed
URLs with LWP.  This module is a plug-in to the LWP protocol handling, so
you don't use it directly.  Once the module is installed LWP is able
to access sites using HTTP over SSL/TLS.

If hostname verification is requested by LWP::UserAgent's C<ssl_opts>, and
neither C<SSL_ca_file> nor C<SSL_ca_path> is set, then C<SSL_ca_file> is
implied to be the one provided by L<Mozilla::CA>.  If the Mozilla::CA module
isn't available SSL requests will fail.  Either install this module, set up an
alternative C<SSL_ca_file> or disable hostname verification.

This module used to be bundled with the libwww-perl, but it was unbundled in
v6.02 in order to be able to declare its dependencies properly for the CPAN
tool-chain.  Applications that need https support can just declare their
dependency on LWP::Protocol::https and will no longer need to know what
underlying modules to install.

=head1 SEE ALSO

L<IO::Socket::SSL>, L<Crypt::SSLeay>, L<Mozilla::CA>

=head1 COPYRIGHT & LICENSE

Copyright (c) 1997-2011 Gisle Aas.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
