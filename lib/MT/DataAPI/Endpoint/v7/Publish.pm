# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v7::Publish;

use warnings;
use strict;

use MT::Util qw(epoch2ts ts2iso);
use MT::App::CMS;
use MT::DataAPI::Endpoint::v1::Publish;

sub all_openapi_spec {
    +{
        tags        => ['Publish'],
        summary     => 'Rebuild the entire site',
        description => <<'DESCRIPTION',
Rebuild specified site.

Authorization is required.
DESCRIPTION
        parameters => [{
                in          => 'query',
                name        => 'siteId',
                schema      => { type => 'integer' },
                description => 'Required. The ID of the site to rebuild.',
            },
            {
                in          => 'query',
                name        => 'archiveTypes',
                schema      => { type => 'string' },
                description => 'Optional. A comma-separated list of archive types to rebuild. If not specified, all archive types will be rebuilt.',
            },
            {
                in          => 'query',
                name        => 'startTime',
                schema      => { type => 'string' },
                description => 'Optional. The string of build start time. You should specifiy this parameter to next call if this endpoint returns ‘Rebuilding’ status and you want to continue to publish.',
            },
            {
                in          => 'query',
                name        => 'offset',
                schema      => { type => 'string' },
                description => 'Optional. The offset number of archives belonging to the archive type to be rebuilt. You should specify this parameter in the next call if this endpoint returns a ‘Rebuilding’ status and you want to continue publishing.'
            },
            {
                in          => 'query',
                name        => 'total',
                schema      => { type => 'string' },
                description => 'Optional. The total number of archives belonging to the archive type to be rebuilt. You should specify this parameter in the next call if this endpoint returns a ‘Rebuilding’ status and you want to continue publishing.'
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type        => 'string',
                                    description => '"The result status of this call. `Rebuilding`: It means that there is still content that needs to be rebuilt. / `Complete`: Publishing process has been finished.',
                                },
                                startTime => {
                                    type        => 'string',
                                    description => "The string of build start time. You should specifiy this parameter to next call if this endpoint returns 'Rebuilding' status and you want to continue to publish.",
                                },
                                restArchiveTypes => {
                                    type        => 'string',
                                    description => 'The comma separated archive types list. You should specify this parameter to next call if this endpoint returns "Rebuilding" status and you want to continue to publish.',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub all {
    my ($app, $endpoint) = @_;

    my $site_id = $app->param('siteId');
    if (!$site_id) {
        return $app->error($app->translate('Site ID is required.'), 400);
    }
    $app->param('site_id', $site_id);

    if (my $v = $app->param('startTime')) {
        $app->param('start_time', MT::DataAPI::Endpoint::v1::Publish::_iso2epoch($site_id, $v));
    }
    my $start_time = $app->param('start_time');

    require MT::CMS::Blog;
    my $site = MT->model('blog')->load($site_id)
        or return $app->error($app->translate('Site not found.'), 404);
    my $build_order = {};
    MT::CMS::Blog::_create_build_order($app, $site, $build_order);
    my %valid_archive_types = map { $_->{archive_type} => 1 } @{ $build_order->{archive_type_loop} };

    my %archive_types =
         !$start_time && !$app->param('archiveTypes')
        ? %valid_archive_types
        : map { $_ => 1 } grep { exists $valid_archive_types{$_} } split ',', ($app->param('archiveTypes') || '');

    my @ordered_archive_types = grep { exists $archive_types{$_} } split ',', $build_order->{build_order};

    my $rebuild_phase_params;

    MT::App::CMS::rebuild_these_site(
        $app,
        \@ordered_archive_types,
        (
            $start_time
            ? ()
            : (how => MT::App::CMS::NEW_PHASE())
        ),
        rebuild_phase_handler => sub {
            my ($app, $params) = @_;
            $rebuild_phase_params = $params;
            1;
        },
        complete_handler => sub {
            my ($app, $params) = @_;
            1;
        }) or return;

    if ($rebuild_phase_params) {
        my $site_id    = $rebuild_phase_params->{site_id};
        my $start_time = MT::DataAPI::Endpoint::v1::Publish::_epoch2iso($site_id, $rebuild_phase_params->{start_time});
        my $types      = join ',', @{ $rebuild_phase_params->{archive_types} || [] };
        my $offset     = $rebuild_phase_params->{offset};
        my $total      = $rebuild_phase_params->{total};

        $app->set_next_phase_url($app->endpoint_url(
            $endpoint,
            {
                siteId       => $site_id,
                startTime    => $start_time,
                archiveTypes => $types,
                offset       => $offset,
                total        => $total,
            }));

        +{
            status           => 'Rebuilding',
            startTime        => $start_time,
            restArchiveTypes => $types,
        };
    } else {
        +{
            status           => 'Complete',
            startTime        => MT::DataAPI::Endpoint::v1::Publish::_epoch2iso($site_id, $start_time),
            restArchiveTypes => q(),
        };
    }
}

1;
