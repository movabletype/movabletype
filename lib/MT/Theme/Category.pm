# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::Category;
use strict;
use warnings;
use MT;
use MT::Theme::Common
    qw( add_categories build_category_tree generate_order get_ordered_basenames );

sub import_categories {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    add_categories( $theme, $obj_to_apply, $cats, 'category' )
        or die "Failed to create theme default categories";

    my $order = generate_order(
        {   basenames => $element->{data}{':order'},
            terms     => {
                blog_id         => $obj_to_apply->id,
                class           => 'category',
                category_set_id => 0,
            },
        }
    );
    if ($order) {
        $obj_to_apply->category_order($order);
        $obj_to_apply->save
            or die MT->translate( 'Failed to save category_order: [_1]',
            $obj_to_apply->errstr );
    }

    return 1;
}

sub import_folders {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    add_categories( $theme, $obj_to_apply, $cats, 'folder' )
        or die "Failed to create theme default folders";

    my $order = generate_order(
        {   basenames => $element->{data}{':order'},
            terms     => {
                blog_id         => $obj_to_apply->id,
                class           => 'folder',
                category_set_id => 0,
            },
        }
    );
    if ($order) {
        $obj_to_apply->folder_order($order);
        $obj_to_apply->save
            or die MT->translate( 'Failed to save folder_order: [_1]',
            $obj_to_apply->errstr );
    }

    return 1;
}

sub info_categories {
    my ( $element, $theme, $blog ) = @_;
    my $data = $element->{data};
    my ( $parents, $children ) = ( 0, 0 );
    for my $parent ( values %$data ) {
        next unless ref $parent eq 'HASH';
        $parents++;
        $children += _count_descendant_categories( $parent, 0 );
    }
    return sub {
        MT->translate( '[_1] top level and [_2] sub categories.',
            $parents, $children );
    };
}

sub info_folders {
    my ( $element, $theme, $blog ) = @_;
    my $data = $element->{data};
    my ( $parents, $children ) = ( 0, 0 );
    for my $parent ( values %$data ) {
        next unless ref $parent eq 'HASH';
        $parents++;
        $children += _count_descendant_categories( $parent, 0 );
    }
    return sub {
        MT->translate( '[_1] top level and [_2] sub folders.',
            $parents, $children );
    };
}

sub _count_descendant_categories {
    my ( $data, $count ) = @_;
    my $children = $data->{children};
    for my $child ( values %$children ) {
        $count++;
        $count += _count_descendant_categories( $child, 0 );
    }
    $count;
}

sub category_condition {
    my ($blog) = @_;
    my $cat
        = MT->model('category')
        ->load( { blog_id => $blog->id, category_set_id => 0 },
        { limit => 1 } );
    return defined $cat ? 1 : 0;
}

sub folder_condition {
    my ($blog) = @_;
    my $cat
        = MT->model('folder')
        ->load( { blog_id => $blog->id, category_set_id => 0 },
        { limit => 1 } );
    return defined $cat ? 1 : 0;
}

sub category_export_template {
    my $app = shift;
    my ( $blog, $saved ) = @_;
    my $list = $app->_build_category_list(
        blog_id => $blog->id,
        type    => 'category',
    );
    return if !defined $list || !scalar @$list;
    my %checked_ids;
    if ($saved) {
        %checked_ids
            = map { $_ => 1 } @{ $saved->{default_category_export_ids} };
    }
    for my $cat (@$list) {
        $cat->{checked} = $saved ? $checked_ids{ $cat->{category_id} } : 1;
    }
    my %param = ( categories => $list );
    return $app->load_tmpl( 'include/theme_exporters/category.tmpl',
        \%param );
}

sub folder_export_template {
    my $app = shift;
    my ( $blog, $saved ) = @_;
    my $list = $app->_build_category_list(
        blog_id => $blog->id,
        type    => 'folder',
    );
    return if !defined $list || !scalar @$list;
    my %checked_ids;
    if ($saved) {
        %checked_ids
            = map { $_ => 1 } @{ $saved->{default_folder_export_ids} };
    }
    for my $cat (@$list) {
        $cat->{checked} = $saved ? $checked_ids{ $cat->{category_id} } : 1;
    }
    my %param = ( folders => $list );
    return $app->load_tmpl( 'include/theme_exporters/folder.tmpl', \%param );
}

sub export_category {
    my ( $app, $blog, $settings ) = @_;
    my @cats;
    if ( defined $settings ) {
        my @ids = $settings->{default_category_export_ids};
        @cats = MT->model('category')
            ->load( { id => \@ids, category_set_id => 0 } );
    }
    else {
        @cats = MT->model('category')
            ->load( { blog_id => $blog->id, category_set_id => 0 } );
    }

    my $data = {};

    if (@cats) {
        $data->{':order'}
            = get_ordered_basenames( \@cats, $blog->category_order );
    }

    my @tops = grep { !$_->parent } @cats;
    for my $top (@tops) {
        $data->{ $top->basename } = build_category_tree( \@cats, $top );
    }

    return %$data ? $data : undef;
}

sub export_folder {
    my ( $app, $blog, $settings ) = @_;
    my @folders;
    if ( defined $settings ) {
        my @ids = $settings->{default_folder_export_ids};
        @folders = MT->model('folder')
            ->load( { id => \@ids, category_set_id => 0 } );
    }
    else {
        @folders = MT->model('folder')
            ->load( { blog_id => $blog->id, category_set_id => 0 } );
    }

    my $data = {};

    if (@folders) {
        $data->{':order'}
            = get_ordered_basenames( \@folders, $blog->folder_order );
    }

    my @tops = grep { !$_->parent } @folders;
    for my $top (@tops) {
        $data->{ $top->basename } = build_category_tree( \@folders, $top );
    }

    return %$data ? $data : undef;
}

1;
