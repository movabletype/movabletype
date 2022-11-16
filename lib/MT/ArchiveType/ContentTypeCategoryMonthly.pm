# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryMonthly;

use strict;
use warnings;
use base
    qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeMonthly MT::ArchiveType::CategoryMonthly );

use MT::Util qw( start_end_month );

sub name {
    return 'ContentType-Category-Monthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-MONTHLY_ADV");
}

sub archive_short_label {
    return MT->translate("CATEGORY-MONTHLY_ADV");
}

sub order {
    return 300;
}

sub dynamic_template {
    return 'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m"$>';
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
    return {
        archive_class               => "contenttype-category-monthly-archive",
        category_monthly_archive    => 1,
        archive_template            => 1,
        archive_listing             => 1,
        datebased_archive           => 1,
        category_based_archive      => 1,
        category_set_based_archive  => 1,
        contenttype_archive_listing => 1,
    };
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

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order
        = ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc'                 : 'desc';
    my $limit = exists $args->{lastn}       ? delete $args->{lastn} : undef;
    my $tmpl  = $ctx->stash('template');
    my $cat   = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data  = ();
    my $count = 0;
    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $content_type_id = $ctx->stash('content_type')->id;
    my $map             = $obj->get_preferred_map(
        {   blog_id         => $blog->id,
            content_type_id => $content_type_id,
            map             => $ctx->stash('template_map'),
        }
    );
    my $cat_field_id = $map ? $map->cat_field_id : '';
    my $dt_field_id  = $map ? $map->dt_field_id  : '';

    require MT::ContentData;
    require MT::ContentFieldIndex;

    my $loop_sub = sub {
        my ( $c, $cat_field_id ) = @_;

        my $group_terms
            = $obj->make_archive_group_terms( $blog->id, $dt_field_id, $ts,
            $tsend, '', $content_type_id );
        my $group_args = $obj->make_archive_group_args(
            'category', 'monthly',      $map,   $ts,
            $tsend,     $args->{lastn}, $order, $c,
            $cat_field_id
        );

        my $cd_iter
            = MT::ContentData->count_group_by( $group_terms, $group_args )
            or return $ctx->error("Couldn't get yearly archive list");
        while ( my @row = $cd_iter->() ) {
            my $hash = {
                year     => $row[1],
                month    => $row[2],
                category => $c,
                count    => $row[0],
            };
            push( @data, $hash );
            return $count + 1
                if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    }
    else {
        require MT::Category;
        my $iter = MT::Category->load_iter(
            {   blog_id => $blog->id,
                (   $args->{category_set_id}
                    ? ( category_set_id => $args->{category_set_id} )
                    : ( category_set_id => { op => '!=', value => 0 } )
                )
            },
            { 'sort' => 'label', direction => $cat_order }
        );
        while ( my $category = $iter->() ) {
            my $last;
            if ( $map && $map->cat_field_id ) {
                $loop_sub->( $category, $map->cat_field_id );
                $last++ if ( defined($limit) && $count == $limit );
            }
            else {
                my $set_id
                    = $args->{category_set_id} || $category->category_set_id;
                my @fields = MT->model('content_field')
                    ->load( { related_cat_set_id => $set_id } );
                foreach my $field (@fields) {
                    $loop_sub->( $category, $field->id );
                    $last++ if ( defined($limit) && $count == $limit );
                }
            }
            last if $last;
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf(
                "%04d%02d%02d000000",
                $data[$curr]->{year},
                $data[$curr]->{month}, 1
            );
            my ( $start, $end ) = start_end_month($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                category => $data[$curr]->{category},
                year     => $data[$curr]->{year},
                month    => $data[$curr]->{month},
                start    => $start,
                end      => $end,
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
        }
}

sub archive_group_contents {
    my $obj = shift;
    my ( $ctx, $param, $content_type_id ) = @_;
    my $ts
        = $param->{year}
        ? sprintf( "%04d%02d%02d000000", $param->{year}, $param->{month}, 1 )
        : $ctx->{current_timestamp};
    my $cat = $param->{category} || $ctx->stash('archive_category');
    my $limit = $param->{limit};
    $obj->dated_category_contents( $ctx, $obj->name, $cat, $ts,
        $limit, $content_type_id );
}

*date_range    = \&MT::ArchiveType::Monthly::date_range;
*archive_title = \&MT::ArchiveType::CategoryMonthly::archive_title;
*next_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::next_archive_content_data;
*previous_archive_content_data
    = \&MT::ArchiveType::ContentTypeDate::previous_archive_content_data;

1;
