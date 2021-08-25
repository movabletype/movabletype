# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeWeekly;

use strict;
use warnings;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Weekly );

use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'ContentType-Weekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-WEEKLY_ADV");
}

sub archive_short_label {
    return MT->translate("WEEKLY_ADV");
}

sub order {
    return 190;
}

sub dynamic_template {
    return 'archives/week/<$MTArchiveDate format="%Y%m%d"$>';
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/day-week/index.html'),
            template        => '%y/%m/%d-week/%i',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return {
        archive_class               => "contenttype-weekly-archive",
        datebased_weekly_archive    => 1,
        archive_template            => 1,
        archive_listing             => 1,
        datebased_archive           => 1,
        datebased_only_archive      => 1,
        contenttype_archive_listing => 1,
    };
}

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order
        = ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $content_type_id = $ctx->stash('content_type')->id;
    my $map             = $obj->get_preferred_map(
        {   blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $dt_field_id = $map ? $map->dt_field_id : '';

    require MT::ContentData;
    require MT::ContentFieldIndex;

    my $group_terms
        = $obj->make_archive_group_terms( $blog->id, $dt_field_id, $ts,
        $tsend, '', $content_type_id );
    my $group_args
        = $obj->make_archive_group_args( 'datebased_only', 'weekly', $map,
        $ts, $tsend, $args->{lastn}, $order, '' );

    $iter = MT::ContentData->count_group_by( $group_terms, $group_args )
        or return $ctx->error("Couldn't get weekly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $year = unpack 'A4', $row[1];
            my $date
                = sprintf( "%04d%02d%02d000000", week2ymd( $year, $row[1] ) );
            my ( $start, $end ) = start_end_week($date);
            return (
                $row[0],
                year  => $year,
                week  => $row[1],
                start => $start,
                end   => $end
            );
        }
        undef;
    };
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, $param, $content_type_id ) = @_;
    my $ts
        = $param->{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param->{year}, $param->{week} ) )
        : undef;
    my $limit = $param->{limit};
    $obj->dated_group_contents( $ctx, $obj->name, $ts, $limit,
        $content_type_id );
}

*date_range    = \&MT::ArchiveType::Weekly::date_range;
*archive_file  = \&MT::ArchiveType::Weekly::archive_file;
*archive_title = \&MT::ArchiveType::Weekly::archive_title;

1;

