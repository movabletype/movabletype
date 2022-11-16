# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Auth::MT;
use strict;
use warnings;

use base 'MT::ErrorHandler';
use MT::Author qw( AUTHOR );

sub sanity_check {
    my $auth = shift;
    my ($app) = @_;

    my $id          = $app->param('id');
    my $pass        = $app->param('pass');
    my $pass_verify = $app->param('pass_verify');
    my $old_pass    = $app->param('old_pass');

    $pass        = '' unless defined $pass;
    $pass_verify = '' unless defined $pass_verify;

    if ( $pass ne $pass_verify ) {
        return $app->translate('Passwords do not match.');
    }

    return '' unless length($pass);

    if ( $id && $app->user->id == $id ) {
        my $author = MT::Author->load($id)
            or
            return $app->translate('Failed to verify the current password.');
        if ( !$auth->is_valid_password( $author, $old_pass ) ) {
            return $app->translate('Failed to verify the current password.');
        }
    }
    if ( $pass =~ /[^\x20-\x7E]/ ) {
        return $app->translate('Password contains invalid character.');
    }
    return '';
}

sub is_valid_password {
    my $auth = shift;
    my ( $author, $pass, $crypted, $error_ref ) = @_;
    $pass = '' unless length($pass);

    my $real_pass = $author->column('password');
    if ( ( !$real_pass ) || ( $real_pass eq '(none)' ) ) {
        return 0;
    }

    if ($crypted) {
        return $real_pass eq $pass;
    }

    if ( $real_pass =~ m/^\$6\$(.*)\$(.*)/ ) {
        my ( $salt, $value ) = ( $1, $2 );
        if ( eval { require MT::Util::Digest::SHA } ) {
            return $value eq MT::Util::Digest::SHA::sha512_base64(
                $salt . Encode::encode_utf8($pass) );
        }
        else {
            die MT->translate('Missing required module') . ' Digest::SHA';
        }
    }
    elsif ( $real_pass =~ m/^{SHA}(.*)\$(.*)/ ) {
        my ( $salt, $value ) = ( $1, $2 );
        if ($value eq MT::Util::perl_sha1_digest_hex( $salt . $pass )) {
            if (MT->config->SchemaVersion > 5.0025) {
                unless ( $pass =~ /[^\x20-\x7E]/ ) {
                    $author->set_password($pass);
                    $author->save;
                }
            }
            return 1;
        }
        return;
    }
    else {
        # the password is stored using the old hashing method
        if (crypt( $pass, $real_pass ) eq $real_pass) {
            if (MT->config->SchemaVersion > 5.0025) {
                unless ( $pass =~ /[^\x20-\x7E]/ ) {
                    $author->set_password($pass);
                    $author->save;
                }
            }
            return 1;
        }
        return;
    }
}

sub can_recover_password {1}
sub is_profile_needed    {1}
sub password_exists      {1}
sub delegate_auth        {0}
sub can_logout           {1}

# Standard MT-based login form / cookie auth.
sub login_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app} or return;

    my $username = $app->param('username');
    my $password = $app->param('password');

    if (   defined($username)
        && length($username)
        && defined($password)
        && length($password) )
    {
        my $remember = $app->param('remember') ? 1 : 0;
        return {
            %$ctx,
            username  => $username,
            password  => $password,
            permanent => $remember,
            auth_type => 'MT'
        };
    }
    return undef;
}

sub session_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app} or return;
    my $cookies = $app->cookies;
    if ( $cookies->{ $app->user_cookie } ) {
        my $cookie = $cookies->{ $app->user_cookie }->value;
        $cookie = Encode::decode( $app->charset, $cookie )
            unless Encode::is_utf8($cookie);
        my ( $user, $session_id, $remember ) = split /::/, $cookie;
        return {
            %$ctx,
            username   => $user,
            session_id => $session_id,
            permanent  => $remember,
            auth_type  => 'MT'
        };
    }
    return undef;
}

sub fetch_credentials {
    my $auth = shift;
    my ($ctx) = @_;
    return $auth->login_credentials(@_) || $auth->session_credentials(@_);
}

sub login_form {
    my $auth = shift;
    my ($app) = @_;
    return $app->build_page(
        'include/login_mt.tmpl',
        {   build_blog_selector => 0,
            build_menus         => 0,
            build_compose_menus => 0,
            build_user_menus    => 0,
        }
    );
}

sub validate_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app      = $ctx->{app};
    my $username = $ctx->{username};
    my $password = $ctx->{password};
    my $result   = MT::Auth::UNKNOWN();

    if ( ( defined $username ) && ( $username ne '' ) ) {

        # load author from db
        my $user_class = $app->user_class;
        my ($author) = $user_class->load(
            {   name      => $username,
                type      => AUTHOR,
                auth_type => 'MT'
            },
            { binary => { name => 1 } }
        );

        if ($author) {

            # password validation
            if ( $ctx->{session_id} ) {
                my $sess = $app->model('session')->load( $ctx->{session_id} );

                my $sess_author_id = $sess ? $sess->get('author_id') : undef;
                if (   $sess
                    && $sess_author_id
                    && ( $sess_author_id == $author->id ) )
                {
                    $app->user($author);
                    $result = MT::Auth::SUCCESS();
                }
                else {
                    $app->errtrans("Invalid request.");
                    $result = MT::Auth::SESSION_EXPIRED();
                }
            }
            else {
                my $error;
                if ( $author->is_valid_password( $password, 0, \$error ) ) {
                    $app->user($author);
                    $result = MT::Auth::NEW_LOGIN();
                }
                else {
                    $app->error($error);
                    $result = MT::Auth::INVALID_PASSWORD();
                }
            }
        }
        if ( $author && !$author->is_active ) {
            if ( MT::Author::INACTIVE() == $author->status ) {
                $result = MT::Auth::INACTIVE();
                $app->user(undef);
            }
            elsif ( MT::Author::PENDING() == $author->status ) {
                $result = MT::Auth::PENDING();

                # leave user in $app - removed later in app
            }
        }
    }
    return $result;
}

sub invalidate_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app  = $ctx->{app};
    my $user = $app->user;
    if ($user) {
        $user->remove_sessions;
        $app->user(undef);
    }
    $app->clear_login_cookie;
}

1;

__END__

=head1 NAME

MT::Auth::MT

=head1 METHODS

=head2 invalidate_credentials

=head2 is_valid_password

=head2 fetch_credentials

=head2 delegate_auth

=head2 session_credentials

=head2 password_exists

=head2 validate_credentials

=head2 can_logout

=head2 login_form

=head2 sanity_check

=head2 login_credentials

=head2 is_profile_needed

=head2 can_recover_password


=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
