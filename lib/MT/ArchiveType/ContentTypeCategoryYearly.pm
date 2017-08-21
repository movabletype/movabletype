# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryYearly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeYearly MT::ArchiveType::CategoryYearly );

use MT::Util qw( start_end_year );

sub name {
    return 'ContentType-Catogery-Yearly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-YEARLY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => 'category/sub-category/yyyy/index.html',
            template        => '%-c/%y/%i',
            default         => 1,
            required_fields => { category => 1, date_and_time => 1 }
        },
        {   label           => 'category/sub_category/yyyy/index.html',
            template        => '%c/%y/%i',
            required_fields => { category => 1, date_and_time => 1 }
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-yearlyarchive" };
}

sub archive_file {
    my $archiver = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp    = $param{Timestamp};
    my $file_tmpl    = $param{Template};
    my $blog         = $ctx->{__stash}{blog};
    my $cat          = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $content_data = $ctx->{__stash}{content};
    my $file;

    my $this_cat = $archiver->_get_this_cat( $cat, $content_data );

    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} )
            = start_end_year( $timestamp, $blog );
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
        my $start = start_end_year( $timestamp, $blog );
        my ($year) = unpack 'A4', $start;
        $file = sprintf( "%s/%04d/index", $this_cat->category_path, $year );
    }
    $file;
}

*date_range = \&MT::ArchiveType::Yearly::date_range;

1;
