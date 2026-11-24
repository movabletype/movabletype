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

sub _epoch2iso { MT::DataAPI::Endpoint::v1::Publish::_epoch2iso(@_) }

sub _iso2epoch { MT::DataAPI::Endpoint::v1::Publish::_iso2epoch(@_) }

sub all_openapi_spec {
    +{
        tags        => ['Publish'],
        summary     => 'Rebuild the entire site',
        description => <<'DESCRIPTION',
Rebuilds one or more specified sites. Authorization is required.

This operation can be a long-running process. If the process cannot be completed in a single request, it will return a 'Rebuilding' status and an `X-MT-Next-Phase-URL` response header. In this case, the client must make a subsequent request to the URL provided in the header to continue the process. This continues until the process is complete, at which point the status will be 'Complete'.
DESCRIPTION
        parameters => [{
                in          => 'query',
                name        => 'siteIds',
                schema      => { type => 'string' },
                description => 'Required. A comma-separated list of site IDs to rebuild.',
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
                description => 'Internal use for multi-step rebuilding. Specifies the start time of the build process. Clients should use the value from the `X-MT-Next-Phase-URL` for subsequent requests.',
            },
            {
                in          => 'query',
                name        => 'offset',
                schema      => { type => 'string' },
                description => 'Internal use for multi-step rebuilding. Specifies the offset of the items to process. Clients should use the value from the `X-MT-Next-Phase-URL` for subsequent requests.'
            },
            {
                in          => 'query',
                name        => 'total',
                schema      => { type => 'string' },
                description => 'Internal use for multi-step rebuilding. Specifies the total number of items to process. Clients should use the value from the `X-MT-Next-Phase-URL` for subsequent requests.'
            },
            {
                in          => 'query',
                name        => 'nextSiteIndex',
                schema      => { type => 'integer' },
                description => 'Internal use for multi-step rebuilding. Specifies the index of the site to process next. Clients should use the value from the `X-MT-Next-Phase-URL` for subsequent requests.',
            },
            {
                in          => 'query',
                name        => 'nextTypeIndex',
                schema      => { type => 'integer' },
                description => 'Internal use for multi-step rebuilding. Specifies the index of the archive type to process next. Clients should use the value from the `X-MT-Next-Phase-URL` for subsequent requests.',
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
                                    description => 'Comma-separated list of archive types. Indicates the archive types to be rebuilt in the next phase.',
                                },
                                restSiteIds => {
                                    type        => 'string',
                                    description => 'Comma-separated list of site IDs. Indicates the sites to be rebuilt in the next phase.',
                                },
                                siteId => {
                                    type        => 'string',
                                    description => 'The site ID that was rebuilt by the request.',
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

    my @site_ids = split ',', ($app->param('siteIds') || '')
        or return $app->error(
        $app->translate('A parameter "[_1]" is required.', 'siteIds'),
        400
        );
    my $specify_archive_types = $app->param('archiveTypes');
    my $start_time            = $app->param('startTime');
    my $offset                = $app->param('offset') || 0;
    my $total                 = $app->param('total');
    my $next_site_index       = $app->param('nextSiteIndex') || 0;
    my $next_type_index       = $app->param('nextTypeIndex') || 0;

    if (!$site_ids[$next_site_index]) {
        $app->run_callbacks('pre_build');
        for my $site_id (@site_ids) {
            my $site = MT::Blog->load($site_id) or next;
            $app->publisher->start_time(_iso2epoch($site_id, $start_time)) if $start_time;
            $app->rebuild_indexes(Blog => $site) or return $app->publish_error();
            $app->run_callbacks('rebuild', $site);
            $app->run_callbacks('post_build');
        }
        return +{
            status           => 'Complete',
            startTime        => $start_time,
            siteId           => '',
            restSiteIds      => q(),
            restArchiveTypes => q(),
        };
    }

    if (!$start_time) {
        my @sites = MT::Blog->load({ id => \@site_ids });
        if (!@sites) {
            return $app->error(
                $app->translate('A parameter "[_1]" is invalid.', 'siteIds'),
                400
            );
        }
        my $site          = $sites[0];
        my @archive_types = _ordered_archive_types($app, $site, $specify_archive_types);

        my $archiver = $app->publisher->archiver($archive_types[0]);
        $app->run_callbacks('pre_build');
        $start_time = _epoch2iso($site->id, time);
        my $valid_site_ids = join(',', map { $_->id } @sites);

        $app->set_next_phase_url($app->endpoint_url(
            $endpoint,
            {
                siteIds       => $valid_site_ids,
                startTime     => $start_time,
                nextSiteIndex => 0,
                nextTypeIndex => 0,
                offset        => 0,
                total         => MT::CMS::Blog::_determine_total($archiver, $site),
                ($specify_archive_types ? (archiveTypes => (join ',', @archive_types)) : ()),
            }));

        return +{
            status           => 'Rebuilding',
            startTime        => $start_time,
            siteId           => '',
            restSiteIds      => $valid_site_ids,
            restArchiveTypes => join(',', @archive_types),
        };
    }

    my $site_id = $site_ids[$next_site_index];
    my $site    = MT::Blog->load($site_id)
        or return $app->error(
        $app->translate('A parameter "[_1]" is invalid.', 'siteIds'),
        400
        );
    my $perms = $app->user->permissions($site_id);
    return $app->permission_denied()
        unless $perms && $perms->can_do('rebuild');
    $start_time = _iso2epoch($site_id, $start_time);

    my @archive_types = _ordered_archive_types($app, $site, $specify_archive_types);

    if (!$archive_types[$next_type_index]) {
        $next_site_index++;
        my $next_site;
        for my $id (@site_ids[$next_site_index .. $#site_ids]) {
            $next_site = MT::Blog->load($id);
            last if $next_site;
            $next_site_index++;
        }
        if (!$next_site) {
            $start_time = _epoch2iso($site_ids[0], $start_time);
            $app->set_next_phase_url($app->endpoint_url(
                $endpoint,
                {
                    siteIds       => join(',', @site_ids),
                    startTime     => $start_time,
                    nextSiteIndex => $next_site_index,
                    nextTypeIndex => 0,
                    offset        => 0,
                    total         => 0,
                    ($specify_archive_types ? (archiveTypes => (join(',', @archive_types))) : ()),
                }));

            return +{
                status           => 'Rebuilding',
                startTime        => $start_time,
                siteId           => '',
                restSiteIds      => q(),
                restArchiveTypes => q(),
            };
        }

        @archive_types = _ordered_archive_types($app, $next_site, $specify_archive_types);
        my $archiver = $app->publisher->archiver($archive_types[0]);
        $start_time = _epoch2iso($next_site, $start_time);
        $app->set_next_phase_url($app->endpoint_url(
            $endpoint,
            {
                siteIds       => join(',', @site_ids),
                startTime     => $start_time,
                nextSiteIndex => $next_site_index,
                nextTypeIndex => 0,
                offset        => 0,
                total         => MT::CMS::Blog::_determine_total($archiver, $next_site->id),
                ($specify_archive_types ? (archiveTypes => (join(',', @archive_types))) : ()),
            }));

        return +{
            status           => 'Rebuilding',
            startTime        => $start_time,
            siteId           => $next_site->id,
            restSiteIds      => join(',', @site_ids[$next_site_index .. $#site_ids]),
            restArchiveTypes => join(',', @archive_types),
        };
    }

    $app->publisher->start_time($start_time);
    my $type     = $archive_types[$next_type_index];
    my $archiver = $app->publisher->archiver($type);
    $next_type_index++;

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
            $next_type_index--;
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
                $next_type_index--;
            } else {
                $offset = 0;
            }
        }
    }

    if (!@archive_types[$next_type_index .. $#archive_types]) {
        $next_site_index++;
        my $next_site;
        for my $id (@site_ids[$next_site_index .. $#site_ids]) {
            $next_site = MT::Blog->load($id);
            last if $next_site;
            $next_site_index++;
        }
        if (!$next_site) {
            $start_time = _epoch2iso($site, $start_time);
            $app->set_next_phase_url($app->endpoint_url(
                $endpoint,
                {
                    siteIds       => join(',', @site_ids),
                    startTime     => $start_time,
                    nextSiteIndex => $next_site_index,
                    nextTypeIndex => 0,
                    offset        => 0,
                    total         => 0,
                    ($specify_archive_types ? (archiveTypes => (join(',', @archive_types))) : ()),
                }));

            return +{
                status           => 'Rebuilding',
                startTime        => $start_time,
                siteId           => $site_id,
                restSiteIds      => q(),
                restArchiveTypes => q(),
            };
        }

        @archive_types = _ordered_archive_types($app, $next_site, $specify_archive_types);
        my $archiver = $app->publisher->archiver($archive_types[0]);
        $start_time = _epoch2iso($next_site, $start_time);
        $app->set_next_phase_url($app->endpoint_url(
            $endpoint,
            {
                siteIds       => join(',', @site_ids),
                startTime     => $start_time,
                nextSiteIndex => $next_site_index,
                nextTypeIndex => 0,
                offset        => 0,
                total         => MT::CMS::Blog::_determine_total($archiver, $next_site->id),
                ($specify_archive_types ? (archiveTypes => (join(',', @archive_types))) : ()),
            }));

        return +{
            status           => 'Rebuilding',
            startTime        => $start_time,
            siteId           => $site_id,
            restSiteIds      => join(',', @site_ids[$next_site_index .. $#site_ids]),
            restArchiveTypes => join(',', @archive_types),
        };
    }

    if ($archive_types[$next_type_index] && ($archive_types[$next_type_index] ne $type)) {
        my $archiver = $app->publisher->archiver($archive_types[$next_type_index]);
        $total = MT::CMS::Blog::_determine_total($archiver, $site_id);
    }

    $start_time = _epoch2iso($site_id, $start_time);
    $app->set_next_phase_url($app->endpoint_url(
        $endpoint,
        {
            siteIds       => join(',', @site_ids),
            startTime     => $start_time,
            nextSiteIndex => $next_site_index,
            nextTypeIndex => $next_type_index,
            offset        => $offset,
            total         => $total,
            ($specify_archive_types ? (archiveTypes => (join(',', @archive_types))) : ()),
        }));

    +{
        status           => 'Rebuilding',
        startTime        => $start_time,
        siteId           => $site_id,
        restSiteIds      => join(',', @site_ids[$next_site_index .. $#site_ids]),
        restArchiveTypes => join(',', @archive_types[$next_type_index .. $#archive_types]),
    };
}

sub _ordered_archive_types {
    my ($app, $site, $specify_archive_types) = @_;
    my $build_order = {};
    require MT::CMS::Blog;
    MT::CMS::Blog::_create_build_order($app, $site, $build_order);
    my %valid_archive_types = map { $_->{archive_type} => 1 } @{ $build_order->{archive_type_loop} };
    my %archive_types =
        $specify_archive_types
        ? map { $_ => 1 } grep { exists $valid_archive_types{$_} } split ',', ($specify_archive_types || '')
        : %valid_archive_types;
    return grep { exists $archive_types{$_} } split ',', $build_order->{build_order};
}

1;
