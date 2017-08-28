# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeDaily;

use strict;
use base qw( MT::ArchiveType::ContentTypeDate MT::ArchiveType::Daily );

use MT::Util qw( start_end_day );

sub name {
    return 'ContentTypeDaily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-DAILY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => MT->translate('yyyy/mm/dd/index.html'),
            template        => '%y/%m/%d/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
    ];
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
        },
        {   group => [
                "extract(year from cf_idx_value_datetime) AS year",
                "extract(month from cf_idx_value_datetime) AS month",
                "extract(day from cf_idx_value_datetime) AS day"
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [
                {   column => "extract(year from cf_idx_value_datetime)",
                    desc   => $order
                },
                {   column => "extract(month from cf_idx_value_datetime)",
                    desc   => $order
                },
                {   column => "extract(day from cf_idx_value_datetime)",
                    desc   => $order
                },
            ],
            join => MT::ContentFieldIndex->join_on(
                'content_data_id',
                {   content_field_id => $dt_field_id,
                    (   $ts && $tsend
                        ? ( value_datetime => { op => '>=', value => $ts },
                            value_datetime => { op => '<=', value => $tsend }
                            )
                        : ()
                    ),
                },
            ),
        }
    ) or return $ctx->error("Couldn't get daily archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date
                = sprintf( "%04d%02d%02d000000", $row[1], $row[2], $row[3] );
            my ( $start, $end ) = start_end_day($date);
            return (
                $row[0],
                year  => $row[1],
                month => $row[2],
                day   => $row[3],
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
        $param{year}, $param{month}, $param{day} )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_contents( $ctx, 'Daily', $ts, $limit );
}

*date_range    = \&MT::ArchiveType::Daily::date_range;
*archive_file  = \&MT::ArchiveType::Daily::archive_file;
*archive_title = \&MT::ArchiveType::Daily::archive_title;

1;
