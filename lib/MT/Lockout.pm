# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Lockout;

use strict;
use warnings;

use MT::Auth;
use MT::Util qw(is_valid_email epoch2ts);
use MT::Author;

sub is_locked_out_ip {
    my $class = shift;
    my ( $app, $remote_ip ) = @_;
    my $limit = $app->config->IPLockoutLimit
        or return 0;

    $app->model('failedlogin')->load(
        {   remote_ip => $remote_ip,
            ip_locked => 1,
            start     => [ time - $app->config->IPLockoutInterval, undef ],
        },
        { range_incl => { start => 1, } }
    ) ? 1 : 0;
}

sub locked_out_ip_recovery_time {
    my $class = shift;
    my ( $app, $remote_ip ) = @_;
    my $limit = $app->config->IPLockoutLimit
        or return 0;

    my $old = $app->model('failedlogin')->load(
        {   remote_ip => $remote_ip,
            start     => [ time - $app->config->IPLockoutInterval, undef ]
        },
        {   range_incl => { start => 1, },
            sort       => 'start',
            direction  => 'ascend',
            limit      => 1
        }
    ) or return 0;

    $old->start + $app->config->IPLockoutInterval;
}

sub locked_out_user_threshold {
    time - MT->instance->config->UserLockoutInterval;
}

sub is_locked_out_user {
    my $class = shift;
    my ( $app, $username ) = @_;

    return 0 if ( !$app->config->UserLockoutLimit ) || ( !$username );

    my $user = $app->user
        || $app->model('author')->load( { name => $username } )
        or return 0;

    $user->locked_out;
}

sub is_locked_out {
    my $class = shift;
    my ( $app, $remote_ip, $username ) = @_;

    $class->is_locked_out_ip( $app, $remote_ip )
        || $class->is_locked_out_user( $app, $username );
}

sub validate_recover_token {
    my $class = shift;
    my ( $app, $user, $token ) = @_;
    $class->recover_token( $app, $user ) eq $token;
}

sub recover_token {
    my $class = shift;
    my ( $app, $user ) = @_;

    return undef
        unless $user->locked_out
        && $user->lockout_recover_salt;

    my $sha256_hex;
    if ( eval { require MT::Util::Digest::SHA } ) {

        # Can use SHA256
        $sha256_hex = \&MT::Util::Digest::SHA::sha256_hex;
    }
    else {

        # Maybe cannot use SHA256
        $sha256_hex = \&MT::Util::perl_sha1_digest_hex;
    }

    $sha256_hex->( $user->lockout_recover_salt . $app->config->SecretToken );
}

sub recover_lockout_uri {
    my $class = shift;
    my ( $app, $user, $args ) = @_;

    my $token = $class->recover_token( $app, $user )
        or return undef;

    $app->uri(
        'mode' => 'recover_lockout',
        args   => {
            user_id => $user->id,
            token   => $token,
            ( $args ? %$args : () ),
        }
    );
}

sub _check_locked_out_ip {
    my $class = shift;
    my ( $app, $remote_ip ) = @_;
    my $limit = $app->config->IPLockoutLimit
        or return 0;

    my $count = $app->model('failedlogin')->count(
        {   remote_ip => $remote_ip,
            start     => [ time - $app->config->IPLockoutInterval, undef ]
        },
        { range_incl => { start => 1, } }
    );

    $count >= $limit;
}

sub _check_locked_out_user {
    my $class = shift;
    my ( $app, $author_id ) = @_;
    my $count = $app->model('failedlogin')->count(
        {   author_id => $author_id,
            start     => [ time - $app->config->UserLockoutInterval, undef ]
        },
        { range_incl => { start => 1, } }
    );

    $app->config->UserLockoutLimit
        && $count >= $app->config->UserLockoutLimit;
}

sub _notify_to {
    my $class = shift;
    my ($app) = @_;

    my @notify_to = ();

    if ( my $id_list = $app->config->LockoutNotifyTo ) {
        foreach my $id ( split( /;/, $id_list ) ) {
            if ( my $author = $app->model('author')->load($id) ) {
                push( @notify_to, $author->email );
            }
            else {
                $app->log(
                    {   message => $app->translate(
                            "Cannot find author for id '[_1]'", $id
                        ),
                        level    => MT::Log::ERROR(),
                        class    => 'system',
                        category => 'email'
                    }
                );
            }
        }
    }

    @notify_to ? @notify_to : ( $app->config->EmailAddressMain );
}

sub _merge_notify_to {
    my $class     = shift;
    my %addresses = ();
    foreach (@_) {
        $addresses{$_} = 1 if is_valid_email($_);
    }
    keys %addresses;
}

sub _insert_failedlogin {
    my $class = shift;
    my ( $app, $remote_ip, $username ) = @_;
    $username ||= '';

    my $user = $app->model('author')->load(
        {   name   => $username,
            status => MT::Author::ACTIVE,
        }
    );
    my $author_id = $user ? $user->id : undef;

    if ( !$author_id && !$app->config->IPLockoutLimit ) {
        return;
    }

    my $failedlogin = $app->model('failedlogin')->new;
    $failedlogin->author_id($author_id);
    $failedlogin->remote_ip($remote_ip);
    $failedlogin->start(time);
    $failedlogin->save or die $failedlogin->errstr;

    my @notify_to = $class->_notify_to($app);

    if ( $author_id && $class->_check_locked_out_user( $app, $author_id ) ) {
        $app->run_callbacks( 'pre_lockout.user', $app, $username,
            $remote_ip );

        $app->log(
            {   message => $app->translate(
                    'User was locked out. IP address: [_1], Username: [_2]',
                    $remote_ip, $username
                ),
                level    => MT::Log::SECURITY(),
                category => 'lockout',
                class    => 'author',
            }
        );

        $class->lock($user);
        $user->save or die $user->errstr;

        foreach
            my $email ( $class->_merge_notify_to( @notify_to, $user->email ) )
        {
            my %head = (
                id      => 'lockout_user',
                To      => $email,
                Subject => $app->translate('User Was Locked Out')
            );

            my $body = $app->build_email(
                'lockout-user',
                {   author               => $user,
                    recover_lockout_link => $app->base
                        . $class->recover_lockout_uri( $app, $user ),
                }
            );

            require MT::Util::Mail;
            MT::Util::Mail->send_and_log( \%head, $body );
        }

        $app->run_callbacks( 'post_lockout.user', $app, $username,
            $remote_ip );
    }

    if ( $class->_check_locked_out_ip( $app, $remote_ip ) ) {
        $app->run_callbacks( 'pre_lockout.ip', $app, $username, $remote_ip );

        $app->log(
            {   message => $app->translate(
                    'IP address was locked out. IP address: [_1], Username: [_2]',
                    $remote_ip,
                    $username
                ),
                level    => MT::Log::SECURITY(),
                category => 'lockout',
                class    => 'author',
            }
        );

        $failedlogin->ip_locked(1);
        $failedlogin->save or die $failedlogin->errstr;

        foreach my $email (@notify_to) {
            my %head = (
                id      => 'lockout_ip',
                To      => $email,
                Subject => $app->translate('IP Address Was Locked Out')
            );

            my $recovery_time = $class->locked_out_ip_recovery_time( $app,
                $app->remote_ip );

            my $body = $app->build_email(
                'lockout-ip',
                {   ip_address    => $remote_ip,
                    username      => $username,
                    recovery_time => epoch2ts( undef, $recovery_time )
                }
            );

            require MT::Util::Mail;
            MT::Util::Mail->send_and_log( \%head, $body );
        }

        $app->run_callbacks( 'post_lockout.ip', $app, $username, $remote_ip );
    }
}

sub process_login_result {
    my $class = shift;
    my ( $app, $remote_ip, $username, $result ) = @_;

    my @for_insert = ( MT::Auth::UNKNOWN(), MT::Auth::INVALID_PASSWORD(), );
    my @for_clear = (
        MT::Auth::INACTIVE(),  MT::Auth::PENDING(),
        MT::Auth::DELETED(),   MT::Auth::REDIRECT_NEEDED(),
        MT::Auth::NEW_LOGIN(), MT::Auth::NEW_USER(),
    );

    return
        if !$app->config->IPLockoutLimit && !$app->config->UserLockoutLimit;

    if ( grep { $_ == $result } @for_insert ) {

        my $whitelist = $app->config->LockoutIPWhitelist;
        if ($whitelist) {
            my @list = split /(\s*[,;]\s*|\s+)/, $whitelist;
            foreach (@list) {
                next unless $_ =~ m/^\d{1,3}(\.\d{0,3}){0,3}$/;
                if ( ( $remote_ip eq $_ ) || ( $remote_ip =~ m/^\Q$_\E/ ) ) {
                    return;
                }
            }
        }

        $class->_insert_failedlogin( $app, $remote_ip, $username );
    }
    elsif ( grep { $_ == $result } @for_clear ) {
        $app->model('failedlogin')->remove( { remote_ip => $remote_ip } );
        if (my $user = (
                       $app->user
                    || $app->model('author')->load( { name => $username } )
            )
            )
        {
            $class->clear_failedlogin($user);
        }
    }
}

sub lock {
    my $class = shift;
    my ($user) = @_;

    return if $user->locked_out;

    my @alpha = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $salt = join '', map $alpha[ rand @alpha ], 1 .. 2;

    $user->lockout_recover_salt($salt);
    $user->locked_out_time(time);
}

sub unlock {
    my $class = shift;
    my ($user) = @_;

    return unless $user->locked_out;

    my $app = MT->instance;
    $app->log(
        {   message => $app->translate(
                'User has been unlocked. Username: [_1]',
                $user->name
            ),
            level    => MT::Log::SECURITY(),
            category => 'lockout',
            class    => 'author',
        }
    );
    $class->clear_failedlogin($user);

    $user->lockout_recover_salt(undef);
    $user->locked_out_time(0);
}

sub clear_failedlogin {
    my $class = shift;
    my ($user) = @_;

    return if !$user || !$user->id;

    my $failedlogin_class = MT->model('failedlogin');
    $failedlogin_class->remove(
        {   author_id => $user->id,
            ip_locked => { not => 1 },
        }
    );

    my $iter = $failedlogin_class->load_iter(
        {   author_id => $user->id,
            ip_locked => 1,
        }
    );
    while ( my $failedlogin = $iter->() ) {
        $failedlogin->author_id(undef);
        $failedlogin->save;
    }
}

1;

__END__

=head1 NAME

MT::Lockout - Movable Type class for user and IP address lockout feature.


=head1 SYNOPSIS

    package MyPlugin;

    use MT::Lockout;

    if ( MT::Lockout->is_locked_out_ip( $app, $remote_ip ) ) {
        my $t = MT::Lockout->locked_out_ip_recovery_time( $app, $remote_ip );
    }

    if ( MT::Lockout->is_locked_out_user( $app, $username ) ) {
        my $user = $app->model('author')->load( { name => $username } );
        MT::Lockout->unlock($user);
        $user->save;
    }

    MT::Lockout->is_locked_out( $app, $remote_ip, $username );


    $app->add_callback( 'pre_lockout',       1, undef, $callback );
    $app->add_callback( 'pre_lockout.user',  1, undef, $callback );
    $app->add_callback( 'pre_lockout.ip',    1, undef, $callback );
    $app->add_callback( 'post_lockout',      1, undef, $callback );
    $app->add_callback( 'post_lockout.user', 1, undef, $callback );
    $app->add_callback( 'post_lockout.ip',   1, undef, $callback );


=head1 METHODS

=head2 MT::Lockout->is_locked_out_ip($app, $remote_ip)

Returns 1 if given $remote_ip is locked out,
returns 0 or undef if not locked out.


=head2 MT::Lockout->locked_out_ip_recovery_time($app, $remote_ip)

Returns the time to recover from lockout in the UNIX epoch format
about given $remote_ip, returns 0 if isn't locked out.


=head2 MT::Lockout->is_locked_out_user($app, $username)

Returns 1 if given $username is locked out,
returns 0 or undef if not locked out.


=head2 MT::Lockout->is_locked_out($app, $remote_ip, $username)

Returns 1 if given $remote_ip or $username is locked out,
returns 0 or undef if not locked out.


=head2 MT::Lockout->validate_recover_token($app, $user, $token)

Returns 1 if given $token is valid for the given $user object,
returns 0 or undef if $token is not valid or $user is not locked out.


=head2 MT::Lockout->recover_token($app, $user)

Returns the token for recovering lockout, returns undef if $user is
not locked out. $user should have been set lockout_recover_salt.


=head2 MT::Lockout->recover_lockout_uri($app, $user, $args)

Returns the URI for recovering lockout, returns undef if $user is
not locked out.


=head2 MT::Lockout->process_login_result($app, $remote_ip, $username, $result)

This routine process a result of login. If given result is failure
a failed login log will be recorded. If given result is successful
all relevant failed login log is cleared.

If failed login count for given $username is reached to UserLockoutLimit,
this user is locked out.


=head2 MT::Lockout->lock($user)

This routine set the lockout status of given $user. This routine doesn't
save $user object, should save $user object after returning from this routine.


=head2 MT::Lockout->unlock($user)

This routine recover the lockout status of given $user. This routine doesn't
save $user object, should save $user object after returning from this routine.


=head2 MT::Lockout->clear_failedlogin($user)

This routine clear the failed login logs relevant to the $user.


=head1 CALLBACKS

=head2 pre_lockout.user

This callback is invoked before to Lock out the user. This callback has
the following signature:

    sub pre_lockout_user {
        my ( $cb, $app, $username, $remote_ip ) = @_;
        ...
    }

=head2 pre_lockout.ip

This callback is invoked before to Lock out the IP address. This callback has
the following signature:

    sub pre_lockout_ip {
        my ( $cb, $app, $username, $remote_ip ) = @_;
        ...
    }


=head2 post_lockout.user

This callback is invoked after to Locking out the user. This callback has
the following signature:

    sub post_lockout_user {
        my ( $cb, $app, $username, $remote_ip ) = @_;
        ...
    }


=head2 post_lockout.ip

This callback is invoked after to Locking out the IP address. This callback
has the following signature:

    sub post_lockout_ip {
        my ( $cb, $app, $username, $remote_ip ) = @_;
        ...
    }


=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
