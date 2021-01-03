# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Context::Search;

use strict;
use warnings;
use base qw( MT::Template::Context );
use MT::Util qw( encode_url decode_html );

sub load_core_tags {
    require MT::Template::Context;
    return {
        function => {
            SearchString         => \&_hdlr_search_string,
            SearchResultCount    => \&_hdlr_result_count,
            MaxResults           => \&_hdlr_max_results,
            SearchContentTypes   => \&_hdlr_search_content_types,
            SearchIncludeBlogs   => \&_hdlr_include_blogs,
            SearchTemplateID     => \&_hdlr_template_id,
            SearchTemplateBlogID => \&_hdlr_template_blog_id,
        },
        block => {
            SearchResults       => \&_hdlr_results,
            'IfTagSearch?'      => sub { MT->instance->mode eq 'tag' },
            'IfStraightSearch?' => sub { MT->instance->mode eq 'default' },
            'NoSearchResults?'  => sub {
                (          $_[0]->stash('search_string')
                        && $_[0]->stash('search_string') =~ /\S/
                        && !$_[0]->stash('count') ) ? 1 : 0;
            },
            'NoSearch?' => sub {
                (          $_[0]->stash('search_string')
                        && $_[0]->stash('search_string') =~ /\S/ ) ? 0 : 1;
            },
            SearchResultsHeader => \&MT::Template::Context::_hdlr_pass_tokens,
            SearchResultsFooter => \&MT::Template::Context::_hdlr_pass_tokens,
            BlogResultHeader    => \&MT::Template::Context::_hdlr_pass_tokens,
            BlogResultFooter    => \&MT::Template::Context::_hdlr_pass_tokens,
            'IfMaxResultsCutoff?' =>
                \&MT::Template::Context::_hdlr_pass_tokens,
        },
    };
}

###########################################################################

=head2 IfStraightSearch

A conditional block which outputs its contents if the search in progress
is a regular (or "straight") search.

=for tags search

=cut

###########################################################################

=head2 IfTagSearch

A conditional block which outputs its contents if the search in progress
is a search of entries by tag.

=for tags search

=cut

###########################################################################

=head2 NoSearch

A container tag whose contents are displayed only if there is no search
performed.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 NoSearchResults

A container tag whose contents are displayed if a search is performed
but no results are found.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 SearchResultsHeader

The content of this block tag is rendered when the item in context
from search results are the first item of the result set.  You can
use the block to render headings and titles of the result table,
for example.

This tag is only recognized in SearchResults block.

B<Example:>

    <mt:SearchResultsHeader>
    <h3>Look what we found!</h3>
    </mt:SearchResultsHeader>

=for tags search

=cut

###########################################################################

=head2 SearchResultsFooter

The content of this block tag is rendered when the item in context
from search results are the last item of the result set.  You can
use the block to render closeing tags of a HTML element, for example.

This tag is only recognized in SearchResults block.

B<Example:>

    <mt:SearchResultsFooter>
    <p>If you didn't find what you were looking for, you can also peruse
    the <a href="<mt:Link identifier="archive_index">">site archives</a>.</p>
    </mt:SearchResultsFooter>

=for tags search

=cut

###########################################################################

=head2 BlogResultHeader

The contents of this container tag will be displayed when the blog id of
the entry in context from search results differs from the previous entry's
blog id.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 BlogResultFooter

The contents of this container tag will be displayed when the blog id of
the entry in context from search results differs from the next entry's
blog id.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 IfMaxResultsCutoff

NOTE: this tag only applies if you are using older Movable Type than
version 4.15, or you set up your search script so it instantiates
MT::App::Search::Legacy, the older search script.  Under the default
search script in Movable Type, this tag will never be evaluated as true and
therefore the contents will never be rendered.

A conditional tag that returns true when the number of search results
per blog exceeds the maximium limit specified in MaxResults configuration
directive.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 MaxResults

Returns the value of SearchMaxResults, specified either in configuration
(via C<SearchMaxResults> configuration directive) or in the search query
parameter in the URL.

This tag is only recognized in search templates.

=for tags search

=cut

###########################################################################

=head2 SearchIncludeBlogs

Used in the search result template to pass the IncludeBlogs parameters
through from the search form keeping the context of any followup search
the same as the initial search.

B<Example:>

    <input type="hidden" name="IncludeBlogs" value="<$mt:SearchIncludeBlogs$>" />

=for tags search

=cut

sub _hdlr_include_blogs { $_[0]->stash('include_blogs') || '' }

###########################################################################

=head2 SearchString

An HTML-encoded search query. This tag is only recognized in search templates.

B<Example:>

    <$mt:SearchString$>

=for tags search

=cut

sub _hdlr_search_string { $_[0]->stash('search_string') || '' }

###########################################################################

=head2 SearchTemplateID

Returns the identifier of the search template (ie, "feed" or
"nomorepizzaplease").

B<Example:>

    <$mt:SearchTemplateID$>

=for tags search

=cut

sub _hdlr_template_id { $_[0]->stash('template_id') || '' }

###########################################################################

=head2 SearchTemplateBlogID

Returns the ID of the blog that loaded the template.

B<Example:>

    <$mt:SearchTemplateBlogID$>

=for tags search

=cut

sub _hdlr_template_blog_id {
    $_[0]->stash('search_blog_id') || $_[0]->stash('blog_id') || '';
}

sub _hdlr_max_results { $_[0]->stash('maxresults') || '' }

###########################################################################

=head2 SearchResultCount

The number of results found across all of the blogs searched. This tag
is only recognized in search templates.

B<Example:>

    <$mt:SearchResultCount$>

=for tags search, count

=cut

sub _hdlr_result_count {
    my ( $ctx, $args, $cond ) = @_;
    my $results = $ctx->stash('count') || 0;
    return $ctx->count_format( $results, $args );
}

###########################################################################

=head2 SearchResults

A container tag that creates a list of search results. This tag
creates an entry and blog context that all Entry* and Blog* tags
can be used.

This tag is only recognized in search templates.

=for tags search

=cut

sub _hdlr_results {
    my ( $ctx, $args, $cond ) = @_;

    my $orig_blog    = $ctx->stash('blog');
    my $orig_blog_id = $ctx->stash('blog_id');

    ## If there are no results, return the empty string, knowing
    ## that the handler for <MTNoSearchResults> will fill in the
    ## no results message.
    my $iter  = $ctx->stash('results') or return '';
    my $count = $ctx->stash('count')   or return '';
    my $max   = $ctx->stash('maxresults');
    my $stash_key = $ctx->stash('stash_key') || 'entry';

    my $output         = '';
    my $build          = $ctx->stash('builder');
    my $tokens         = $ctx->stash('tokens');
    my $blog_header    = 1;
    my $blog_footer    = 0;
    my $footer         = 0;
    my $count_per_blog = 0;
    my $max_reached    = 0;
    my ( $this_object, $next_object );
    $this_object = $iter->();
    return '' unless $this_object;

    for ( my $i = 0; $i < $count; $i++ ) {
        $count_per_blog++;
        local $ctx->{__stash}{$stash_key} = $this_object;
        local $ctx->{__stash}{blog} = $this_object->blog
            if $this_object->can('blog');
        local $ctx->{__stash}{blog_id} = $this_object->blog->id
            if $this_object->can('blog') && $this_object->blog;
        local $ctx->{__stash}{content_type} = $this_object->content_type
            if $this_object->isa('MT::ContentData');
        my $ts;
        if ( $this_object->isa('MT::Entry') ) {
            $ts = $this_object->authored_on;
        }
        elsif ( $this_object->properties->{audit} ) {
            $ts = $this_object->created_on;
        }
        local $ctx->{current_timestamp} = $ts;

   # TODO: per blog max objects?
   #if ( $count_per_blog >= $max ) {
   #    while (1) {
   #        if ( $count > $i + 1 ) {
   #            $next_object = $results->[$i + 1];
   #            if ( $next_object->blog_id ne $this_object->blog_id ) {
   #                $blog_footer = 1;
   #                last;
   #            }
   #            else {
   #                $max_reached = 1;
   #            }
   #        }
   #        else {
   #            $next_object = undef;
   #            $blog_footer = 1;
   #            last;
   #        }
   #        $i++;
   #    }
   #}
   #elsif ( $count > $i + 1 ) {
   #    $next_object = $results->[$i + 1];
   #    $blog_footer = $next_object->blog_id ne $this_object->blog_id ? 1 : 0;
   #}
   #else {
   #    $blog_footer = 1;
   #}
        if ( $next_object = $iter->() ) {
            if ( $next_object->can('blog') ) {
                $blog_footer
                    = $next_object->blog_id ne $this_object->blog_id ? 1 : 0;
            }
        }
        else {
            $blog_footer = 1;
            $footer      = 1;
        }

        my $vars = $ctx->{__stash}{vars} ||= {};
        local $vars->{__first__}   = $i == 0;
        local $vars->{__last__}    = ( $footer ? 1 : '' );
        local $vars->{__odd__}     = ( $i % 2 ) == 0;
        local $vars->{__even__}    = ( $i % 2 ) == 1;
        local $vars->{__counter__} = $i + 1;

        defined(
            my $out = $build->build(
                $ctx, $tokens,
                {   %$cond,
                    SearchResultsHeader => $i == 0,
                    SearchResultsFooter => $footer,
                    BlogResultHeader    => $blog_header,
                    BlogResultFooter    => $blog_footer,
                    IfMaxResultsCutoff  => $max_reached,
                }
            )
        ) or return $ctx->error( $build->errstr );
        $output .= $out;

        $this_object = $next_object;
        last unless $this_object;
        $blog_header = $blog_footer ? 1 : 0;
    }

    $ctx->stash( 'blog',    $orig_blog );
    $ctx->stash( 'blog_id', $orig_blog_id );
    $output;
}

###########################################################################

=head2 SearchContentTypes

Used in the search result template to pass the SearchContentTypes parameters
through from the search form keeping the context of any followup search
the same as the initial search.

B<Example:>

    <input type="hidden" name="SearchContentTypes" value="<$mt:SearchContenTypes$>" />

=for tags search

=cut

sub _hdlr_search_content_types {
    my $ret = $_[0]->stash('search_content_types');
    defined $ret ? $ret : '';
}

sub context_script {
    my ( $ctx, $args, $cond ) = @_;

    my $search_string = decode_html( $ctx->stash('search_string') );
    my $cgipath       = $ctx->invoke_handler( 'cgipath', $args );
    my $script        = $ctx->invoke_handler( 'searchscript', $args );
    my $link = $cgipath . $script . '?search=' . encode_url($search_string);
    if ( my $mode = $ctx->stash('mode') ) {
        $mode = encode_url($mode);
        $link .= "&__mode=$mode";
    }
    if ( my $type = $ctx->stash('type') ) {
        $link .= "&type=" . encode_url($type);
    }
    if ( my $include_blogs = $ctx->stash('include_blogs') ) {
        $link .= "&IncludeBlogs=" . encode_url($include_blogs);
    }
    if ( my $blog_id
        = $ctx->stash('search_blog_id') || $ctx->stash('blog_id') )
    {
        $link .= "&blog_id=" . encode_url($blog_id);
    }

    my $category = $ctx->stash('search_category');
    $link .= "&category=" . encode_url($category) if $category;

    my $author = $ctx->stash('search_author');
    $link .= "&author=" . encode_url($author) if $author;

    my $year = $ctx->stash('search_year');
    $link .= "&year=" . encode_url($year) if $year;

    my $month = $ctx->stash('search_month');
    $link .= "&month=" . encode_url($month) if $month;

    my $day = $ctx->stash('search_day');
    $link .= "&day=" . encode_url($day) if $day;

    my $archive_type = $ctx->stash('search_archive_type');
    $link .= "&archive_type=" . encode_url($archive_type) if $archive_type;

    my $template_id = $ctx->stash('search_template_id');
    $link .= "&template_id=" . encode_url($template_id) if $template_id;

    if ( my $format = $ctx->stash('format') ) {
        $link .= '&format=' . encode_url($format);
    }

    my $content_field = $ctx->stash('search_content_field');
    $link
        .= '&content_field='
        . encode_url( _decode_utf8_if_needed($content_field) )
        if $content_field;

    my $content_types = $ctx->stash('search_content_types');
    $link
        .= '&SearchContentTypes='
        . encode_url( _decode_utf8_if_needed($content_types) )
        if $content_types;

    $link;
}

sub _decode_utf8_if_needed {
    my $str = shift;
    my $enc = MT->config->PublishCharset;
    return $str unless lc($enc) =~ /^utf-?8$/ && !Encode::is_utf8($str);
    Encode::decode_utf8($str);
}

1;
__END__
