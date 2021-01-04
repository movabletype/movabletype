# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Page;

use strict;
use warnings;

use MT::Entry;
use MT::DataAPI::Callback::Entry;

sub can_list {
    return MT::DataAPI::Callback::Entry::can_list(@_);
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    return 0 if $obj->is_entry;
    return 1 if $obj->status == MT::Entry::RELEASE();
    if ( !$app->user->permissions( $obj->blog_id )
        ->can_do('open_page_edit_screen') )
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
    my $blog_ids;
    $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};

    my $make_week_perm_filter = sub {
        my ($blog_id) = @_;

        my @f = ();

        if ($blog_id) {
            push @f, { blog_id => $blog_id }, '-and';
        }

        push @f,
            [
            { status => MT::Entry::RELEASE(), },
            '-or',
            { author_id => $user->id, }
            ];

        \@f;
    };

    my %filters = ();
    for my $id ( ref $blog_ids ? @$blog_ids : $blog_ids ) {
        $filters{ $id || 0 } = $make_week_perm_filter->($id);
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
        if ( $perm->can_do('manage_pages') ) {
            $filters{$blog_id} = { blog_id => $blog_id, };
        }
        else {
            $filters{$blog_id} = $make_week_perm_filter->($blog_id);
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

sub save_filter {
    MT::DataAPI::Callback::Entry::save_filter(@_);
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Page - Movable Type class for Data API's callbacks about the MT::Page.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

