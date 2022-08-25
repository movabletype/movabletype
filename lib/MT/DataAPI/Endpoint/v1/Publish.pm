# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::Publish;

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

sub entries_openapi_spec {
    +{
        tags        => ['Entries', 'Publish'],
        summary     => 'Rebuild the static archives in relation to specified entries',
        description => <<'DESCRIPTION',
Rebuild the static archives in relation to specified entries.

Authorization is required.
DESCRIPTION
        parameters => [{
                'in'        => 'query',
                name        => 'ids',
                schema      => { type => 'string' },
                description => 'This is an required parameter. The comma separated ID list of entries to rebuild.',
            },
            {
                'in'        => 'query',
                name        => 'blogId',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter.',
            },
            {
                'in'        => 'query',
                name        => 'startTime',
                schema      => { type => 'string' },
                description => 'This is an optional parameter.',
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                headers     => {
                    'X-MT-Next-Phase-URL' => {
                        schema => { type => 'string' },
                        description => 'If status is "Rebuilding", user should start next phase that implies by this header, manually.(In JavaScript library, a next phase is started automatically.) ',
                    },
                },
                content => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type => 'string',
                                    enum => [
                                        'Rebuilding',
                                        'Complete',
                                    ],
                                    description => <<'DESCRIPTION',
The status text of this rebuild.

#### Rebuilding

Not yet completed.
User should start next phase that implies by X-MT-Next-Phase-URL response header.
(In JavaScript library, a next phase is started automatically.)

#### Complete

All the static archives were rebuilded.
DESCRIPTION
                                },
                                startTime => {
                                    type        => 'string',
                                    format      => 'date-time',
                                    description => 'The time which started rebuilding.',
                                },
                                restIds => {
                                    type        => 'string',
                                    description => 'The comma separated ID list of entries which has not been rebuilt',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub entries {
    my ( $app, $endpoint ) = @_;
    publish_common( $app, $endpoint, \&MT::App::CMS::rebuild_these );
}

sub publish_common {
    my ( $app, $endpoint, $rebuild_these_sub ) = @_;

    my $rebuild_phase_params;

    my $blog_id;
    if ( $blog_id = $app->param('blogId') ) {
        $app->param( 'blog_id', $blog_id );
    }
    if ( my $v = $app->param('startTime') ) {
        $app->param( 'start_time', _iso2epoch( $blog_id, $v ) );
    }
    if ( my $v = $app->param('blogIds') ) {
        $app->multi_param( 'blog_ids', split ',', $v );
    }
    my $start_time = $app->param('start_time');
    my %ids = map { $_ => 1 }
        grep {m/\A\d+\z/o} map { split ',', $_ } $app->multi_param('ids');

    $rebuild_these_sub->(
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

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::Publish - Movable Type class for endpoint definitions about rebuilding static archive.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
