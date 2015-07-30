package OAuth::Lite2::Agent::Strict;

use strict;
use warnings;

use parent 'OAuth::Lite2::Agent';
use OAuth::Lite2::Client::Error;

=head1 NAME

OAuth::Lite2::Agent::Strict - Preset User Agent class for strict SSL

=head1 SYNOPSIS

    my $client = OAuth::Lite2::Client::WebApp->new(
        ..., # other params
        agent => OAuth::Lite2::Client::Agent::Strict->new(
            https_version => $https_version,
            ..., # https parameters
        ),
    );

=head1 DESCRIPTION

This module is one of preset user-agent class.
This is useful when you want check the SSL strictly.

=head1 METHODS

=head2 request ($req)

Append to the behavior of parent class, this method verify the SSL,
and if it fails, it throws the exception.

=cut

sub request {
    my ($self, $req) = @_;

    OAuth::Lite2::Client::Error::InsecureRequest->throw(
        message => sprintf q{request url should start with https, but found "%s"}, $req->uri)
        unless $req->uri =~ /^https/;

    local $ENV{HTTPS_DEBUG}          = $self->{https_debug}          if $self->{https_debug};
    local $ENV{HTTPS_CA_FILE}        = $self->{https_ca_file}        if $self->{https_ca_file};
    local $ENV{HTTPS_CA_DIR}         = $self->{https_ca_dir}         if $self->{https_ca_dir};
    local $ENV{HTTPS_CERT_FILE}      = $self->{https_cert_file}      if $self->{https_cert_file};
    local $ENV{HTTPS_KEY_FILE}       = $self->{https_key_file}       if $self->{https_key_file};
    local $ENV{HTTPS_VERSION}        = $self->{https_version}        if $self->{https_version};
    local $ENV{HTTPS_PROXY}          = $self->{https_proxy}          if $self->{https_proxy};
    local $ENV{HTTPS_PROXY_USERNAME} = $self->{https_proxy_username} if $self->{https_proxy_username};
    local $ENV{HTTPS_PROXY_PASSWORD} = $self->{https_proxy_password} if $self->{https_proxy_password};

    my $res = $self->SUPER::request($req);

    OAuth::Lite2::Client::Error::InsecureResponse->throw(
        message => "SSL Warning: Unauthorized access to blocked host"
    ) if $res->header('Client-SSL-Warning');

    return $res;
}

1;

=head1 SEE ALSO

L<OAuth::Lite2::Client::Agent>,
L<OAuth::Lite2::Client::Agent::Dump>

=head1 AUTHOR

Lyo Kato, C<lyo.kato _at_ gmail.com>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
