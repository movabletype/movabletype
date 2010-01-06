# Movable Type (r) Open Source (C) 2001-2010 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Userpic;

use strict;

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
    my ($ctx, $args, $cond) = @_;

    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry'); 
        $author = $e->author if $e; 
    }
    return $ctx->_no_author_error() unless $author;
    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

###########################################################################

=head2 EntryAuthorUserpic

Outputs the HTML for the userpic of the author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author or return '';
    return $a->userpic_html() || '';
}

###########################################################################

=head2 EntryAuthorUserpicURL

Outputs the URL for the userpic image of the author for the current entry
in context.

=cut

sub _hdlr_entry_author_userpic_url {
    my ($ctx) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $a = $e->author or return '';
    return $a->userpic_url() || '';
}

###########################################################################

=head2 EntryAuthorUserpicAsset

A block tag providing an asset context for the userpic of the
author for the current entry in context. See the L<Assets> tag
for more information about publishing assets.

=cut

sub _hdlr_entry_author_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $author = $e->author;
    return '' unless $author;

    my $asset = $author->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    return $builder->build($ctx, $tok, { %$cond });
}

###########################################################################

=head2 CommenterUserpic

This template tag returns a complete HTML C<img> tag for the current
commenter's userpic. For example:

    <img src="http://yourblog.com/userpics/1.jpg" width="100" height="100" />

B<Example:>

    <h2>Recent Commenters</h2>
    <mt:Entries recently_commented_on="10">
        <div class="userpic" style="float: left; padding: 5px;"><$mt:CommenterUserpic$></div>
    </mt:Entries>

=for tags comments

=cut

sub _hdlr_commenter_userpic {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->userpic_html() || '';
}

###########################################################################

=head2 CommenterUserpicURL

This template tag returns the URL to the image of the current
commenter's userpic.

B<Example:>

    <img src="<$mt:CommenterUserpicURL$>" />

=for tags comments

=cut

sub _hdlr_commenter_userpic_url {
    my ($ctx) = @_;
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->userpic_url() || '';
}

###########################################################################

=head2 CommenterUserpicAsset

This template tag is a container tag that puts the current commenter's
userpic asset in context. Because userpics are stored as assets within
Movable Type, this allows you to utilize all of the asset-related
template tags when displaying a user's userpic.

B<Example:>

     <mt:CommenterUserpicAsset>
        <img src="<$mt:AssetThumbnailURL width="20" height="20"$>"
            width="20" height="20"  />
     </mt:CommenterUserpicAsset>

=for tags comments, assets

=cut

sub _hdlr_commenter_userpic_asset {
    my ($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter');
    # undef means commenter has no commenter_id
    # need default userpic asset? do nothing now.
    return '' unless $cmntr;

    my $asset = $cmntr->userpic or return '';

    my $tok = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    local $ctx->{__stash}{asset} = $asset;
    $builder->build($ctx, $tok, { %$cond });
}

1;
