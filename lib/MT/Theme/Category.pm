# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::Category;
use strict;
use MT;

sub import_categories {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    _add_categories( $theme, $obj_to_apply, $cats, 'category' )
        or die "Failed to create theme default categories";
    return 1;
}

sub import_folders {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $cats = $element->{data};
    _add_categories( $theme, $obj_to_apply, $cats, 'folder' )
        or die "Failed to create theme default folders";
    return 1;
}

sub _add_categories {
    my ( $theme, $blog, $cat_data, $class, $parent ) = @_;

    my $author_id;
    if ( my $app = MT->instance ) {
        if ( $app->isa('MT::App') ) {
            my $author = $app->user;
            $author_id = $author->id if defined $author;
        }
    }
    unless ( defined $author_id ) {

        # Fallback 1: created_by from this blog.
        $author_id = $blog->created_by if defined $blog->created_by;
    }
    unless ( defined $author_id ) {

        # Fallback 2: One of this blog's administrator
        my $search_string
            = $blog->is_blog
            ? '%\'administer_blog\'%'
            : '%\'administer_website\'%';
        my $perm = MT->model('permission')->load(
            {   blog_id     => $blog->id,
                permissions => { like => $search_string },
            }
        );
        $author_id = $perm->author_id if $perm;
    }
    unless ( defined $author_id ) {

        # Fallback 3: One of system administrator
        my $perm = MT->model('permission')->load(
            {   blog_id     => 0,
                permissions => { like => '%administer%' },
            }
        );
        $author_id = $perm->author_id if $perm;
    }
    die "Failed to create theme default pages"
        unless defined $author_id;

    for my $basename ( keys %$cat_data ) {
        my $datum = $cat_data->{$basename};
        my $cat   = MT->model($class)->load(
            {   blog_id  => $blog->id,
                basename => $basename,
                parent   => $parent ? $parent->id : 0
            }
        );
        unless ($cat) {
            $cat = MT->model($class)->new;
            $cat->blog_id( $blog->id );
            $cat->basename($basename);
            for my $key (qw{ label description }) {
                my $val = $datum->{$key};
                if ( ref $val eq 'CODE' ) {
                    $val = $val->();
                }
                else {
                    $val = $theme->translate($val) if $val;
                }
                $cat->$key($val);
            }
            $cat->allow_pings( $datum->{allow_pings} || 0 );
            $cat->author_id($author_id);
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
    my ( $parents, $children ) = ( 0, 0 );
    for my $parent ( values %$data ) {
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
    my $cat = MT->model('category')
        ->load( { blog_id => $blog->id }, { limit => 1 } );
    return defined $cat ? 1 : 0;
}

sub folder_condition {
    my ($blog) = @_;
    my $cat = MT->model('folder')
        ->load( { blog_id => $blog->id }, { limit => 1 } );
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
        @cats = MT->model('category')->load( { id => \@ids } );
    }
    else {
        @cats = MT->model('category')->load( { blog_id => $blog->id } );
    }
    my @tops = grep { !$_->parent } @cats;
    my $data = {};
    for my $top (@tops) {
        $data->{ $top->basename } = _build_tree( \@cats, $top );
    }
    return %$data ? $data : undef;
}

sub export_folder {
    my ( $app, $blog, $settings ) = @_;
    my @folders;
    if ( defined $settings ) {
        my @ids = $settings->{default_folder_export_ids};
        @folders = MT->model('folder')->load( { id => \@ids } );
    }
    else {
        @folders = MT->model('folder')->load( { blog_id => $blog->id } );
    }
    my @tops = grep { !$_->parent } @folders;
    my $data = {};
    for my $top (@tops) {
        $data->{ $top->basename } = _build_tree( \@folders, $top );
    }
    return %$data ? $data : undef;
}

sub _build_tree {
    my ( $cats, $cat ) = @_;
    my $hash = { label => $cat->label, };
    $hash->{description} = $cat->description if $cat->description;
    my @children = grep { $_->parent == $cat->id } @$cats;
    if ( scalar @children ) {
        $hash->{children} = {};
        for my $child (@children) {
            $hash->{children}{ $child->basename }
                = _build_tree( $cats, $child );
        }
    }
    return $hash;
}

1;
