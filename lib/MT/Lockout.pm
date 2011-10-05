# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Lockout;

use strict;

use MT::Auth;
use MT::Util qw(is_valid_email epoch2ts);
use MT::Author;

sub is_locked_out_ip {
    my $class = shift;
    my ( $app, $remote_ip ) = @_;
    my $limit = $app->config->IPLockoutLimit
        or return 0;

    my $count = $app->model('failedlogin')->count(
        {   remote_ip => $remote_ip,
            start     => [ time - $app->config->IPLockoutDuration, undef ]
        },
        { range => { start => 1, } }
    );

    $count >= $limit;
}

sub locked_out_ip_recovery_time {
    my $class = shift;
    my ( $app, $remote_ip ) = @_;
    my $limit = $app->config->IPLockoutLimit
        or return 0;

    my $old = $app->model('failedlogin')->load(
        {   remote_ip => $remote_ip,
            start     => [ time - $app->config->IPLockoutDuration, undef ]
        },
        {   range     => { start => 1, },
            sort      => 'start',
            direction => 'ascend',
            limit     => 1
        }
    ) or return 0;

    $old->start + $app->config->IPLockoutDuration;
}

sub is_locked_out_user {
    my $class = shift;
    my ( $app, $username ) = @_;

    return 0 if ( !$app->config->UserLockoutLimit ) || ( !$username );

    my $user = $app->model('author')->load( { name => $username } )
        or return 0;

    $user->lockout;
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

    my $sha256_hex;
    if ( eval { require Digest::SHA } ) {
        $sha256_hex = \&Digest::SHA::sha256_hex;
    }
    else {
        require Digest::SHA::PurePerl;
        $sha256_hex = \&Digest::SHA::PurePerl::sha256_hex;
    }

    return undef unless $user->lockout_recover_salt;

    $sha256_hex->(
        $user->lockout_recover_salt . $app->config->SecretToken );
}

sub recover_lockout_uri {
    my $class = shift;
    my ( $app, $user, $args ) = @_;

    my $token = $class->recover_token( $app, $user );
    $app->uri(
        'mode' => 'recover_lockout',
        args   => {
            user_id => $user->id,
            token   => $token,
            ($args ? %$args : ()),
        }
    );
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
                            "Can't find author for id '[_1]'", $id
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

sub _merge_notiry_to {
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

    if ($author_id) {
        my $count = $app->model('failedlogin')->count(
            {   author_id => $author_id,
                start => [ time - $app->config->UserLockoutDuration, undef ]
            },
            { range => { start => 1, } }
        );

        if ( $count >= $app->config->UserLockoutLimit ) {
            $app->run_callbacks( 'pre_lockout.user', $app, $username,
                $remote_ip );

            $app->log(
                {   message => $app->translate(
                        'User was locked out. IP address: [_1], Username: [_2]',
                        $remote_ip,
                        $username
                    ),
                    level    => MT::Log::SECURITY(),
                    category => 'lockout',
                    class    => 'author',
                }
            );

            $class->lock($user);
            $user->save or die $user->errstr;

            foreach my $email (
                $class->_merge_notiry_to( @notify_to, $user->email ) )
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

                require MT::Mail;
                MT::Mail->send( \%head, $body )
                    or $app->log(
                    {   message => $app->translate(
                            'Error sending mail: [_1]',
                            MT::Mail->errstr
                        ),
                        level    => MT::Log::ERROR(),
                        class    => 'system',
                        category => 'email'
                    }
                    );
            }

            $app->run_callbacks( 'post_lockout.user', $app, $username,
                $remote_ip );
        }
    }

    if ( $class->is_locked_out_ip( $app, $remote_ip ) ) {
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

        foreach my $email (@notify_to) {
            my %head = (
                id      => 'lockout_ip',
                To      => $email,
                Subject => $app->translate('IP address Was Locked Out')
            );

            my $recovery_time
                = $class->locked_out_ip_recovery_time( $app, $app->remote_ip );

            my $body = $app->build_email(
                'lockout-ip',
                {   ip_address   => $remote_ip,
                    username     => $username,
                    recovery_time => epoch2ts( undef, $recovery_time )
                }
            );

            require MT::Mail;
            MT::Mail->send( \%head, $body )
                or $app->log(
                {   message => $app->translate(
                        'Error sending mail: [_1]',
                        MT::Mail->errstr
                    ),
                    level    => MT::Log::ERROR(),
                    class    => 'system',
                    category => 'email'
                }
                );
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

        my $cancel_insert
            = $app->callback_is_enabled('lockout_filter')
            ? $app->run_callbacks( 'lockout_filter', $app, $username,
            $remote_ip )
            : 0;

        if ( !$cancel_insert ) {
            $class->_insert_failedlogin( $app, $remote_ip, $username );
        }
    }
    elsif ( grep { $_ == $result } @for_clear ) {
        $app->model('failedlogin')->remove( { remote_ip => $remote_ip } );
        if ( my $user = $app->model('author')->load( { name => $username } ) )
        {
            $app->model('failedlogin')->remove( { author_id => $user->id } );
        }
    }
}

sub lock {
    my $class = shift;
    my ($user) = @_;

    return if $user->lockout != MT::Author::NOT_LOCKED_OUT;

    my @alpha = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $salt = join '', map $alpha[ rand @alpha ], 1 .. 2;

    $user->lockout_recover_salt($salt);
    $user->lockout(MT::Author::LOCKED_OUT);
}

sub unlock {
    my $class = shift;
    my ($user) = @_;

    return if $user->lockout != MT::Author::LOCKED_OUT;

    my $app = MT->instance;
    $app->log(
        {   message => $app->translate(
                'User has been recovered from locked out. Username: [_1]',
                $user->name
            ),
            level    => MT::Log::SECURITY(),
            category => 'lockout',
            class    => 'author',
        }
    );
    $app->model('failedlogin')->remove( { author_id => $user->id } );

    $user->lockout_recover_salt(undef);
    $user->lockout(MT::Author::NOT_LOCKED_OUT);
}

1;
