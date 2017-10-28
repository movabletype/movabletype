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

sub order {
    return 270;
}

sub dynamic_template {
    return 'category/<$MTCategoryID$>';
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
    return {
        archive_class               => "contenttype-category-archive",
        category_archive            => 1,
        archive_template            => 1,
        archive_listing             => 1,
        category_based_archive      => 1,
        contenttype_archive_listing => 1,
    };
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
                {   object_ds => 'content_data',
                    object_id => $content_data->id,
                    cf_id     => $cat_cf->id,
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

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;

    my $blog_id = $ctx->stash('blog')->id;
    require MT::Category;
    my $iter = MT::Category->load_iter( { blog_id => $blog_id },
        { 'sort' => 'label', direction => 'ascend' } );

    my $map = $ctx->stash('template_map');
    my $cat_field_id = defined $map && $map ? $map->cat_field_id : '';
    require MT::ContentData;
    require MT::ContentFieldIndex;

    # issue a single count_group_by for all categories
    my $cnt_iter = MT::ContentFieldIndex->count_group_by(
        { content_field_id => $cat_field_id, },
        {   group => ['value_integer'],
            join  => MT::ContentData->join_on(
                undef,
                {   id      => \'= cf_idx_content_data_id',
                    blog_id => $blog_id,
                    status  => MT::Entry::RELEASE(),
                    (   $ctx->stash('content_type')
                        ? ( content_type_id =>
                                $ctx->stash('content_type')->id )
                        : ()
                    ),
                }
            ),
        }
    );
    my %counts;
    while ( my ( $count, $cat_id ) = $cnt_iter->() ) {
        $counts{$cat_id} = $count;
    }

    return sub {
        while ( my $c = $iter->() ) {
            my $count = $counts{ $c->id };
            next unless $count || $args->{show_empty};
            return ( $count, category => $c );
        }
        return ();
    };
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
    my ( $ctx, %param, $content_type_id ) = @_;
    my $limit = $param{limit};
    if ( $limit && ( $limit eq 'auto' ) ) {
        my $blog = $ctx->stash('blog');
        $limit = $blog->entries_on_index if $blog;
    }
    my $c = $ctx->stash('archive_category') || $ctx->stash('category');
    my $map = $ctx->stash('template_map');
    my $cat_field_id = $map ? $map->cat_field_id : '';
    require MT::ContentData;
    my @contents = MT::ContentData->load(
        {   status => MT::Entry::RELEASE(),
            (   $content_type_id
                ? ( content_type_id => $content_type_id )
                : ()
            ),
        },
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

sub target_category_ids {
    my $archiver = shift;
    my ( $content_data, $map ) = @_;

    my $target_category_ids;
    if ( my $cat_field_id = $map->cat_field_id ) {
        my $data = $content_data->data;
        $target_category_ids = $data->{$cat_field_id};
    }

    return $target_category_ids || [];
}

1;

