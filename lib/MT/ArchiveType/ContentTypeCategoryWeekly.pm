# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryWeekly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeWeekly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category-Weekly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-WEEKLY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => 'category/sub-category/yyyy/mm/day-week/index.html',
            template => '%-c/%y/%m/%d-week/%i',
            default  => 1,
        },
        {   label    => 'category/sub_category/yyyy/mm/day-week/index.html',
            template => '%c/%y/%m/%d-week/%i'
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-weekly-archive" };
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
            = start_end_week( $timestamp, $blog );
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
        my $start = start_end_week( $timestamp, $blog );
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%s/%04d/%02d/%02d-week/index",
            $this_cat->category_path, $year, $month, $day );
    }
    $file;
}

sub archive_title {
}

1;

