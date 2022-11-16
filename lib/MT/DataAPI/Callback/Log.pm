# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Log;

use strict;
use warnings;

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;

    return 1 if $user->is_superuser;
    return 1 if $user->permissions(0)->can_do('view_log');

    my $blog_id = $obj ? $obj->blog_id : $app->blog->id;
    return 1
        if $blog_id
        && $user->permissions($blog_id)->can_do('view_blog_log');

    return;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    can_save( $eh, $app, $obj );
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    if ( !defined $obj->message || $obj->message eq '' ) {
        return $app->errtrans( 'A parameter "[_1]" is required.', 'message' );
    }

    if ( $obj->author_id && !MT->model('author')->load( $obj->author_id ) ) {
        return $app->errtrans( 'author_id (ID:[_1]) is invalid.',
            $obj->author_id );
    }

    return 1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;

    if ( my $sys_perms = $user->permissions(0) ) {
        return 1 if $sys_perms->can_do('reset_system_log');
    }

    if ( my $site_id = $obj->blog_id ) {
        my $perms = $user->permissions($site_id) or return;
        return $perms->can_do('reset_blog_log');
    }

    return;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Log (ID:[_1]) deleted by '[_2]'", $obj->id,
                $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'log',    ## trans('log')
            category => 'delete'
        }
    );
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Log - Movable Type class for Data API's callbacks about the MT::Log.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
