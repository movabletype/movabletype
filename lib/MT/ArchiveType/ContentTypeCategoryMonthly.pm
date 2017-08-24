# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryMonthly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeMonthly MT::ArchiveType::CategoryMonthly );

use MT::Util qw( start_end_month );

sub name {
    return 'ContentType-Category-Monthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-MONTHLY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => 'category/sub-category/yyyy/mm/index.html',
            template        => '%-c/%y/%m/%i',
            default         => 1,
            required_fields => { category => 1, date_and_time => 1 }
        },
        {   label           => 'category/sub_category/yyyy/mm/index.html',
            template        => '%c/%y/%m/%i',
            required_fields => { category => 1, date_and_time => 1 }
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-monthly-archive" };
}

sub archive_file {
    my $archiver = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp    = $param{Timestamp};
    my $file_tmpl    = $param{Template};
    my $blog         = $ctx->{__stash}{blog};
    my $cat          = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry        = $ctx->{__stash}{entry};
    my $content_data = $ctx->{__stash}{content};
    my $file;

    my $this_cat = $archiver->_get_this_cat( $cat, $content_data );

    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_month( $timestamp, $blog );
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $month ) = unpack 'A4A2', $start;
        $file = sprintf( "%s/%04d/%02d/index",
            $this_cat->category_path, $year, $month );
    }
    $file;
}

sub archive_group_contents{
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
        : $ctx->stash('current_timestamp');
    my $cat = $param{category} || $ctx->stash('archive_category');
    my $limit = $param{limit};
    $obj->dated_category_contents( $ctx, 'Category-Monthly', $cat, $ts,
        $limit );
}

*date_range    = \&MT::ArchiveType::Monthly::date_range;
*archive_title = \&MT::ArchiveType::CategoryMonthly::archive_title;

1;
