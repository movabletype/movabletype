# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Comment;

use strict;
use warnings;

use MT::Template::Context;
use MT::Util qw( remove_html );
use MT::DataAPI::Resource::Comment;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];
}

sub fields {
    [   {   name        => 'body',
            alias       => 'text',
            from_object => sub {
                my ($obj) = @_;
                return _from_object($obj);
            },
        },
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

sub _from_object {
    my ($obj) = @_;
    my $app   = MT->instance;
    my $user  = $app->user;
    my $blog  = $obj->blog;

    my $text;

    if ( $user && $user->id && $app->param('no_text_filter') ) {
        if ( $blog->allow_comment_html ) {
            $text = $obj->text;
        }
        else {
            $text = remove_html( $obj->text );
        }
    }
    else {
        $text = _apply_text_filters( $app, $obj );
    }

    MT::DataAPI::Resource::Comment::sanitize_text( $obj, $text );
}

sub _apply_text_filters {
    my ( $app, $obj ) = @_;

    my $blog = $obj->blog;

    my $t = $obj->text;
    $t = '' if !defined $t;

    unless ( $blog->allow_comment_html ) {
        $t = remove_html($t);
    }

    my $convert_breaks = $blog->convert_paras_comments;

    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'comment', $obj );
    if ( my $entry = $obj->entry ) {
        $ctx->stash( 'entry', $entry );
    }
    if ($blog) {
        $ctx->stash( 'blog_id', $blog->id || 0 );
        $ctx->stash( 'blog', $blog );
    }

    $t
        = $convert_breaks
        ? MT->apply_text_filters( $t, $blog->comment_text_filters, $ctx )
        : $t;

    return $t;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Comment - Movable Type class for resources definitions of the MT::Comment.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
