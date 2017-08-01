# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryMonthly;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeMonthly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category-Monthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-MONTHLY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => 'category/sub-category/yyyy/mm/index.html',
            template => '%-c/%y/%m/%i',
            default  => 1
        },
        {   label    => 'category/sub_category/yyyy/mm/index.html',
            template => '%c/%y/%m/%i'
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-monthly-archive" };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp    = $param{Timestamp};
    my $file_tmpl    = $param{Template};
    my $blog         = $ctx->{__stash}{blog};
    my $cat          = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry        = $ctx->{__stash}{entry};
    my $content_data = $ctx->{__stash}{content};
    my $file;

    my $this_cat;
    if ($cat) {
        $this_cat = $cat;
    }
    elsif ($content_data) {
        my @cat_cfs = MT::ContentField->load(
            {   type            => 'categories',
                content_type_id => $content_data->content_type_id,
            }
        );
        foreach my $cat_cf (@cat_cfs) {
            my @obj_cats = MT::ObjectCategory->load(
                {   object_ds => 'content_field',
                    object_id => $cat_cf->id,
                }
            );
            foreach my $obj_cat (@obj_cats) {
                my ($category) = MT::Category->load( $obj_cat->category_id );
                push @$cat, $category;
            }
        }
        $this_cat = $cat;
    }
    else {
        $this_cat = undef;
    }

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

sub archive_title {
}

1;

