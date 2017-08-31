# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeWeekly;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Weekly );

use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'ContentTypeWeekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-WEEKLY_ADV");
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
        archive_class            => "contenttype-datebased-weekly-archive",
        datebased_weekly_archive => 1,
        archive_template         => 1,
        archive_listing          => 1,
        datebased_archive        => 1,
        datebased_only_archive   => 1,
        contenttype_archive_lisrting => 1,
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

    my $map = $ctx->stash('template_map');
    my $dt_field_id = defined $map && $map ? $map->dt_field_id : '';
    require MT::ContentData;
    require MT::ContentFieldIndex;

    $iter = MT::ContentData->count_group_by(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
            (         !$dt_field_id
                    && $ts
                    && $tsend ? ( authored_on => [ $ts, $tsend ] ) : ()
            ),
        },
        {   (         !$dt_field_id
                    && $ts
                    && $tsend ? ( range_incl => { authored_on => 1 } ) : ()
            ),
            group => [
                ( !$dt_field_id ? "week_number" : "cf_idx_value_integer" )
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [
                {   column => (
                        !$dt_field_id
                        ? "week_number"
                        : "cf_idx_value_integer"
                    ),
                    desc => $order
                }
            ],
            (   $dt_field_id
                ? ( join => MT::ContentFieldIndex->join_on(
                        'content_data_id',
                        {   content_field_id => $dt_field_id,
                            (   $ts && $tsend
                                ? ( value_datetime =>
                                        { op => '>=', value => $ts },
                                    value_datetime =>
                                        { op => '<=', value => $tsend }
                                    )
                                : ()
                            ),
                        },
                        { alias => 'dt_cf_idx' }
                    )
                    )
                : ()
            )
        }
    ) or return $ctx->error("Couldn't get weekly archive list");

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
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param{year}, $param{week} ) )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_contents( $ctx, 'Weekly', $ts, $limit );
}

*date_range    = \&MT::ArchiveType::Weekly::date_range;
*archive_file  = \&MT::ArchiveType::Weekly::archive_file;
*archive_title = \&MT::ArchiveType::Weekly::archive_title;

1;

