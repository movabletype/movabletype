# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Tag;

use strict;
use warnings;

use MT::Tag;

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $user = $app->user;

    my $terms = $load_options->{terms};

    if ( !( $user->is_superuser || $user->can_do('access_to_tag_list') ) ) {
        $terms->{is_private} = [ 0, \'= IS NULL' ],;
    }

    my $blog_id = exists $terms->{blog_id} ? delete $terms->{blog_id} : undef;
    my $args = $load_options->{args};
    $args->{joins} ||= [];

    push @{ $args->{joins} },
        MT->model('objecttag')->join_on(
        'tag_id',
        { defined $blog_id ? ( blog_id => $blog_id ) : () },
        { unique => 1 },
        );
}

# Can view private tags if user having permission.
sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();

    if ( my $user = $app->user ) {
        return 1 if $user->is_superuser;
        if ( $app->blog && $app->blog->id ) {
            my $perms = $user->permissions( $app->blog->id ) or return;
            return 1
                if $perms->can_do('access_to_tag_list')
                && $perms->can_do('edit_tags');
        }
        else {
            return 1 if $user->permissions(0)->can_do('administer');
        }
    }

    return !$obj->is_private;
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;
    return 1 if $user->is_superuser;

    if ( $app->blog && $app->blog->id ) {
        my $perms = $user->permissions( $app->blog->id );
        return $perms->can_do('edit_tags') && $perms->can_do('rename_tag');
    }
    else {
        return $user->permissions(0)->can_do('administer');
    }
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    my $n8d = MT::Tag->normalize( $obj->name );
    return $app->errtrans( 'Invalid tag name: [_1]', $obj->name )
        if !( defined($n8d) && length($n8d) );

    return 1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;
    return 1 if $user->is_superuser();

    if ( $app->blog && $app->blog->id ) {
        return $user->permissions( $app->blog->id )->can_do('remove_tag');
    }
    else {
        return $user->permissions(0)->can_do('administer');
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Tag - Movable Type class for Data API's callbacks about the MT::Tag.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
