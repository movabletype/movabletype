# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth;

use strict;
use base 'MT::ErrorHandler';

sub SUCCESS ()          {1}
sub UNKNOWN ()          {2}
sub INACTIVE ()         {3}
sub INVALID_PASSWORD () {4}
sub DELETED ()          {5}
sub REDIRECT_NEEDED ()  {6}
sub NEW_LOGIN ()        {7}
sub NEW_USER ()         {8}
sub PENDING ()          {9}
sub LOCKED_OUT ()       {10}
sub SESSION_EXPIRED ()  {11}

{
    my $auth_module;

    sub _driver {
        my @auth_modes = split( /\s+/, MT->config->AuthenticationModule );
        foreach my $auth_mode (@auth_modes) {
            my $auth_module_name = 'MT::Auth::' . $auth_mode;
            eval 'require ' . $auth_module_name;
            if ( my $err = $@ ) {
                die(MT->translate(
                        "Bad AuthenticationModule config '[_1]': [_2]",
                        $auth_mode, $err
                    )
                );
            }
            my $auth_module = $auth_module_name->new;
            die $auth_module_name->errstr
                if ( !$auth_module || ( ref( \$auth_module ) eq 'SCALAR' ) );
            return $auth_module;
        }
        die( MT->translate("Bad AuthenticationModule config") );
    }

    sub _handle {
        my $method = shift;
        my $mod = $auth_module ||= _driver();
        return undef unless $mod->can($method);
        $mod->$method(@_);
    }

    sub release {
        undef $auth_module;
    }
}

BEGIN {
    my @methods = qw(
        errstr sanity_check is_valid_password can_recover_password
        is_profile_needed password_exists
        invalidate_credentials delegate_auth can_logout
        synchronize synchronize_author synchronize_group
        new_user new_login login_form fetch_credentials
    );
    no strict 'refs';

    foreach my $meth (@methods) {
        *{"MT::Auth::$meth"} = sub { shift; _handle( $meth, @_ ) };
    }
}

sub validate_credentials {
    my $class = shift;
    my ($ctx) = @_;
    my $app   = MT->instance;

    my $res = _handle( 'validate_credentials', @_ );

    if ( $res != MT::Auth::SUCCESS() ) {
        require MT::Lockout;
        my $user = $ctx->{username};

        if ( MT::Lockout->is_locked_out( $app, $app->remote_ip, $user ) ) {
            return MT::Auth::LOCKED_OUT();
        }

        MT::Lockout->process_login_result( $app, $app->remote_ip, $user,
            $res );
    }

    $app->run_callbacks( 'post_signin.app', $app, $res );

    $res;
}

sub task_synchronize {
    my $obj = shift;

    # This task method is only invoked if ExternalUserManagement is enabled.
    return
        unless MT->config->ExternalUserManagement
            || MT->config->ExternalGroupManagement;
    return $obj->synchronize(@_);
}

1;

__END__

=head1 NAME

MT::Auth

=head1 DESCRIPTION

=head1 CREATING AN AUTHENTICATION MODULE

=head1 METHODS

=head2 MT::Auth->invalidate_credentials(\%context)

A routine responsible for clearing the active logged-in user. Some
authentication modules may take advantage of this time to redirect the user
or synchronize other operations at this time.

=head2 MT::Auth->is_valid_password($author, $password, $crypted, \$error_ref)

A routine that determines whether the given password is valid for the
author object supplied. If the password is already processed by the
'crypt' function, the third parameter here will be positive. The \$error_ref
is a reference to a scalar variable for storing any error message to
be returned to the application. The routine itself should return 1 for
a valid password, 0 or undef for an invalid one.

=head2 MT::Auth->fetch_credentials(\%context)

A routine that gathers login credentials from the active request and
returns key elements in a hashref. The hashref should contain any of
the following applicable key fields:

=over 4

=item * app - The handle to the active application.

=item * username - The username of the active user.

=item * password - The user's password.

=item * session_id - If a session-based authenication is taking place,
store the session id with this key.

=item * permanent - A flag that identifies whether or not the credentials
should be indefinitely cached.

=back

=head2 MT::Auth->delegate_auth

A boolean flag that identifies whether this authentication module provides
a delegate authentication system. This would be the case where MT itself
does not ask for authentication information, but instead defers to another
web service or protocol. Typically, a delegated authentication also
involves using request redirects to the authentication service when
necessary.

=head2 MT::Auth->password_exists

A boolean flag that identifies whether this authentication module utilizes
a password or not (that is, whether one is required for an account and
stored with the user profile).

=head2 MT::Auth->validate_credentials(\%context)

A routine that takes the context returned by the 'fetch_credentials'
method and determines if they are valid or not. It is also responsible
for assigning the active user if the credentials are correct.

=head2 MT::Auth->can_logout

A boolean flag that identifies whether this authentication module allows
for a 'Logout' link and logout mechanism within the application interface.

=head2 MT::Auth->login_form

A method that returns a snippet of HTML code for displaying the necessary
fields for logging into the MT application.

=head2 MT::Auth->sanity_check

A method used by the MT application to determine if the form data provided
for creating a new user is valid or not.

=head2 MT::Auth->is_profile_needed

A boolean flag that identifies whether this authentication module expects
the local management of the user's profile.

=head2 MT::Auth->can_recover_password

A boolean flag that identifies whether this authentication module provides
a password recovery function. This is only valid when passwords are locally
stored and managed.

=head2 MT::Auth->new_user

A method used in the login attempt to give chance to each authentication
layer to process the user who is going to be created upon loggin in
for the first time.  The method must return boolean value indicating
whether or not the method actually saved the new user to the database or not.

=head2 MT::Auth->new_login

A method used in the login attempt to give chance to each authentication
layer to process the existing user logging in.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
