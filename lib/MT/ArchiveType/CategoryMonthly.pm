# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::CategoryMonthly;

use strict;
use warnings;
use base qw( MT::ArchiveType::Category MT::ArchiveType::Monthly );
use MT::Util qw( dirify start_end_month );

sub name {
    return 'Category-Monthly';
}

sub archive_label {
    return MT->translate('CATEGORY-MONTHLY_ADV');
}

sub order {
    return 150;
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

sub dynamic_template {
    return 'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m"$>';
}

sub template_params {
    return {
        archive_class            => "category-monthly-archive",
        category_monthly_archive => 1,
        archive_template         => 1,
        archive_listing          => 1,
        datebased_archive        => 1,
        category_based_archive   => 1,
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
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
    my $obj = shift;
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month( $stamp, $ctx->stash('blog') );
    my $date = MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%B %Y" } );
    my $cat = $obj->display_name($ctx);

    sprintf( "%s%s", $cat, $date );
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

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c          = shift;
        my $entry_iter = MT::Entry->count_group_by(
            {   blog_id => $blog->id,
                status  => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {   (   $ts && $tsend
                    ? ( range_incl => { authored_on => 1 } )
                    : ()
                ),
                group => [
                    "extract(year from authored_on) AS year",
                    "extract(month from authored_on) AS month"
                ],
                sort => [
                    {   column => "extract(year from authored_on)",
                        desc   => $order
                    },
                    {   column => "extract(month from authored_on)",
                        desc   => $order
                    },
                ],
                'join' => [
                    'MT::Placement', 'entry_id', { category_id => $c->id }
                ]
            }
        ) or return $ctx->error("Couldn't get yearly archive list");
        while ( my @row = $entry_iter->() ) {
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
        my $iter = MT::Category->load_iter( { blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order } );
        while ( my $category = $iter->() ) {
            $loop_sub->($category);
            last if ( defined($limit) && $count == $limit );
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

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $ts
        = $param{year}
        ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
        : $ctx->{current_timestamp};
    my $cat = $param{category} || $ctx->stash('archive_category');
    my $limit = $param{limit};
    $obj->dated_category_entries( $ctx, 'Category-Monthly', $cat, $ts,
        $limit );
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry, $cat ) = @_;
    $cat = $entry->category unless $cat;
    return 0 unless $cat;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Category    => $cat
        }
    );
}

*date_range             = \&MT::ArchiveType::Monthly::date_range;
*next_archive_entry     = \&MT::ArchiveType::Date::next_archive_entry;
*previous_archive_entry = \&MT::ArchiveType::Date::previous_archive_entry;

1;
