# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::User::v2;

use strict;
use warnings;

use MT::Author;
use MT::Permission;
use MT::Lockout;
use MT::CMS::Tools;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'author' ) or return;

    return +{
        totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my $orig_user = $app->model('author')->new;

    $orig_user->set_values(
        {   nickname    => '',
            text_format => 0,
        }
    );

    my $new_user = $app->resource_object( 'user', $orig_user )
        or return;

    save_object( $app, 'author', $new_user, $orig_user ) or return;

    # Grant system permissions.
    if (   $app->user->is_superuser
        && $new_user->status == MT::Author::ACTIVE() )
    {

        my $user_json = $app->param('user');
        my $user_hash = $app->current_format->{unserialize}->($user_json);
        if ( exists $user_hash->{systemPermissions} ) {
            my $perms = $user_hash->{systemPermissions};
            my @perms = ref($perms) eq 'ARRAY' ? @$perms : ($perms);

            for my $p (@perms) {
                next if !defined($p);

                if ( $p eq 'administer' ) {
                    $new_user->is_superuser(1);
                    last;
                }
                else {
                    my $name = 'can_' . $p;
                    eval $new_user->$name(1);
                }
            }

            $new_user->save
                or return $app->error(
                $app->translate(
                    'Saving [_1] failed: [_2]', $new_user->class_label,
                    $new_user->errstr
                ),
                500
                );
        }
    }

    return $new_user;
}

# Update.
sub update {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    my $new_user = $app->resource_object( 'user', $user )
        or return;

    save_object( $app, 'author', $new_user, $user )
        or return;

    # Update system permissions.
    if (   $app->user->is_superuser
        && $new_user->status == MT::Author::ACTIVE()
        && $app->user->id != $new_user->id )
    {

        my $user_json = $app->param('user');
        my $user_hash = $app->current_format->{unserialize}->($user_json);
        if ( exists $user_hash->{systemPermissions} ) {
            my $perms = $user_hash->{systemPermissions};
            my @perms = ref($perms) eq 'ARRAY' ? @$perms : ($perms);

            my $sys_perms = MT::Permission->perms('system');
            my @sys_perms = map { $_->[0] } @$sys_perms;

            for my $p (@sys_perms) {
                next if !defined($p);

                my $can_do = ( grep { $p eq $_ } @perms ) ? 1 : 0;

                if ( $p eq 'administer' ) {
                    $new_user->is_superuser($can_do);
                }
                else {
                    my $name = 'can_' . $p;
                    $new_user->$name($can_do);
                }
            }

            $new_user->save
                or return $app->error(
                $app->translate(
                    'Saving [_1] failed: [_2]', $new_user->class_label,
                    $new_user->errstr
                ),
                500
                );
        }
    }

    $new_user;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ($user) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'author', $user )
        or return;

    $user->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $user->class_label,
            $user->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.author', $app, $user );

    return $user;
}

sub unlock {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->user->is_superuser;

    my ($user) = context_objects(@_) or return;

    MT::Lockout->unlock($user);
    $user->save
        or $app->error(
        $app->translate( 'Saving object failed: [_1]', $user->errstr ), 500 );

    return +{ status => 'success' };
}

sub recover_password {
    my ( $app, $endpoint ) = @_;

    if ( !( $app->user->is_superuser() && MT::Auth->can_recover_password ) ) {
        return $app->error(403);
    }

    my ($user) = context_objects(@_) or return;

    my ( $rc, $res )
        = MT::CMS::Tools::reset_password( $app, $user, $user->hint );

    if ($rc) {
        return +{ status => 'success', message => $res };
    }
    else {
        return $app->error( $res, 500 );
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::User::v2 - Movable Type class for endpoint definitions about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
