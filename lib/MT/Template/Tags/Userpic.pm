# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Userpic;

use strict;
use warnings;

use MT;
use MT::Asset;

###########################################################################

=head2 AuthorUserpic

This template tags returns a complete HTML <img> tag representing the
current author's userpic. For example:

    <img src="http://www.yourblog.com/path/to/userpic.jpg"
        width="100" height="100" />

=for tags authors, userpics

=cut

sub _hdlr_author_userpic {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    return $author->userpic_html() || '';
}

###########################################################################

=head2 AuthorUserpicURL

This template tag returns the fully qualified URL for the userpic of
the author currently in context.

If the author has no userpic, this will output an empty string.

=for tags authors, userpics

=cut

sub _hdlr_author_userpic_url {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    return $author->userpic_url() || '';
}

###########################################################################

=head2 AuthorUserpicAsset

This container tag creates a context that contains the userpic asset for
the current author. This then allows you to use all of Movable Type's
asset template tags to display the userpic's properties.

    <ul><mt:Authors>
         <mt:AuthorUserpicAsset>
           <li>
             <img src="<$mt:AssetThumbnailURL width="20" height="20"$>"
                width="20" height="20"  />
             <$mt:AuthorName$>
           </li>
         </mt:AuthorUserpicAsset>
    </mt:Authors></ul>

=for tags authors, userpics, assets

=cut

sub _hdlr_author_userpic_asset {
    my ( $ctx, $args, $cond ) = @_;

    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    my $asset = $author->userpic or return '';

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build( $ctx, $tok, {%$cond} );
}

###########################################################################

=head2 EntryAuthorUserpic, EntryModifiedAuthorUserpic

Outputs the HTML for the userpic of the (last modified) author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author or return '';
    return $author->userpic_html() || '';
}

sub _hdlr_entry_modified_author_userpic {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author or return '';
    return $author->userpic_html() || '';
}

###########################################################################

=head2 EntryAuthorUserpicURL, EntryModifiedAuthorUserpicURL

Outputs the URL for the userpic image of the (last modified) author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic_url {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author or return '';
    return $author->userpic_url() || '';
}

sub _hdlr_entry_modified_author_userpic_url {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author or return '';
    return $author->userpic_url() || '';
}

###########################################################################

=head2 EntryAuthorUserpicAsset, EntryModifiedAuthorUserpicAsset

A block tag providing an asset context for the userpic of the
(last modified) author for the current entry in context. See the L<Assets> tag
for more information about publishing assets.

=cut

sub _hdlr_entry_author_userpic_asset {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build( $ctx, $tok, {%$cond} );
}

sub _hdlr_entry_modified_author_userpic_asset {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->modified_author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build( $ctx, $tok, {%$cond} );
}

1;
