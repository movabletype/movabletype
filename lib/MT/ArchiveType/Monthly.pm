# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Monthly;

use strict;
use warnings;
use base qw( MT::ArchiveType::Date );
use MT::Util qw( start_end_month );

sub name {
    return 'Monthly';
}

sub archive_label {
    return MT->translate("MONTHLY_ADV");
}

sub order {
    return 50;
}

sub dynamic_template {
    'archives/<$MTArchiveDate format="%Y%m"$>';
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/mm/index.html'),
            template => '%y/%m/%i',
            default  => 1
        },
    ];
}

sub template_params {
    return {
        datebased_only_archive    => 1,
        datebased_monthly_archive => 1,
        archive_template          => 1,
        archive_listing           => 1,
        archive_class             => "datebased-monthly-archive",
        datebased_archive         => 1,
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
            = start_end_month( $timestamp, $blog );
    }
    else {
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $mon ) = unpack 'A4A2', $start;
        $file = sprintf( "%04d/%02d/index", $year, $mon );
    }

    $file;
}

sub archive_title {
    my $obj = shift;
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    Carp::confess("ctx is undef") if !defined($ctx);
    my $start = start_end_month( $stamp, $ctx->stash('blog') );
    MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%B %Y" } );
}

sub date_range {
    my $obj = shift;
    start_end_month(@_);
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
                "extract(month from authored_on) AS month"
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [
                {   column => "extract(year from authored_on)",
                    desc   => $order
                },
                {   column => "extract(month from authored_on)",
                    desc   => $order
                }
            ],
        }
    ) or return $ctx->error("Couldn't get monthly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date = sprintf( "%04d%02d%02d000000", $row[1], $row[2], 1 );
            my ( $start, $end ) = start_end_month($date);
            return (
                $row[0],
                year  => $row[1],
                month => $row[2],
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
        ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_entries( $ctx, 'Monthly', $ts, $limit );
}

1;
