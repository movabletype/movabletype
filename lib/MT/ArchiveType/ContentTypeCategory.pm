# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategory;

use strict;
use base qw( MT::ArchiveType::Category );

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
            default  => 1,
            required_fields => { category => 1 }
        },
        {   label    => MT->translate('category/sub_category/index.html'),
            template => '%c/%i',
            required_fields => { category => 1 }
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

sub archive_contents_count {
    my $obj = shift;
    my ( $blog, $at, $content_data, $cat ) = @_;
    return $obj->SUPER::archive_contents_count(@_) unless $content_data;
    $cat = _get_this_cat( $cat, $content_data ) unless $cat;
    return 0 unless $cat;
    return $obj->SUPER::archive_contents_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Category    => $cat
        }
    );
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $limit = $param{limit};
    if ( $limit && ( $limit eq 'auto' ) ) {
        my $blog = $ctx->stash('blog');
        $limit = $blog->entries_on_index if $blog;
    }
    my $c = $ctx->stash('archive_category') || $ctx->stash('category');
    my $map          = $ctx->stash('template_map');
    my $cat_field_id = $map ? $map->cat_field_id : '';
    require MT::ContentData;
    my @contents = MT::ContentData->load(
        { status => MT::Entry::RELEASE() },
        {   'join' => [
                'MT::ContentFieldIndex',
                'content_data_id',
                {   content_field_id => $cat_field_id,
                    value_integer    => $c->id
                }
            ],
            'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    );
    \@contents;
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };
    if ( !$params{Category} && $params{ContentData} ) {
        $params{Category}
            = _get_this_cat( $params{Category}, $params{ContentData} );
    }
    return 0 unless $params{Category};

    return 1 if $params{Blog}->publish_empty_archive;

    MT::ArchiveType::archive_contents_count( $obj, \%params );
}

sub contenttype_group_based {
    return 1;
}

1;

