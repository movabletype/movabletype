# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Template::Context::Search;

use strict;
use base qw( MT::Template::Context );

sub load_core_tags {
    require MT::Template::Context;
    return {
        function => {
            SearchString => \&_hdlr_search_string,
            SearchResultCount => \&_hdlr_result_count,
            MaxResults => \&_hdlr_max_results,
            SearchIncludeBlogs => \&_hdlr_include_blogs,
            SearchTemplateID => \&_hdlr_template_id,
            SearchPageLink => \&_hdlr_search_page_link,
        },
        block => {
            SearchResults => \&_hdlr_results,
            'IfTagSearch?' => sub { MT->instance->mode eq 'tag' },
            'IfStraightSearch?' => sub { MT->instance->mode eq 'search' },
            'NoSearchResults?' => sub { $_[0]->stash('count') ? 0 : 1; },
            'NoSearch?' => sub { ( $_[0]->stash('search_string') &&
                                   $_[0]->stash('search_string') =~ /\S/ ) ? 0 : 1 },
            BlogResultHeader => \&MT::Template::Context::_hdlr_pass_tokens,
            BlogResultFooter => \&MT::Template::Context::_hdlr_pass_tokens,
            'IfMaxResultsCutoff?' => \&MT::Template::Context::_hdlr_pass_tokens,
            'SearchIfMoreResults?' => sub {
                my $limit = $_[0]->stash('limit');
                my $offset = $_[0]->stash('offset');
                my $count = $_[0]->stash('count');
                return $limit + $offset >= $count ? 0 : 1;
            },
            'SearchIfPreviousResults?' => sub { $_[0]->stash('offset') ? 1 : 0 },
            SearchPages => \&_hdlr_search_pages,
            'SearchIfCurrentPage?' => \&MT::Template::Context::_hdlr_pass_tokens,
        },
    };
}

sub _hdlr_include_blogs { $_[0]->stash('include_blogs') || '' }
sub _hdlr_search_string { $_[0]->stash('search_string') || '' }
sub _hdlr_template_id { $_[0]->stash('template_id') || '' }
sub _hdlr_max_results { $_[0]->stash('maxresults') || '' }

sub _hdlr_result_count {
    my $results = $_[0]->stash('count');
    $results ? $results : 0;
}

sub _hdlr_results {
    my($ctx, $args, $cond) = @_;

    ## If there are no results, return the empty string, knowing
    ## that the handler for <MTNoSearchResults> will fill in the
    ## no results message.
    my $iter = $ctx->stash('results') or return '';
    my $count = $ctx->stash('count') or return '';
    my $max = $ctx->stash('maxresults');
    my $stash_key = $ctx->stash('stash_key') || 'entry';

    my $output = '';
    my $build = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $blog_header = 1;
    my $blog_footer = 0;
    my $count_per_blog = 0;
    my $max_reached = 0;
    my ( $this_object, $next_object );
    $this_object = $iter->();
    for ( my $i = 0; $i < $count; $i++) {
        $count_per_blog++;
        $ctx->stash($stash_key, $this_object);
        if ( $this_object->can('blog') ) {
            local $ctx->{__stash}{blog} = $this_object->blog;
        }
        if ( $this_object->isa('MT::Entry') ) {
            local $ctx->{current_timestamp} = $this_object->authored_on;
        }
        elsif ( $this_object->properties->{audit} ) {
            local $ctx->{current_timestamp} = $this_object->created_on;
        }

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
            $blog_footer = $next_object->blog_id ne $this_object->blog_id ? 1 : 0;
        }
        else {
            $blog_footer = 1;
        }

        defined(my $out = $build->build($ctx, $tokens,
            { %$cond, 
                BlogResultHeader => $blog_header,
                BlogResultFooter => $blog_footer,
                IfMaxResultsCutoff => $max_reached,
            }
            )) or return $ctx->error( $build->errstr );
        $output .= $out;

        $this_object = $next_object;
        last unless $this_object;
        $blog_header = $blog_footer ? 1 : 0;
    }
    $output;
}

sub _hdlr_search_pages {
    my ($ctx, $args, $cond) = @_;

    my $build = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    my $limit = $_[0]->stash('limit');
    my $offset = $_[0]->stash('offset');
    my $count = $_[0]->stash('count');

    my $glue = $args->{glue};
    $glue = q() unless defined $glue;

    my $output = q();
    my $pages = int( $count / $limit );
    my $vars = $ctx->{__stash}{vars} ||= {};
    for ( my $i = 1; $i <= $pages; $i++ ) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $i == $pages;
        local $vars->{__odd__} = ($i % 2 ) == 1;
        local $vars->{__even__} = ($i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        local $vars->{__value__} = $i;
        defined(my $out = $build->build($ctx, $tokens,
            { %$cond, 
              SearchIfCurrentPage => $i == ( $limit ? $offset / $limit + 1 : 1 ),
            }
            )) or return $ctx->error( $build->errstr );
        $output .= $glue if $i > 1;
        $output .= $out;
    }
    $output;
}

sub _hdlr_search_page_link {
    my ($ctx, $args) = @_;

    my $page = $ctx->var('__value__');
    return q() unless $page;

    my $limit = $ctx->stash('limit');
    my $offset = $ctx->stash('offset');
    my $search_string = MT::Util::encode_url($ctx->stash('search_string'));
    $offset = ( $page - 1 ) * $limit;

    my $cgipath = $ctx->_hdlr_cgi_path($args);
    my $script = $ctx->{config}->SearchScript;
    my $link = $cgipath.$script . '?search=' . $search_string;
    if ( my $mode = $_[0]->stash('mode') ) {
        $mode = MT::Util::encode_url($mode);
        $link .= "&__mode=$mode";
    }
    $link .= "&limit=$limit";
    $link .= "&offset=$offset" if $offset;
    $link;
}

1;
__END__

