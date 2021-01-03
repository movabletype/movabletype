# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Yearly;

use strict;
use warnings;
use base qw( MT::ArchiveType::Date );
use MT::Util qw( start_end_year );

sub name {
    return 'Yearly';
}

sub archive_label {
    return MT->translate("YEARLY_ADV");
}

sub order {
    return 60;
}

sub dynamic_template {
    return 'archives/<$MTArchiveDate format="%Y"$>';
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('yyyy/index.html'),
            template => '%y/%i',
            default  => 1
        }
    ];
}

sub template_params {
    return {
        datebased_only_archive   => 1,
        datebased_yearly_archive => 1,
        module_yearly_archives   => 1,
        archive_template         => 1,
        archive_listing          => 1,
        archive_class            => "datebased-yearly-archive",
        datebased_archive        => 1,
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
            = start_end_year( $timestamp, $blog );
    }
    else {
        my $start = start_end_year( $timestamp, $blog );
        my ($year) = unpack 'A4', $start;
        $file = sprintf( "%04d/index", $year );
    }

    $file;
}

sub archive_title {
    my $obj = shift;
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year( $stamp, $ctx->stash('blog') );
    require MT::Template::Context;
    my $year = MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%Y" } );
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';

    sprintf( "%s%s", $year, ( $lang eq 'ja' ? '&#24180;' : '' ) );
}

sub date_range {
    my $obj = shift;
    start_end_year(@_);
}

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order
        = ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {   blog_id => $blog->id,
            status  => MT::Entry::RELEASE()
        },
        {   group => ["extract(year from authored_on) AS year"],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => [
                {   column => "extract(year from authored_on)",
                    desc   => $order
                }
            ],
        }
    ) or return $ctx->error("Couldn't get yearly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date = sprintf( "%04d%02d%02d000000", $row[1], 1, 1 );
            my ( $start, $end ) = start_end_year($date);
            return ( $row[0], year => $row[1], start => $start, end => $end );
        }
        undef;
    };
}

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 )
        : undef;
    my $limit = $param{limit};
    $obj->dated_group_entries( $ctx, 'Yearly', $ts, $limit );
}

1;
