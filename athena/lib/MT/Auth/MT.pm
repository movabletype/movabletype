# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Auth::MT;
use strict;

use base 'MT::ErrorHandler';
use MT::Author qw( AUTHOR );

sub sanity_check {
    my $auth = shift;
    my ($app) = @_;
    my $q = $app->param;
    my $id = $q->param('id');

    if ($q->param('pass') ne $q->param('pass_verify')) {
        return $app->translate('Passwords do not match.');
    } else {
        if ($q->param('pass') && $id) {
            my $author = MT::Author->load($id);
            if (!$auth->is_valid_password($author, $q->param('old_pass'))) {
                return $app->translate('Failed to verify current password.');
            }
        }
    }
    my $hint = $q->param('hint') || '';
    $hint =~ s!^\s+|\s+$!!gs;
    unless ($hint) {
        return $app->translate('Password hint is required.');
    }
    return '';
}

sub is_valid_password {
    my $auth = shift;
    my($author, $pass, $crypted, $error_ref) = @_;
    $pass ||= '';
    
    my $real_pass = $author->column('password');
    if ((!$real_pass) || ($real_pass eq '(none)')) {
        return 0;
    }
    return $crypted ? $real_pass eq $pass :
                      crypt($pass, $real_pass) eq $real_pass;
}

sub can_recover_password { 1 }
sub is_profile_needed { 1 }
sub password_exists { 1 }
sub delegate_auth { 0 }
sub can_logout { 1 }

# Standard MT-based login form / cookie auth.
sub login_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app} or return;
    if ($app->param('username') && $app->param('password')) {
        my ($user, $pass, $remember);
        $user = $app->param('username');
        $pass = $app->param('password');
        $remember = $app->param('remember') ? 1 : 0;
        return { %$ctx, username => $user, password => $pass, permanent => $remember };
    }
    return undef;
}

sub session_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app} or return;
    my $cookies = $app->cookies;
    if ($cookies->{$app->user_cookie}) {
        my ($user, $session_id, $remember) = split /::/, $cookies->{$app->user_cookie}->value;
        return { %$ctx, username => $user, session_id => $session_id, permanent => $remember };
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
    return $app->build_page('include/login_mt.tmpl');
}

sub validate_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app};
    my $username = $ctx->{username};
    my $password = $ctx->{password};
    my $result = MT::Auth::UNKNOWN();

    if ((defined $username) && ($username ne '')) {
        # load author from db
        my $user_class = $app->user_class;
        my ($author) = $user_class->search({ name => $username, type => AUTHOR });

        if ($author) {
            # password validation
            if ($ctx->{session_id}) {
                $app->user($author);
                $result = MT::Auth::SUCCESS();
            } else {
                my $error;
                if ($author->is_valid_password($password, 0, \$error)) {
                    $app->user($author);
                    $result = MT::Auth::NEW_LOGIN();
                } else {
                    $app->error($error);
                    $result = MT::Auth::INVALID_PASSWORD();
                }
            }
        }
        if ($author && !$author->is_active) {
            $result = MT::Auth::INACTIVE();
            $app->user(undef);
        }
    }
    return $result;
}

sub invalidate_credentials {
    my $auth = shift;
    my ($ctx) = @_;

    my $app = $ctx->{app};
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
