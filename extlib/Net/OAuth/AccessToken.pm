package Net::OAuth::AccessToken;
use warnings;
use strict;
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw/client token token_secret session_handle expires_in authorization_expires_in/);

sub new {
  my $class = shift;
  my %opts = @_;
  my $self = bless \%opts, $class;
  return $self;
}

sub request {
  my $self = shift;
  my ($method, $uri, $header, $content, %params) = @_;
  my $oauth_req = $self->client->_make_request(
    'protected resource', 
    request_method => $method,
    request_url => $self->client->site_url($uri),
    token => $self->token,
    token_secret => $self->token_secret,
    %params,
  );
  $oauth_req->sign;

  return $self->client->request(HTTP::Request->new(
    $method => $oauth_req->to_url, $header, $content
  ));
}

sub get {
	return shift->request('GET', @_);
}

sub post {
	return shift->request('POST', @_);
}

sub delete {
	return shift->request('DELETE', @_);
}

sub put {
	return shift->request('PUT', @_);
}

=head1 NAME

Net::OAuth::AccessToken - OAuth Access Token

=head1 DESCRIPTION

WARNING: Net::OAuth::AccessToken is alpha code.  The rest of Net::OAuth is quite
stable but this particular module is new, and is under-documented and under-tested.

=head1 SEE ALSO

L<Net::OAuth>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Keith Grennan.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut


1;
