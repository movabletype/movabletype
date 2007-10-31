# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Auth::BasicAuth;

use strict;
use base 'MT::Auth::MT';
use MT::Author qw(AUTHOR);

sub can_recover_password { 0 }
sub is_profile_needed { 1 }
sub password_exists { 0 }
sub delegate_auth { 1 }
sub can_logout { 0 }

sub new_user {
    my $auth = shift;
    my ($app, $user) = @_;
    $user->password('(none)');
    0;
}

sub fetch_credentials {
    my $auth = shift;
    my ($ctx) = @_;
    my $fallback = { %$ctx, username => $ENV{'REMOTE_USER'} };
    $ctx = $auth->SUPER::session_credentials(@_);
    if (!defined $ctx) {
        if ($ENV{'REMOTE_USER'}) {
            $ctx = $fallback;
        } else {
            return undef;
        }
    }
    if ($ctx->{username} ne $ENV{'REMOTE_USER'}) {
        $ctx = $fallback;
    }
    $ctx;
}

sub validate_credentials {
    my $auth = shift;
    my ($ctx, %opt) = @_;

    my $app = $ctx->{app};
    my $user = $ctx->{username};
    return undef unless (defined $user) && ($user ne '');

    my $result = MT::Auth::UNKNOWN();

    # load author from db
    my $author = MT::Author->load({ name => $user, type => AUTHOR });
    if ($author) {
        # author status validation
        if ($author->is_active) {
            $result = MT::Auth::SUCCESS();
            $app->user($author);

            $result = MT::Auth::NEW_LOGIN()
                unless $app->session_user($author, $ctx->{session_id}, %opt);
        } else {
            $result = MT::Auth::INACTIVE();
        }
    } else {
        if ($app->config->ExternalUserManagement) {
            $result = MT::Auth::NEW_USER();
        }
    }

    return $result;
}

1;

__END__

=head1 NAME

MT::Auth::MT

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
