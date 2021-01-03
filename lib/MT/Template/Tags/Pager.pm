# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Pager;

use strict;
use warnings;

use MT;
use MT::Util qw( encode_url );

###########################################################################

=head2 IfMoreResults

A conditional tag used to test whether the requested content has more
to show than currently appearing in the page.

=for tags pagination

=cut

sub _hdlr_if_more_results {
    my ($ctx) = @_;
    my $limit  = $ctx->stash('limit')  || 0;
    my $offset = $ctx->stash('offset') || 0;
    my $count  = $ctx->stash('count')  || 0;
    return $limit + $offset >= $count ? 0 : 1;
}

###########################################################################

=head2 IfPreviousResults

A conditional tag used to test whether the requested content has previous
page.

=for tags pagination

=cut

sub _hdlr_if_previous_results {
    my ($ctx) = @_;
    return $ctx->stash('offset') ? 1 : 0;
}

###########################################################################

=head2 PagerBlock

A block tag iterates from 1 to the number of the last page in the search
result. For example, if the limit was 10 and the number of results is 75,
the tag loops from 1 through 8. 

The page number is set to __value__ standard variable in each iteration. 

The tag also sets __odd__, __even__, __first__, __last__ and __counter__
standard variables. 

B<Example:>

    M
    <MTPagerBlock>
      <MTIfCurrentPage>o<MTElse><a href="<MTPagerLink>">o</a></MTIfCurrentPage>
    </MTPagerBlock>
    vable Type

produces:

    "Mooooooooovable Type" where each "o" is a link to the page.

=for tags pagination

=cut

sub _hdlr_pager_block {
    my ( $ctx, $args, $cond ) = @_;

    my $build  = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    my $limit  = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count  = $ctx->stash('count');

    my $glue = $args->{glue};

    my $output = q();
    require POSIX;
    my $pages = $limit ? POSIX::ceil( $count / $limit ) : 1;
    my $vars = $ctx->{__stash}{vars} ||= {};
    for ( my $i = 1; $i <= $pages; $i++ ) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == $pages;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        local $vars->{__value__}   = $i;
        defined(
            my $out = $build->build(
                $ctx, $tokens,
                {   %$cond,
                    IfCurrentPage => $i
                        == ( $limit ? $offset / $limit + 1 : 1 ),
                }
            )
        ) or return $ctx->error( $build->errstr );
        $output .= $glue
            if defined $glue && $i > 1 && length($output) && length($out);
        $output .= $out;
    }
    $output;
}

###########################################################################

=head2 IfCurrentPage

A conditional tag returns true if the current page in the context of
PagerBlock is the current page that is being rendered. 
The tag must be used in the context of PagerBlock.

=for tags pagination

=cut

###########################################################################

=head2 PagerLink

A function tag returns the URL points to the page in the context of
PagerBlock. The tag can only be used in the context of PagerBlock. 

=for tags pagination

=cut

sub _hdlr_pager_link {
    my ( $ctx, $args ) = @_;

    my $page = $ctx->var('__value__');
    return q() unless $page;

    my $limit  = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    $offset = ( $page - 1 ) * $limit;
    my $template = $ctx->stash('template_id');

    my $link = $ctx->context_script($args);

    if ($link) {
        if ( index( $link, '?' ) > 0 ) {
            $link .= '&';
        }
        else {
            $link .= '?';
        }
    }
    $link .= "limit=" . encode_url($limit);
    $link .= "&page=" . encode_url($page) if $page;
    $link .= "&Template=" . encode_url($template) if $template;

    return $link;
}

###########################################################################

=head2 CurrentPage

A function tag returns a number represents the number of current page.
The number starts from 1.

=for tags pagination

=cut

sub _hdlr_current_page {
    my ($ctx)  = @_;
    my $limit  = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    return $limit ? $offset / $limit + 1 : 1;
}

###########################################################################

=head2 TotalPages

A function tag returns a number represents the total number of pages
in the current search context. The number starts from 1. 

=for tags pagination

=cut

sub _hdlr_total_pages {
    my ($ctx) = @_;
    my $limit = $ctx->stash('limit');
    return 1 unless $limit;
    my $count = $ctx->stash('count');
    require POSIX;
    return POSIX::ceil( $count / $limit );
}

###########################################################################

=head2 PreviousLink

A function tag returns the URL points to the previous page of 
the current page that is being rendered.

=for tags pagination

=cut

sub _hdlr_previous_link {
    my ( $ctx, $args ) = @_;

    my $limit  = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count  = $ctx->stash('count');

    return q() unless $offset;
    my $current_page = $limit ? $offset / $limit + 1 : 1;
    return q() unless $current_page > 1;

    local $ctx->{__stash}{vars}{__value__} = $current_page - 1;
    return _hdlr_pager_link(@_);
}

###########################################################################

=head2 NextLink

A function tag returns the URL points to the next page of the current page
that is being rendered. 

=for tags pagination

=cut

sub _hdlr_next_link {
    my ( $ctx, $args ) = @_;

    my $limit  = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $count  = $ctx->stash('count');

    return q() if ( $limit + $offset ) >= $count;
    my $current_page = $limit ? $offset / $limit + 1 : 1;

    local $ctx->{__stash}{vars}{__value__} = $current_page + 1;
    return _hdlr_pager_link(@_);
}

1;
