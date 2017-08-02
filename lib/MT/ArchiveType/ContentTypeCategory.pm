# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategory;

use strict;
use base qw( MT::ArchiveType );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY_ADV");
}

sub default_archive_templates {
    return [
        {   label    => MT->translate('category/sub-category/index.html'),
            template => '%-c/%i',
            default  => 1
        },
        {   label    => MT->translate('category/sub_category/index.html'),
            template => '%c/%i'
        }
    ];
}

sub template_params {
    return { archive_class => "contenttype-category-archive" };
}

sub archive_file {
    my $archiver = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp    = $param{Timestamp};
    my $file_tmpl    = $param{Template};
    my $blog         = $ctx->{__stash}{blog};
    my $cat          = $ctx->{__stash}{category};
    my $content_data = $ctx->{__stash}{content};
    my $file;

    my $this_cat = $archiver->_get_this_cat( $cat, $content_data );

    if ($file_tmpl) {
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
        $file = sprintf( "%s/index", $this_cat->category_path );
    }
    $file;
}

sub archive_title {
}

sub _get_this_cat {
    my $archiver = shift;
    my ( $cat, $content_data ) = @_;
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

    return $this_cat;
}

1;

