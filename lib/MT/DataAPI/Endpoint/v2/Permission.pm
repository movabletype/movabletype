# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Permission;

use strict;
use warnings;

use MT::Association;
use MT::Permission;
use MT::Role;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_for_user {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;
    my $current_user = $app->user;

    return $app->error(403)
        if ( $user->id != $current_user->id && !$current_user->is_superuser );

    my %terms = ( permissions => { not => '' }, );
    my %args;
    my %options = ( user => $user );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user or return;

    my %terms = (
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args;
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects}, ),
    };
}

sub list_for_site {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user or return;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my %terms = (
        blog_id     => $site->id,
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args;
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_role {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user or return;

    my ($role) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'role', $role->id, obj_promise($role) )
        or return;

    my %terms = (
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args = (
        join => MT->model('association')->join_on(
            undef,
            {   author_id => \'= permission_author_id',
                blog_id   => \'= permission_blog_id',
                role_id   => $role->id,
            },
        ),
    );
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _can_grant {
    my ( $app, $site, $role ) = @_;
    my $login_user = $app->user or return;
    my $perms = $login_user->permissions( $site->id );

    return 1 if $login_user->is_superuser;

    if ( !$perms->can_do('grant_administer_role') ) {
        return if !$perms->can_do('grant_role_for_blog');
        return if $role->has('administer_site');
    }

    return 1;
}

sub _grant {
    my ( $app, $param_user, $role, $site ) = @_;

    MT::Association->link( $param_user, $role, $site )
        or return $app->error(
        $app->translate(
            'Granting permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    return 1;
}

sub _retrieve_user_from_param {
    my ($app) = @_;

    my $user_id = $app->param('user_id');
    if ( !defined $user_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'user_id' ),
            400 );
    }

    my $user = $app->model('author')->load($user_id)
        or return $app->error( $app->translate( 'User not found', $user_id ),
        404 );

    return $user;
}

sub _retrieve_role_from_param {
    my ($app) = @_;

    my $role_id = $app->param('role_id');
    if ( !defined $role_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'role_id' ),
            400 );
    }

    my $role = $app->model('role')->load($role_id)
        or return $app->error( $app->translate( 'Role not found', $role_id ),
        404 );

    return $role;
}

sub grant_to_site {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $param_user = _retrieve_user_from_param($app) or return;
    my $role       = _retrieve_role_from_param($app) or return;

    if ( !_can_grant( $app, $site, $role ) ) {
        return $app->error(403);
    }

    _grant( $app, $param_user, $role, $site ) or return;

    return +{ status => 'success' };
}

sub _can_revoke {
    my ( $app, $site, $role ) = @_;
    my $login_user = $app->user or return;
    my $perms = $login_user->permissions( $site->id );

    return 1 if $login_user->is_superuser;

    return if !$perms->can_do('revoke_role');
    return
        if !$perms->can_do('revoke_administer_role')
        && $role->has('administer_site');

    return 1;
}

sub revoke_from_site {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $param_user = _retrieve_user_from_param($app) or return;
    my $role       = _retrieve_role_from_param($app) or return;

    if ( !_can_revoke( $app, $site, $role ) ) {
        return $app->error(403);
    }

    MT::Association->unlink( $site, $role, $param_user )
        or return $app->error(
        $app->translate(
            'Revoking permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    return +{ status => 'success' };
}

sub _retrieve_site_from_param {
    my ($app) = @_;

    my $site_id = $app->param('site_id');
    if ( !defined $site_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'site_id' ),
            400 );
    }

    my $site = $app->model('blog')->load($site_id);
    if ( !( $site && $site->id ) ) {
        return $app->error( $app->translate( 'Site not found', $site_id ),
            404 );
    }

    return $site;
}

sub grant_to_user {
    my ( $app, $endpoint ) = @_;

    my ($param_user) = context_objects(@_);
    return if !( $param_user && $param_user->id );

    my $site = _retrieve_site_from_param($app) or return;
    my $role = _retrieve_role_from_param($app) or return;

    if ( !_can_grant( $app, $site, $role ) ) {
        return $app->error(403);
    }

    _grant( $app, $param_user, $role, $site ) or return;

    return +{ status => 'success' };
}

sub revoke_from_user {
    my ( $app, $endpoint ) = @_;

    my ($param_user) = context_objects(@_);
    return if !( $param_user && $param_user->id );

    my $site = _retrieve_site_from_param($app) or return;
    my $role = _retrieve_role_from_param($app) or return;

    if ( !_can_revoke( $app, $site, $role ) ) {
        return $app->error(403);
    }

    MT::Association->unlink( $site, $role, $param_user )
        or return $app->error(
        $app->translate(
            'Revoking permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    return +{ status => 'success' };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Permission - Movable Type class for endpoint definitions about the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
