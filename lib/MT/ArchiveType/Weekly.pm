# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Weekly;

use strict;
use warnings;
use base qw( MT::ArchiveType::Date );
use MT::Util qw( start_end_week week2ymd );

sub name {
    return 'Weekly';
}

sub archive_label {
    return MT->translate("WEEKLY_ADV");
}

sub order {
    return 40;
}

sub dynamic_template {
    return 'archives/week/<$MTArchiveDate format="%Y%m%d"$>';
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/day-week/index.html'),
            template => '%y/%m/%d-week/%i',
            default  => 1
        },
    ];
}

sub template_params {
    return {
        datebased_only_archive   => 1,
        datebased_weekly_archive => 1,
        archive_template         => 1,
        archive_listing          => 1,
        archive_class            => "datebased-weekly-archive",
        datebased_archive        => 1,
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_week($timestamp);
    }
    else {
        my $start = start_end_week($timestamp);
        my ( $year, $mon, $mday ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%04d/%02d/%02d-week/index", $year, $mon, $mday );
    }
    $file;
}

sub archive_title {
    my $obj = shift;
    my $stamp = ref $_[1] ? $_[1]->authored_on : $_[1];
    my ( $start, $end ) = start_end_week( $stamp, $_[0]->stash('blog') );
    MT::Template::Context::_hdlr_date( $_[0],
        { ts => $start, 'format' => "%x" } )
        . ' - '
        . MT::Template::Context::_hdlr_date( $_[0],
        { ts => $end, 'format' => "%x" } );
}

sub date_range {
    my $obj = shift;
    start_end_week(@_);
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

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
            ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
        },
        {   ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
            group => ["week_number"],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [ { column => "week_number", desc => $order } ],
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

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        week2ymd( $param{year}, $param{week} ) )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_entries( $ctx, 'Weekly', $ts, $limit );
}

1;
