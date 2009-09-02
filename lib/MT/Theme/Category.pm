# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Category.pm 109737 2009-08-21 23:22:07Z daiello $
package MT::Theme::Category;
use strict;
use MT;

sub import_categories {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    _add_categories( $theme, $obj_to_apply, $cats, 'category' )
        or die "Failed to create theme default categories";;
    return 1;
}

sub import_folders {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    _add_categories( $theme, $obj_to_apply, $cats, 'folder' )
        or die "Failed to create theme default folders";;
    return 1;
}

sub _add_categories {
    my ( $theme, $blog, $cat_data, $class, $parent ) = @_;

    for my $basename ( keys %$cat_data ) {
        my $datum = $cat_data->{$basename};
        my $cat = MT->model($class)->load({
            blog_id => $blog->id,
            basename => $basename,
        });
        unless ( $cat ) {
            $cat = MT->model($class)->new;
            $cat->blog_id($blog->id);
            $cat->basename($basename);
            for my $key (qw{ label description }) {
                my $val = $datum->{$key};
                if ( ref $val eq 'CODE' ) {
                    $val = $val->();
                }
                else {
                    $val = $theme->translate($val) if $val;
                }
                $cat->$key( $val );
            }
            $cat->allow_pings( $datum->{allow_pings} || 0 );
            $cat->parent( $parent->id )
                if defined $parent;
            $cat->save;
        }
        if ( my $children = $datum->{children} ) {
            _add_categories( $theme, $blog, $children, $class, $cat );
        }
    }
    1;
}

sub info_categories {
    my ( $element, $theme, $blog ) = @_;
    my $data = $element->{data};
    my ( $parents, $children ) = (0,0);
    for my $parent ( values %$data ) {
        $parents++;
        $children += _count_descendant_categories($parent, 0);
    }
    return sub { MT->translate( '[_1] top level and [_2] sub categories.', $parents, $children ) };
}

sub info_folders {
    my ( $element, $theme, $blog ) = @_;
    my $data = $element->{data};
    my ( $parents, $children ) = (0,0);
    for my $parent ( values %$data ) {
        $parents++;
        $children += _count_descendant_categories($parent, 0);
    }
    return sub { MT->translate( '[_1] top level and [_2] sub folders.', $parents, $children ) };
}

sub _count_descendant_categories {
    my ( $data, $count ) = @_;
    my $children = $data->{children};
    for my $child ( values %$children ) {
        $count++;
        $count += _count_descendant_categories( $child, $count );
    }
    $count;
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
    if ( $saved ) {
        %checked_ids = map { $_ => 1 } @{$saved->{default_category_export_ids}};
    }
    for my $cat ( @$list ) {
        $cat->{checked} = $saved ? $checked_ids{$cat->{category_id}} : 1;
    }
    my %param = ( categories => $list );
    return $app->load_tmpl( 'include/theme_exporters/category.tmpl', \%param);
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
    if ( $saved ) {
        %checked_ids = map { $_ => 1 } @{$saved->{default_folder_export_ids}};
    }
    for my $cat ( @$list ) {
        $cat->{checked} = $saved ? $checked_ids{$cat->{category_id}} : 1;
    }
    my %param = ( folders => $list );
    return $app->load_tmpl( 'include/theme_exporters/folder.tmpl', \%param);
}

sub export_category {
    my ( $app, $blog, $settings ) = @_;
    my @cats;
    if ( defined $settings ) {
        my @ids = $settings->{default_category_export_ids};
        @cats = MT->model('category')->load({ id => \@ids });
    }
    else {
        @cats = MT->model('category')->load({ blog_id => $blog->id });
    }
    my @tops = grep { ! $_->parent } @cats;
    my $data = {};
    for my $top ( @tops ) {
        $data->{ $top->basename } = _build_tree( \@cats, $top );
    }
    return %$data ? $data : undef;
}

sub export_folder {
    my ( $app, $blog, $settings ) = @_;
    my $q = $app->param;
    my @ids = $q->param('default_folder_export_ids');
    return unless scalar @ids;
    my @cats = MT->model('folder')->load({ blog_id => $blog->id, id => \@ids });
    my @tops = grep { ! $_->parent } @cats;
    my $data = {};
    for my $top ( @tops ) {
        $data->{ $top->basename } = _build_tree( \@cats, $top );
    }
    return %$data ? $data : undef;
}

sub _build_tree {
    my ( $cats, $cat ) = @_;
    my $hash = {
        label => $cat->label,
    };
    $hash->{description} = $cat->description if $cat->description;
    my @children = grep { $_->parent == $cat->id } @$cats;
    if ( scalar @children ) {
        $hash->{children} = {};
        for my $child ( @children ) {
            $hash->{children}{$child->basename} = _build_tree( $cats, $child );
        }
    }
    return $hash;
}

1;

