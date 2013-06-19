# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Callback::Entry;

use strict;
use warnings;

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    if (   defined( $app->param('status') )
        && lc( $app->param('status') ) ne 'publish'
        && $app->user->is_anonymous )
    {
        return 0;
    }

    1;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    return 0 unless $obj->is_entry;
    return 1 if $obj->status == MT::Entry::RELEASE();
    if ( !$app->user->permissions( $obj->blog_id )
        ->can_edit_entry( $obj, $app->user ) )
    {
        return 0;
    }
    1;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $terms = $load_options->{terms} ||= {};
    my $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};

    my %filters = ();
    for my $id ( ref $blog_ids ? @$blog_ids : $blog_ids ) {
        $filters{ $id || 0 } = {
            ( $id ? ( blog_id => $id ) : () ),
            status => MT::Entry::RELEASE()
        };
    }

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    while ( my $perm = $iter->() ) {
        my $blog_id = $perm->blog_id;
        if (   $perm->can_do('publish_all_entry')
            || $perm->can_do('edit_all_entries') )
        {
            $filters{$blog_id} = { blog_id => $blog_id, };
        }
    }

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    push @$new_terms,
        ( '-and', %filters ? [ values %filters ] : { blog_id => 0 } );
    $load_options->{terms} = $new_terms;

    1;
}

1;
