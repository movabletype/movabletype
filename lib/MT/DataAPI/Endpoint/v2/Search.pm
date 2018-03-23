# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Search;

use strict;
use warnings;

use MT::App::Search;
use MT::DataAPI::Endpoint::Common;

sub search {
    my ( $app, $endpoint ) = @_;

    my $tag_search = $app->param('tagSearch') ? 1 : 0;

    local $app->{mode} = $tag_search ? 'tag' : 'default';

    # Check "search" paramter.
    my $search;
    if ($tag_search) {
        $search = $app->param('tag') || $app->param('search');
    }
    else {
        $search = $app->param('search');
    }
    if ( !( defined $search && $search ne '' ) ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is required.',
                ( $tag_search ? 'tag' : 'search' )
            ),
            400
        );
    }

    my $search_class
        = $app->param('freeText')
        ? 'MT::App::Search::FreeText'
        : 'MT::App::Search';
    local @MT::App::DataAPI::ISA = ($search_class);

    MT::App::Search::init_request($app);
    return $app->error( $app->errstr, 400 ) if $app->errstr;

    $app->param( 'format', 'data_api' );
    local *MT::App::Search::renderdata_api = \&_renderdata_api;

    my $result;
    if ($tag_search) {
        require MT::App::Search::TagSearch;
        $result = MT::App::Search::TagSearch::process($app);
    }
    else {
        $result = MT::App::Search::process($app);
    }

    MT::App::Search::takedown($app);

    return if !$result;

    # Output JSON data here.
    # This makes post_run_data_api.search have no data.
    $app->send_http_header( $app->current_format->{mime_type} );
    $app->{no_print_body} = 1;
    $app->print_encode($result);

    return;
}

sub _renderdata_api {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my @objects;
    if ($iter) {
        while ( my $obj = $iter->() ) {
            push @objects, $obj;
        }
    }

    require MT::DataAPI::Resource;
    my $result = {
        totalResults => ( $count || 0 ),
        items => MT::DataAPI::Resource->from_object( \@objects ),
    };

    my $json = $app->current_format->{serialize}->($result);
    return $json;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Search - Movable Type class for endpoint definitions about the MT::App::Search.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
