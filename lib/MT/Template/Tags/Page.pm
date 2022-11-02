# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Page;

use strict;
use warnings;

use MT;

###########################################################################

=head2 AuthorHasPage

A conditional tag that is true when the author currently in context
has written one or more pages that have been published.

=for tags authors, pages

=cut

sub _hdlr_author_has_page {
    my ($ctx) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error();

    my %terms;
    $terms{blog_id}   = $ctx->stash('blog_id');
    $terms{author_id} = $author->id;
    $terms{class}     = 'page';
    $terms{status}    = MT::Entry::RELEASE();

    my $class = MT->model('page');
    $class->exist( \%terms );
}

###########################################################################

=head2 Pages

A container tag which iterates over a list of pages--which pages depends
on the context the tag is being used in. Within each iteration, you can
use any of the page variable tags.

Because pages are basically non-date-based entries, the the C<Pages>
tag is very similar to L<Entries>.

B<Attributes unique to the Pages tag:>

=over 4

=item * folder or folders (optional)

This attribute allows you to filter the pages based on their folder label.
Please see the mt:Entries analogous category/categories attributes of
for details.

=item * no_folder (optional)

This attribute filters the pages to return only those not contained in
a folder.

=item * include_subfolders (optional)

Specify '1' to cause all pages that may exist within subfolders to the
folder in context to be included.

=back

=for tags pages, multiblog

=cut

sub _hdlr_pages {
    my ( $ctx, $args, $cond ) = @_;

    my $folder = $args->{folder} || $args->{folders};
    $args->{categories} = $folder if $folder;

    if ( $args->{no_folder} ) {
        require MT::Folder;
        my $blog_id = $ctx->stash('blog_id');
        my @fols = MT::Folder->load( { blog_id => $blog_id } );
        my $not_folder;
        foreach my $folder (@fols) {
            if ($not_folder) {
                $not_folder .= " OR " . $folder->label;
            }
            else {
                $not_folder = $folder->label;
            }
        }
        if ($not_folder) {
            $args->{categories} = "NOT ($not_folder)";
        }
    }

    # remove current_timestamp;
    local $ctx->{current_timestamp};
    local $ctx->{current_timestamp_end};

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    $ctx->invoke_handler( 'entries', $args, $cond );
}

###########################################################################

=head2 PagePrevious

A container tag that create a context to the previous page.

=for tags pages, archives

=cut

sub _hdlr_page_previous {
    my ( $ctx, $args, $cond ) = @_;

    return undef unless $ctx->check_page;
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    $ctx->invoke_handler( 'entryprevious', $args, $cond );
}

###########################################################################

=head2 PageNext

A container tag that create a context to the next page.

=for tags pages, archives

=cut

sub _hdlr_page_next {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    return undef unless $ctx->check_page;
    $ctx->invoke_handler( 'entrynext', $args, $cond );
}

###########################################################################

=head2 PagesHeader

The contents of this container tag will be displayed when the first page
listed by a L<Pages> tag is reached.

B<Example:>

    <mt:Pages glue=", ">
        <mt:PagesHeader>
            The following pages are available:
        </mt:PagesHeader>
        <a href="<$mt:PagePermalink$>"><$mt:PageTitle$></a>
    </mt:Pages>

=for tags pages

=cut

###########################################################################

=head2 PagesFooter

The contents of this container tag will be displayed when the last page
listed by a L<Pages> tag is reached.

=for tags pages

=cut

###########################################################################

=head2 PageID

A numeric system ID of the Page currently in context.

B<Example:>

    <$mt:PageID$>

=cut

sub _hdlr_page_id {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryid', @_ );
}

###########################################################################

=head2 PageTitle

The title of the page in context.

B<Example:>

    <$mt:PageTitle$>

=for tags pages

=cut

sub _hdlr_page_title {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrytitle', @_ );
}

###########################################################################

=head2 PageBody

This tag outputs the contents of the page's Body field.

If a text formatting filter has been specified, it will automatically applied.

B<Attributes:>

=over 4

=item * words

Trims the number of words to display. By default all are displayed.

=item * convert_breaks

Controls the application of text formatting. By default convert_breaks is 0
(false). This should only be used if text formatting is set to "none" in the
Entry/Page editor.

=back

B<Example:>

    <$mt:PageBody$>

=for tags pages

=cut

sub _hdlr_page_body {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrybody', @_ );
}

###########################################################################

=head2 PageMore

This tag outputs the contents of the page's Extended field.

If a text formatting filter has been specified it will automatically applied.

B<Attributes:>

=over 4

=item * convert_breaks (optional)

Controls the application of text formatting. By default convert_breaks is 0
(false). This should only be used if text formatting is set to "none" in the
Entry/Page editor.

=back

B<Example:>

    <$mt:PageMore$>

=for tags pages

=cut

sub _hdlr_page_more {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymore', @_ );
}

###########################################################################

=head2 PageDate

The authored on timestamp for the page.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:PageDate$>

=for tags pages, date

=cut

sub _hdlr_page_date {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrydate', @_ );
}

###########################################################################

=head2 PageModifiedDate

The last modified timestamp for the page.

B<Attributes:>

=over 4

=item * format

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language

Forces the date to the format associated with the specified language.

=item * utc

Forces the date to UTC format.

=back

B<Example:>

    <$mt:PageModifiedDate$>

=for tags pages, date

=cut

sub _hdlr_page_modified_date {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymodifieddate', @_ );
}

###########################################################################

=head2 PageKeywords

The specified keywords of the page in context.

B<Example:>

    <$mt:PageKeywords$>

=cut

sub _hdlr_page_keywords {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrykeywords', @_ );
}

###########################################################################

=head2 PageBasename

By default, the page basename is a constant and unique identifier for
an page which is used as part of the individual pages's archive filename.

The basename is created by dirifiying the page title when the page is
first saved (regardless of the page status). From then on, barring direct
manipulation, the page basename stays constant even when you change the
page's title. In this way, Movable Type ensures that changes you make
to an page after saving it don't change the URL to the page, subsequently
breaking incoming links.

The page basename can be modified by anyone who can edit the page. If it
is modified after it is created, it is up to the user to ensure uniqueness
and no incrementing will occur. This allows you to have complete and
total control over your URLs when you want to as well as effortless
simplicity when you don't care.

B<Attributes:>

=over 4

=item * separator (optional)

Valid values are "_" and "-", dash is the default value. Specifying
an underscore will convert any dashes to underscores. Specifying a dash
will convert any underscores to dashes.

=back

B<Example:>

    <$mt:PageBasename$>

=for tags pages

=cut

sub _hdlr_page_basename {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrybasename', @_ );
}

###########################################################################

=head2 PagePermalink

An absolute URL pointing to the archive page containing this entry. An
anchor (#) is included if the permalink is not pointing to an
Individual Archive page.

B<Example:>

    <$mt:PagePermalink$>

=for tags pages, archives

=cut

sub _hdlr_page_permalink {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrypermalink', @_ );
}

###########################################################################

=head2 PageAuthorDisplayName, PageModifiedAuthorDisplayName

The display name of the (last modified) author of the page in context. If no display name is
specified, returns an empty string, and no name is displayed.

B<Example:>

    <$mt:PageAuthorDisplayName$>

=for tags authors

=cut

sub _hdlr_page_author_display_name {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryauthordisplayname', @_ );
}

sub _hdlr_page_modified_author_display_name {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymodifiedauthordisplayname', @_ );
}

###########################################################################

=head2 PageAuthorEmail, PageModifiedAuthorEmail

The email address of the page's (last modified) author.

B<Note:> It is not recommended to publish email addresses.

B<Example:>

    <$mt:PageAuthorEmail$>

=for tags pages, authors

=cut

sub _hdlr_page_author_email {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryauthoremail', @_ );
}

sub _hdlr_page_modified_author_email {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymodifiedauthoremail', @_ );
}

###########################################################################

=head2 PageAuthorLink, PageModifiedAuthorLink

A linked version of the (last modified) author's user name, using the author URL if provided
in the author's profile. Otherwise, the author name is unlinked. This tag uses
the author URL if available and the author email otherwise. If neither are on
record the author name is unlinked.

B<Attributes:>

=over 4

=item * show_email

Specifies if the author's email can be displayed. The default is false (0).

=item * show_url

Specifies if the author's URL can be displayed. The default is true (1).

=item * new_window

Specifies to open the link in a new window by adding "target=_blank" to the
anchor tag. See example below. The default is false (0).

=back

B<Examples:>

    <$mt:PageAuthorLink$>

    <$mt:PageAuthorLink new_window="1"$>

=for tags pages, authors

=cut

sub _hdlr_page_author_link {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryauthorlink', @_ );
}

sub _hdlr_page_modified_author_link {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymodifiedauthorlink', @_ );
}

###########################################################################

=head2 PageAuthorURL, PageModifiedAuthorURL

The URL of the page's (last modified) author.

B<Example:>

    <$mt:PageAuthorURL$>

=cut

sub _hdlr_page_author_url {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryauthorurl', @_ );
}

sub _hdlr_page_modified_author_url {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entrymodifiedauthorurl', @_ );
}

###########################################################################

=head2 PageExcerpt

This tag outputs the contents of the page Excerpt field if one is specified
or, if not, an auto-generated excerpt from the page Body field followed by an
ellipsis ("...").

The length of the auto-generated output of this tag can be set in the blog's
Entry Settings.

B<Attributes:>

=over 4

=item no_generate (optional; default "0")

When set to 1, the system will not auto-generate an excerpt if the excerpt
field of the page is left blank. Instead it will output nothing.

=item * convert_breaks (optional; default "0")

When set to 1, the page's specified text formatting filter will be applied. By
default, the text formatting is not applied and the excerpt is published
either as input or auto-generated by the system.

=back

B<Example:>

    <$mt:PageExcerpt$>

=cut

sub _hdlr_page_excerpt {
    return undef unless $_[0]->check_page;
    shift->invoke_handler( 'entryexcerpt', @_ );
}

###########################################################################

=head2 WebsitePageCount

The number of published pages in the website. This template tag supports the
multiblog template tags.

B<Example:>

    <$mt:WebsitePageCount$>

=for tags websites, pages, multiblog, count

=cut

###########################################################################

=head2 BlogPageCount

The number of published pages in the blog. This template tag supports the
multiblog template tags.

B<Example:>

    <$mt:BlogPageCount$>

=for tags blogs, pages, multiblog, count

=cut

=head2 SitePageCount

The number of published pages in the site. This template tag supports the
multiblog template tags.

B<Example:>

    <$mt:SitePageCount$>

=for tags sites, pages, multiblog, count

=cut

sub _hdlr_blog_page_count {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    $ctx->invoke_handler( 'blogentrycount', $args, $cond );
}

1;
