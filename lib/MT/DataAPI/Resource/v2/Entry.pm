# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::v2::Entry;

use strict;
use warnings;

use MT::Category;
use MT::Template::Context;
use MT::DataAPI::Resource;

sub updatable_fields {
    [   qw(
            format
            ),
        {   name      => 'unpublishedDate',
            condition => sub {
                MT->instance->can_do('edit_entry_unpublished_on');
            },
        },
    ];
}

sub fields {
    [   {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );

                MT::DataAPI::Resource->from_object(
                    [   sort {
                                  $a->id == $primary ? -1
                                : $b->id == $primary ? 1
                                : $a->label cmp $b->label
                        } @$cats
                    ],
                    [qw( id label parent )],
                );
            },
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id     => { type => 'integer' },
                        label  => { type => 'string' },
                        parent => { type => 'string' },
                    },
                },
            },
        },
        {   name      => 'unpublishedDate',
            alias     => 'unpublished_on',
            type      => 'MT::DataAPI::Resource::DataType::ISO8601',
            condition => sub {
                my $app  = MT->instance or return;
                my $user = $app->user   or return;
                return $user->id ? 1 : 0;
            },
        },
        {   name      => 'format',
            alias     => 'convert_breaks',
            condition => sub {
                my $app  = MT->instance or return;
                my $user = $app->user   or return;
                return $user->id ? 1 : 0;
            },
        },
        {    # Update.
            name                => 'body',
            alias               => 'text',
            from_object_default => '',
            from_object         => sub {
                my ($obj) = @_;
                return _from_object_text( $obj, 'text' );
            },
        },
        {    # Update.
            name                => 'more',
            alias               => 'text_more',
            from_object_default => '',
            from_object         => sub {
                my ($obj) = @_;
                return _from_object_text( $obj, 'text_more' );
            },
        },
    ];
}

sub _from_object_text {
    my ( $obj, $col ) = @_;
    my $app  = MT->instance;
    my $user = $app->user;

    if ( $user && $user->id && ($app->param('no_text_filter') || $app->param('noTextFilter')) ) {
        return $obj->$col;
    }
    else {
        return _apply_text_filters( $app, $obj, $col );
    }
}

sub _apply_text_filters {
    my ( $app, $obj, $col ) = @_;

    my $blog = $obj->blog;
    my $convert_breaks
        = defined $obj->convert_breaks
        ? $obj->convert_breaks
        : ( $blog ? $blog->convert_paras : '__default__' );

    if ($convert_breaks) {
        my $ctx = MT::Template::Context->new;
        $ctx->stash( 'entry', $obj );
        if ($blog) {
            $ctx->stash( 'blog_id', $blog->id || 0 );
            $ctx->stash( 'blog', $blog );
        }

        my $filters = $obj->text_filters;
        push @$filters, '__default__' unless @$filters;
        my $text = MT->apply_text_filters( $obj->$col, $filters, $ctx );
        return $text;
    }
    else {
        return $obj->$col;
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Entry - Movable Type class for resources definitions of the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
