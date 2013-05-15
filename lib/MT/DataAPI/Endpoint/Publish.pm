# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Endpoint::Publish;

use warnings;
use strict;

use MT::App::CMS;

sub entries {
    my ( $app, $endpoint ) = @_;
    my $rebuild_phase_params;

    my %keys = (
        startTime => 'start_time',
        blogId    => 'blog_id',
    );
    for my $k ( keys %keys ) {
        if ( my $v = $app->param($k) ) {
            $app->param( $keys{$k}, $v );
        }
    }
    if ( my $v = $app->param('blogIds') ) {
        $app->param( 'blog_ids', split ',', $v );
    }
    my $start_time = $app->param('start_time');
    my %ids = map { $_ => 1 }
        grep {m/\A\d+\z/o} map { split ',', $_ } $app->param('ids');
    MT::App::CMS::rebuild_these(
        $app,
        \%ids,
        (   $start_time
            ? ()
            : ( how => MT::App::CMS::NEW_PHASE() )
        ),
        rebuild_phase_handler => sub {
            my ( $app, $params ) = @_;
            $rebuild_phase_params = $params;
            1;
        },
        complete_handler => sub {
            my ( $app, $params ) = @_;
            1;
        },
    ) or return;

    if ($rebuild_phase_params) {
        $start_time = $rebuild_phase_params->{start_time};
        my $ids = join( ',', @{ $rebuild_phase_params->{id} } );
        $app->set_next_phase_url(
            $app->endpoint_url(
                $endpoint,
                {   startTime => $start_time,
                    ids       => $ids,
                    blogId    => $rebuild_phase_params->{blog_id},
                    (   $rebuild_phase_params->{blog_ids}
                        ? ( blogIds => join( ',',
                                @{ $rebuild_phase_params->{blog_ids} } )
                            )
                        : ()
                    ),
                }
            )
        );

        +{  status    => 'rebuilding',
            startTime => $start_time,
            restIds   => $ids,
        };
    }
    else {
        +{  status    => 'complete',
            startTime => $start_time,
        };
    }
}

1;
