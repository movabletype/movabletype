# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Search::v2;

use strict;
use warnings;

use MT::App::Search;
use MT::DataAPI::Endpoint::Common;

sub search {
    my ( $app, $endpoint ) = @_;

    # Check "search" paramter.
    my $search = $app->param('search');
    if ( !( defined $search && $search ne '' ) ) {
        return $app->error(
            $app->translate('A parameter "search" is required.'), 400 );
    }

    local $app->{mode} = 'default';

    MT::App::Search::init_request($app);
    return $app->error( $app->errstr, 400 ) if $app->errstr;

    my $result = MT::App::Search::process($app)
        or return;

    MT::App::Search::takedown($app);

    # Output JSON data here.
    # This makes post_run_data_api.search have no data.
    $app->send_http_header( $app->current_format->{mime_type} );
    $app->{no_print_body} = 1;
    $app->print_encode($result);

    return;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Search::v2 - Movable Type class for endpoint definitions about the MT::App::Search.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
