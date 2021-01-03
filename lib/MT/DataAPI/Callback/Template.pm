# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Template;

use strict;
use warnings;

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    if ( defined $app->param('blog_id') ) {

        # list_templates endpoint.
        return $app->permissions->can_edit_templates;
    }
    else {

        # list_all_templates endpoint.

        # A user having "edit_templates" permission in system scope
        # can view all templates.
        return 1 if $app->user->permissions(0)->can_edit_templates;

        my $iter = $app->model('permission')->load_iter(
            {   author_id => $app->user->id,
                blog_id   => { not => 0 },
            }
        );
        my @blog_id;
        while ( my $perm = $iter->() ) {
            push @blog_id, $perm->blog_id if $perm->can_edit_templates;
        }

        # No permissions.
        return unless @blog_id;

        $terms->{blog_id} = \@blog_id;
        return 1;
    }
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    return 1 if $app->user->can_edit_templates;
    if ($id) {
        my $obj = $objp->force();
        return 0
            unless $app->user->permissions( $obj->blog_id )
            ->can_do('edit_templates');
    }
    else {
        my $perms = $app->permissions;
        return 0
            unless $perms && $perms->can_do('edit_templates');
    }
    return 1;
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    my @not_empty_columns = qw( name type );
    for my $col (@not_empty_columns) {
        if ( !defined( $obj->$col ) || $obj->$col eq '' ) {
            return $app->errtrans( 'A parameter "[_1]" is required.', $col );
        }
    }

    if ( !$obj->id ) {
        my @archive_types
            = qw/ index archive individual page category custom /;
        push @archive_types, qw/ ct ct_archive /
            if $app->current_api_version >= 4;
        if ( $obj->blog_id && !( grep { $obj->type eq $_ } @archive_types ) )
        {
            return $app->errtrans( 'Invalid type: [_1]', $obj->type );
        }

        if ( !$obj->blog_id && $obj->type ne 'custom' ) {
            return $app->errtrans( 'Invalid type: [_1]', $obj->type );
        }
    }

    if ( $obj->type eq 'index'
        && ( !defined( $obj->outfile ) || $obj->outfile eq '' ) )
    {
        return $app->errtrans( 'A parameter "[_1]" is required.',
            'outputFile' );
    }

    if (   $app->current_api_version >= 4
        && $obj->type =~ /^ct(?:\_archive)?$/
        && !$obj->content_type_id )
    {
        return $app->errtrans( 'A parameter "[_1]" is required.',
            'contentType' );
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Template - Movable Type class for Data API's callbacks about the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
