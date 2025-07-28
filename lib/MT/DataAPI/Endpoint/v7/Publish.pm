# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v7::Publish;

use warnings;
use strict;

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

    my $site_id = $app->param('siteId')
        or return $app->error($app->translate('Site ID is required.'), 400);
    my $site = MT->model('blog')->load($site_id)
        or return $app->error($app->translate('Site not found.'), 404);
    my $perms = $app->user->permissions($site->id);
    return $app->permission_denied() unless $perms && $perms->can_do('rebuild');

    my $start_time = $app->param('startTime');
    $start_time = MT::DataAPI::Endpoint::v1::Publish::_iso2epoch($site_id, $start_time) if $start_time;
    my $offset = $app->param('offset') || 0;
    my $total  = $app->param('total');

    require MT::CMS::Blog;
    my $build_order = {};
    MT::CMS::Blog::_create_build_order($app, $site, $build_order);
    my %valid_archive_types = map { $_->{archive_type} => 1 } @{ $build_order->{archive_type_loop} };
    my %tmp_archive_types =
         !$start_time && !$app->param('archiveTypes')
        ? %valid_archive_types
        : map { $_ => 1 } grep { exists $valid_archive_types{$_} } split ',', ($app->param('archiveTypes') || '');
    my @archive_types = grep { exists $tmp_archive_types{$_} } split ',', $build_order->{build_order};

    if (!@archive_types) {
        $app->publisher->start_time($start_time) if $start_time;
        $app->run_callbacks('pre_build');
        $app->rebuild_indexes(Blog => $site) or return $app->publish_error();
        $app->run_callbacks('rebuild', $site);
        $app->run_callbacks('post_build');

        return +{
            status           => 'Complete',
            startTime        => MT::DataAPI::Endpoint::v1::Publish::_epoch2iso($site_id, $start_time),
            restArchiveTypes => q(),
        };
    }

    if (!$start_time) {
        $start_time = MT::DataAPI::Endpoint::v1::Publish::_epoch2iso($site_id, time);
        my $archiver   = $app->publisher->archiver($archive_types[0]);
        my $rest_types = join ',', @archive_types;

        $app->run_callbacks('pre_build');

        $app->set_next_phase_url($app->endpoint_url(
            $endpoint,
            {
                siteId       => $site_id,
                startTime    => time,
                archiveTypes => $rest_types,
                offset       => 0,
                total        => MT::CMS::Blog::_determine_total($archiver, $site_id),
            }));

        return +{
            status           => 'Rebuilding',
            startTime        => $start_time,
            restArchiveTypes => $rest_types,
        };
    }

    $app->publisher->start_time($start_time);
    my $type     = shift @archive_types;
    my @rest     = @archive_types;
    my $archiver = $app->publisher->archiver($type);

    if ($archiver && $archiver->category_based) {
        if ($offset < $total) {
            my $start = time;
            my $count = 0;
            my $cb    = sub {
                my $result =
                    time - $start > $app->config->RebuildOffsetSeconds
                    ? 0
                    : 1;
                $count++ if $result;
                return $result;
            };
            $app->rebuild(
                Blog           => $site,
                ArchiveType    => $type,
                NoIndexes      => 1,
                Offset         => $offset,
                Limit          => $app->config->EntriesPerRebuild,
                FilterCallback => $cb,
            ) or return $app->publish_error();
            $offset += $count;
        }

        if ($offset < $total) {
            @rest = ($type, @rest);
        } else {
            $offset = 0;
        }
    } elsif ($type) {
        my $special = 0;
        my @options;
        my $opts = $app->registry("rebuild_options") || {};
        foreach my $opt (keys %$opts) {
            $opts->{$opt}{key} ||= $opt;
            push @options, $opts->{$opt};
        }
        $app->run_callbacks('rebuild_options', $app, \@options);
        for my $opt (@options) {
            if (($opt->{key} || '') eq $type) {
                my $code = $opt->{code};
                unless (ref($code) eq 'CODE') {
                    $code = MT->handler_to_coderef($code);
                    $opt->{code} = $code;
                }
                $opt->{code}->();
                $special = 1;
            }
        }
        if (!$special) {
            if ($offset < $total) {
                my $start = time;
                my $count = 0;
                my $cb    = sub {
                    my $result =
                        time - $start > $app->config->RebuildOffsetSeconds
                        ? 0
                        : 1;
                    $count++ if $result;
                    return $result;
                };
                $app->rebuild(
                    Blog           => $site,
                    ArchiveType    => $type,
                    NoIndexes      => 1,
                    Offset         => $offset,
                    Limit          => $app->config->EntriesPerRebuild,
                    FilterCallback => $cb,
                ) or return $app->publish_error();
                $offset += $count;
            }

            if ($offset < $total) {
                @rest = ($type, @rest);
            } else {
                $offset = 0;
            }
        }
    }

    if ($rest[0] && ($rest[0] ne $type)) {
        my $archiver = $app->publisher->archiver($rest[0]);
        $total = MT::CMS::Blog::_determine_total($archiver, $site_id);
    } elsif (!@rest) {
        $total = 0;
    }

    $start_time = MT::DataAPI::Endpoint::v1::Publish::_epoch2iso($site_id, $start_time);
    my $rest_types = join ',', @rest;

    $app->set_next_phase_url($app->endpoint_url(
        $endpoint,
        {
            siteId       => $site_id,
            startTime    => $start_time,
            archiveTypes => $rest_types,
            offset       => $offset,
            total        => $total,
        }));

    +{
        status           => 'Rebuilding',
        startTime        => $start_time,
        restArchiveTypes => $rest_types,
    };
}

1;
