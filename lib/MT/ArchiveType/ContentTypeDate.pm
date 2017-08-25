# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ArchiveType::ContentTypeDate;

use base qw( MT::ArchiveType::Date );

sub contenttype_group_based {
    return 1;
}

sub dated_group_contents {
    my $obj = shift;
    my ( $ctx, $at, $ts, $limit ) = @_;
    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
        $ctx->{current_timestamp}     = $start;
        $ctx->{current_timestamp_end} = $end;
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map          = $ctx->stash('template_map');
    my $cat_field_id = defined $map && $map ? $map->cat_field_id : '';
    my $dt_field_id  = defined $map && $map ? $map->dt_field_id : '';
    require MT::ContentData;
    my @entries = MT::ContentData->load(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
        },
        {   'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
            'join' => [
                'MT::ContentFieldIndex',
                'content_data_id',
                {   content_field_id => $dt_field_id,
                    value_datetime   => [ $start, $end ]
                },
                { range_incl => { value_datetime => 1 } }
            ],
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub dated_category_contents {
    my $obj = shift;
    my ( $ctx, $at, $cat, $ts ) = @_;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map          = $ctx->stash('template_map');
    my $cat_field_id = defined $map && $map ? $map->cat_field_id : '';
    my $dt_field_id  = defined $map && $map ? $map->dt_field_id : '';
    my @contents     = MT::ContentData->load(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
        },
        {   'sort'      => 'authored_on',
            'direction' => 'descend',
            'joins'     => [
                MT::ContentFieldIndex->join_on(
                    'content_data_id',
                    {   content_field_id => $dt_field_id,
                        value_datetime   => { op => '>=', value => $start },
                        value_datetime   => { op => '<=', value => $end },
                    },
                    { alias => 'dt_cf_idx' }
                ),
                MT::ContentFieldIndex->join_on(
                    'content_data_id',
                    {   content_field_id => $cat_field_id,
                        value_integer    => $cat->id
                    },
                    { alias => 'cat_cf_idx' }
                )
            ],
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@contents;
}

sub dated_author_contents {
    my $obj = shift;
    my ( $ctx, $at, $author, $ts ) = @_;

    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $obj->date_range($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my $map         = $ctx->stash('template_map');
    my $dt_field_id = defined $map && $map ? $map->dt_field_id : '';
    my @contents    = MT::ContentData->load(
        {   blog_id   => $blog->id,
            author_id => $author->id,
            status    => MT::Entry::RELEASE(),
            ( !$dt_field_id ? ( authored_on => [ $start, $end ] ) : () ),
        },
        {   ( !$dt_field_id ? ( range_incl => { authored_on => 1 } ) : () ),
            'sort'      => 'authored_on',
            'direction' => 'descend',
            'join'      => [
                'MT::ContentFieldIndex',
                'content_data_id',
                {   content_field_id => $dt_field_id,
                    value_datetime   => [ $start, $end ]
                },
                { range_incl => { value_datetime => 1 } }
            ]
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@contents;
}

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data, $timestamp, $map ) = @_;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            TemplateMap => $map,
        }
    ) unless $content_data;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $timestamp,
            TemplateMap => $map,
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };

    $obj->archive_contents_count(
        $params{Blog},  $params{ArchiveType}, $params{ContentData},
        $params{Start}, $params{TemplateMap},
    );
}

sub target_dt {
    my $archiver = shift;
    my ( $content_data, $map ) = @_;

    my $target_dt;
    my $dt_field_id = $map->dt_field_id;
    if ($dt_field_id) {
        my $data = $content_data->data;
        $target_dt = $data->{$dt_field_id};
    }
    $target_dt = $content_data->authored_on unless $target_dt;

    return $target_dt;
}

1;
