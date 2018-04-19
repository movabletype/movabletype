# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::CategorySetCategory;
use strict;
use warnings;

use MT;
use MT::CMS::Category;

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    if ( $obj && !ref $obj ) {
        $obj = MT->model('category')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->category_set;
    }

    my $author = $app->user;
    return 1 if $author->is_superuser();

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    $author->permissions($blog_id)->can_do('delete_category_set_category');
}

sub can_save {
    my ( $eh, $app, $id, $obj, $origin ) = @_;
    if ($id) {
        if ( !ref $id ) {
            $obj ||= MT->model('category')->load($id)
                or return;
        }
        else {
            $obj = $id;
        }
    }
    if ($obj) {
        return unless $obj->category_set;
    }

    my $author = $app->user;
    return 1 if $author->is_superuser();

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    $author->permissions($blog_id)->can_do('save_catefory_set_category');
}

sub can_view {
    my ( $eh, $app, $obj ) = @_;
    if ( $obj && !ref $obj ) {
        $obj = MT->model('category')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->category_set;
    }

    my $author = $app->user;
    return 1 if $author->is_superuser();

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    $author->permissions($blog_id)
        ->can_do('open_category_set_category_edit_screen');
}

sub edit {
    my ( $cb, $app, $id, $obj, $param ) = @_;

    return $cb->trans_error('Invalid request.') unless $obj->category_set;

    my $blog = $app->blog;

    if ($id) {
        $param->{nav_categories} = 1;
        my $parent   = $obj->parent_category;
        my $site_url = $blog->site_url;
        $site_url .= '/' unless $site_url =~ m!/$!;
        $param->{path_prefix}
            = $site_url . ( $parent ? $parent->publish_path : '' );
        $param->{path_prefix} .= '/' unless $param->{path_prefix} =~ m!/$!;
    }

    my $type
        = $app->param('type')
        || $app->param('_type')
        || MT::Category->class_type;
    my $entry_type  = 'content_data';
    my $entry_class = $app->model($entry_type);

    $param->{search_label} = $entry_class->class_label_plural;
    $param->{search_type}  = $entry_type;

    ## author_id parameter of the author currently logged in.
    delete $param->{'author_id'};

    $app->add_breadcrumb(
        $app->model('category_set')->class_label_plural,
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'category_set',
                blog_id => $blog->id,
            },
        ),
    );
    $app->add_breadcrumb(
        $obj->category_set->name,
        $app->uri(
            mode => 'view',
            args => {
                _type   => 'category_set',
                blog_id => $blog->id,
                id      => $obj->category_set_id,
            },
        ),
    );
    $app->add_breadcrumb( $obj->label );

    1;
}

sub filtered_list_param {
    my ( $cb, $app, $param, $objs ) = @_;

    my $sort_order = '';
    if ( my $set_id = $app->param('set_id') ) {
        my $set = $app->model('category_set')->load($set_id);
        $sort_order = $set->order || '';
        $param->{category_set_id} = $set_id;
    }

    require Encode;
    my $text = join(
        ':',
        $sort_order,
        map {
            join( ':', $_->id, $_->parent, Encode::encode_utf8( $_->label ), )
            }
            sort { $a->id <=> $b->id } @{ $objs || [] }
    );
    require Digest::MD5;
    $param->{checksum} = Digest::MD5::md5_hex($text);

}

sub post_delete {
    MT::CMS::Category::post_delete(@_);
}

sub post_save {
    MT::CMS::Category::post_save(@_);
}

sub pre_load_filtered_list {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    delete $opts->{limit};
    delete $opts->{offset};
    delete $opts->{sort_order};
    $opts->{sort_by} = 'custom_sort';
    @$cols = qw( id parent label basename );

    if ( my $set_id = $app->param('set_id') ) {
        $opts->{terms} ||= {};
        $opts->{terms}{category_set_id} = $set_id;
    }
    elsif ( $app->param('is_category_set') ) {
        $opts->{terms} ||= {};
        $opts->{terms}{id} = 0;    # return no data
    }
}

sub pre_save {
    MT::CMS::Category::pre_save(@_);
}

sub save_filter {
    MT::CMS::Category::save_filter(@_);
}

sub template_param_list {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blog = $app->blog or return;
    $param->{basename_limit} = $blog->basename_limit || 30; #FIXME: hardcoded.
    my $type  = $app->param('_type');
    my $class = MT->model($type);
    $param->{basename_prefix} = $class->basename_prefix;

    $param->{is_category_set} = 1;

    my $set_id = $app->param('id');
    my $set = MT->model('category_set')->load( $set_id || 0 );

    if ($set) {
        $param->{id}       = $set->id;
        $param->{set_name} = $set->name;
    }

    my $object_label = $app->translate('Category Set');
    $param->{page_title}
        = $set
        ? $app->translate( "Edit [_1]",   $object_label )
        : $app->translate( "Create [_1]", $object_label );

    $app->{breadcrumbs} = [];
    $app->add_breadcrumb(
        $app->translate('Category Sets'),
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'category_set',
                blog_id => $app->blog->id,
            },
        ),
    );

    $param->{object_label} = MT->model('category')->class_label;

    if ( $param->{id} ) {
        $app->add_breadcrumb( $param->{set_name} );
    }
    else {
        $app->add_breadcrumb( $app->translate('Create Category Set') );
    }
}

1;

