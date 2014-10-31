# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Log;

use strict;
use warnings;

sub can_view {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;

    return 1 if $user->is_superuser;
    return 1 if $user->permissions(0)->can_do('view_log');
    return 1
        if $obj->blog_id
        && $user->permissions( $obj->blog_id )->can_do('view_blog_log');

    return;
}

sub can_save {
    can_view(@_);
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    if ( !defined $obj->message || $obj->message eq '' ) {
        return $app->errtrans('A paramter "message" is required.');
    }

    if ( $obj->author_id && !MT->model('author')->load( $obj->author_id ) ) {
        return $app->errtrans( 'author_id (ID:[_1] is invalid.',
            $obj->author_id );
    }

    return 1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;

    if ( my $site_id = $obj->blog_id ) {
        my $perms = $user->permissions($site_id) or return;
        return $perms->can_do('reset_blog_log');
    }
    else {
        my $sys_perms = $user->permissions(0) or return;
        return $sys_perms->can_do('reset_system_log');
    }
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Log (ID:[_1]) deleted by '[_2]'", $obj->id,
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'log',
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
