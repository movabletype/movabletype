# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::Category;

use strict;
use warnings;
use base qw( MT::ArchiveType );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'Category';
}

sub archive_label {
    return MT->translate("CATEGORY_ADV");
}

sub order {
    return 120;
}

sub dynamic_template {
    return 'category/<$MTCategoryID$>';
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
    return {
        archive_class          => "category-archive",
        category_archive       => 1,
        archive_template       => 1,
        archive_listing        => 1,
        category_based_archive => 1,
    };
}

sub archive_title {
    my $obj   = shift;
    my ($ctx) = @_;
    my $c     = $ctx->stash('category') || $ctx->stash('archive_category');
    encode_html( remove_html( $c ? $c->label : '' ) );
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
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

sub archive_group_iter {
    my $obj = shift;
    my ( $ctx, $args ) = @_;

    my $blog_id = $ctx->stash('blog')->id;
    require MT::Category;
    my $iter = MT::Category->load_iter( { blog_id => $blog_id },
        { 'sort' => 'label', direction => 'ascend' } );
    require MT::Placement;
    require MT::Entry;

    # issue a single count_group_by for all categories
    my $cnt_iter = MT::Placement->count_group_by(
        { blog_id => $blog_id, },
        {   group => ['category_id'],
            join  => MT::Entry->join_on(
                'id', { status => MT::Entry::RELEASE() }
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

sub archive_group_entries {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
    my $limit = $param{limit};
    if ( $limit && ( $limit eq 'auto' ) ) {
        my $blog = $ctx->stash('blog');
        $limit = $blog->entries_on_index if $blog;
    }
    my $c = $ctx->stash('archive_category') || $ctx->stash('category');
    require MT::Entry;
    my @entries = MT::Entry->load(
        { status => MT::Entry::RELEASE() },
        {   join => [
                'MT::Placement', 'entry_id',
                { category_id => $c->id }, { unique => 1 }
            ],
            'sort'      => 'authored_on',
            'direction' => 'descend',
            ( $limit ? ( 'limit' => $limit ) : () ),
        }
    );
    \@entries;
}

sub archive_entries_count {
    my $obj = shift;
    my ( $blog, $at, $entry, $cat ) = @_;
    return $obj->SUPER::archive_entries_count(@_) unless $entry;
    $cat = $entry->category unless $cat;
    return 0 unless $cat;
    return $obj->SUPER::archive_entries_count(
        {   Blog        => $blog,
            ArchiveType => $at,
            Category    => $cat
        }
    );
}

sub does_publish_file {
    my $obj    = shift;
    my %params = %{ shift() };
    if ( !$params{Category} && $params{Entry} ) {
        $params{Category} = $params{Entry}->category;
    }
    return 0 unless $params{Category};

    return 1 if $params{Blog}->publish_empty_archive;

    MT::ArchiveType::archive_entries_count( $obj, \%params );
}

sub display_name {
    my $archiver = shift;
    my $ctx      = shift;
    my $tmpl     = $ctx->stash('template');
    my $cat      = '';
    if (!$tmpl
        || (   ( $tmpl->type || '' ) eq 'index'
            || ( $tmpl->type || '' ) eq 'widget' )
        || !$archiver
        || ( $archiver && !$archiver->category_based )
        || !$ctx->{inside_archive_list}
        )
    {
        $cat = $ctx->stash('archive_category') || $ctx->stash('category');
        $cat = $cat ? $cat->label . ': ' : '';
    }
    return $cat;
}

sub group_based {
    return 1;
}

1;
