# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Endpoint::Publish;

use warnings;
use strict;

use MT::Util qw(epoch2ts ts2iso ts2epoch iso2ts);
use MT::App::CMS;

sub _epoch2iso {
    my ( $blog, $epoch ) = @_;

    if ( $blog && !ref($blog) ) {
        $blog = MT->instance->model('blog')->load($blog);
    }

    ts2iso( $blog, epoch2ts( $blog, $epoch ), 1 );
}

sub _iso2epoch {
    my ( $blog, $iso ) = @_;

    if ( $blog && !ref($blog) ) {
        $blog = MT->instance->model('blog')->load($blog);
    }

    ts2epoch( $blog, iso2ts( $blog, $iso ) );
}

sub entries {
    my ( $app, $endpoint ) = @_;
    my $rebuild_phase_params;

    my $blog_id;
    if ( $blog_id = $app->param('blogId') ) {
        $app->param( 'blog_id', $blog_id );
    }
    if ( my $v = $app->param('startTime') ) {
        $app->param( 'start_time', _iso2epoch( $blog_id, $v ) );
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
        my $blog_id = $rebuild_phase_params->{blog_id};
        my $start_time
            = _epoch2iso( $blog_id, $rebuild_phase_params->{start_time} );

        my $ids = join( ',', @{ $rebuild_phase_params->{id} } );
        $app->set_next_phase_url(
            $app->endpoint_url(
                $endpoint,
                {   startTime => $start_time,
                    ids       => $ids,
                    blogId    => $blog_id,
                    (   $rebuild_phase_params->{blog_ids}
                        ? ( blogIds => join( ',',
                                @{ $rebuild_phase_params->{blog_ids} } )
                            )
                        : ()
                    ),
                }
            )
        );

        +{  status    => 'Rebuilding',
            startTime => $start_time,
            restIds   => $ids,
        };
    }
    else {
        +{  status    => 'Complete',
            startTime => _epoch2iso( $blog_id, $start_time ),
            restIds   => q(),
        };
    }
}

1;
