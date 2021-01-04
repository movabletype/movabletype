# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Daily;

use strict;
use warnings;
use base qw( MT::ArchiveType::Date );
use MT::Util qw( start_end_day );

sub name {
    return 'Daily';
}

sub archive_label {
    return MT->translate("DAILY_ADV");
}

sub order {
    return 30;
}

sub dynamic_template {
    return 'archives/<$MTArchiveDate format="%Y%m%d"$>';
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/dd/index.html'),
            template => '%y/%m/%d/%f',
            default  => 1
        },
    ];
}

sub template_params {
    return {
        archive_class           => "datebased-daily-archive",
        datebased_only_archive  => 1,
        datebased_daily_archive => 1,
        archive_template        => 1,
        archive_listing         => 1,
        datebased_archive       => 1,
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_day($timestamp);
    }
    else {
        my $start = start_end_day($timestamp);
        my ( $year, $mon, $mday ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%04d/%02d/%02d/index", $year, $mon, $mday );
    }
    $file;
}

sub archive_title {
    my $obj   = shift;
    my $stamp = ref $_[1] ? $_[1]->authored_on : $_[1];
    my $start = start_end_day( $stamp, $_[0]->stash('blog') );
    MT::Template::Context::_hdlr_date( $_[0],
        { ts => $start, 'format' => "%x" } );
}

sub date_range {
    my $obj = shift;
    return start_end_day(@_);
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
            group => [
                "extract(year from authored_on) AS year",
                "extract(month from authored_on) AS month",
                "extract(day from authored_on) AS day"
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [
                {   column => "extract(year from authored_on)",
                    desc   => $order
                },
                {   column => "extract(month from authored_on)",
                    desc   => $order
                },
                { column => "extract(day from authored_on)", desc => $order }
            ],
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

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000",
        $param{year}, $param{month}, $param{day} )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_entries( $ctx, 'Daily', $ts, $limit );
}

1;
