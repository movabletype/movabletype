# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v3::Auth;
use strict;
use warnings;

use MT::Author;
use MT::DataAPI::Endpoint::v1::Auth;
use MT::Log;

sub authentication_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Auth::authentication_openapi_spec();
    $spec->{summary}     = 'User authentication by username and password';
    $spec->{description} = 'Create a new session and access token. This is like sign-in.';
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{username}{description} = 'Your Sign-in Name';
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{password}{description} = 'Your Web Service Password';
    return $spec;
}

sub authentication {
    my ($app) = @_;
    MT::DataAPI::Endpoint::v1::Auth::_authentication( $app, \&_login );
}

sub _login {
    my ($app) = @_;

    my $username = $app->param('username');
    my $password = $app->param('password');
    if (   !defined $username
        || !defined $password
        || $username eq ''
        || $password eq '' )
    {
        return;
    }

    my $author = MT->model('author')->load(
        {   name      => $username,
            type      => MT::Author::AUTHOR,
            status    => MT::Author::ACTIVE,
            auth_type => $app->config->AuthenticationModule,
        }
    );
    if (  !$author
        || $author->locked_out
        || $author->api_password ne $password )
    {
        return;
    }

    my $remember = $app->param('remember');
    my $session = $app->make_session( $author, $remember ) or return;

    $app->user($author);
    $app->{session} = $session;

    ( $author, 1 );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v3::Auth - Movable Type class for endpoint definitions about authentication.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
