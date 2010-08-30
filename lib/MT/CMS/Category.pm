# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Category;

use strict;
use MT::Util qw( encode_url encode_js );

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    my $blog = $app->blog;

    if ($id) {
        $param->{nav_categories} = 1;

        #$param{ "tab_" . ( $app->param('tab') || 'details' ) } = 1;

        # $app->add_breadcrumb($app->translate('Categories'),
        #                      $app->uri( 'mode' => 'list_cat',
        #                          args => { blog_id => $obj->blog_id }));
        # $app->add_breadcrumb($obj->label);
        my $parent   = $obj->parent_category;
        my $site_url = $blog->site_url;
        $site_url .= '/' unless $site_url =~ m!/$!;
        $param->{path_prefix} =
          $site_url . ( $parent ? $parent->publish_path : '' );
        $param->{path_prefix} .= '/' unless $param->{path_prefix} =~ m!/$!;
        require MT::Trackback;
        my $tb = MT::Trackback->load( { category_id => $obj->id } );

        if ($tb) {
            my $list_pref = $app->list_pref('ping');
            %$param = ( %$param, %$list_pref );
            my $path = $app->config('CGIPath');
            $path .= '/' unless $path =~ m!/$!;
            if ($path =~ m!^/!) {
                my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
                $path = $blog_domain . $path;
            }

            my $script = $app->config('TrackbackScript');
            $param->{tb}     = 1;
            $param->{tb_url} = $path . $script . '/' . $tb->id;
            if ( $param->{tb_passphrase} = $tb->passphrase ) {
                $param->{tb_url} .= '/' . encode_url( $param->{tb_passphrase} );
            }
            $app->load_list_actions( 'ping', $param->{ping_table}[0],
                'pings' );
        }
    }

    my $type = $app->param('type') || $app->param('_type') || MT::Category->class_type;
    my $entry_class;
    my $entry_type;
    if ( $type eq 'category' ) {
        $entry_type = 'entry';
    }
    elsif ( $type eq 'folder' ) {
        $entry_type = 'page';
    }
    $entry_class = $app->model($entry_type);

    $param->{search_label}     = $entry_class->class_label_plural;
    $param->{search_type}      = $entry_type;

    1;
}

sub list {
    my $app   = shift;
    my $q     = $app->param;

    require MT::Category;
    my $type = $app->param('type') || $app->param('_type') || MT::Category->class_type;
    my $class = $app->model($type);

    my $perms = $app->permissions;
    my $entry_class;
    my $entry_type;
    if ( $type eq 'category' ) {
        $entry_type = 'entry';
        return $app->permission_denied()
            unless $app->can_do('access_to_category_list');
    }
    elsif ( $type eq 'folder' ) {
        $entry_type = 'page';
        return $app->permission_denied()
            unless $app->can_do('access_to_folder_list');
    }
    $entry_class = $app->model($entry_type);
    my $blog_id = scalar $q->param('blog_id');
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        if (!$blog || (!$blog->is_blog && $type eq 'category'));

    my %param;
    my %authors;
    my $data = $app->_build_category_list(
        blog_id    => $blog_id,
        counts     => 1,
        new_cat_id => scalar $q->param('new_cat_id'),
        type       => $type
    );
    if ( $blog->site_url =~ /\/$/ ) {
        $param{blog_site_url} = $blog->site_url;
    }
    else {
        $param{blog_site_url} = $blog->site_url . '/';
    }
    $param{object_loop} = $param{category_loop} = $data;
    $param{saved} = $q->param('saved');
    $param{saved_deleted} = $q->param('saved_deleted');
    $app->load_list_actions( $type, \%param );

    #$param{nav_categories} = 1;
    $param{sub_object_label} =
        $type eq 'folder'
      ? $app->translate('Subfolder')
      : $app->translate('Subcategory');
    $param{object_label}        = $class->class_label;
    $param{object_label_plural} = $class->class_label_plural;
    $param{object_type}         = $type;
    $param{entry_label_plural}  = $entry_class->class_label_plural;
    $param{entry_label}         = $entry_class->class_label;
    $param{search_label}        = $param{entry_label_plural};
    $param{search_type}         = $entry_type;
    $param{screen_id} =
        $type eq 'folder'
      ? 'list-folder'
      : 'list-category';
    $param{listing_screen}      = 1;
    $app->add_breadcrumb( $param{object_label_plural} );

    $param{screen_class} = "list-${type}";
    $param{screen_class} .= " list-category"
      if $type eq 'folder';    # to piggyback on list-category styles
    my $tmpl_file = 'list_' . $type . '.tmpl';
    $app->load_tmpl( $tmpl_file, \%param );
}

sub save {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;
    my $type  = $q->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");

    if ( $type eq 'category' ) {
        return $app->permission_denied()
            unless $app->can_do('save_category');
    }
    elsif ( $type eq 'folder' ) {
        return $app->permission_denied()
            unless $app->can_do('save_folder');
    }

    $app->validate_magic() or return;

    my $blog_id = $q->param('blog_id');
    my $cat;
    if ( my $moved_cat_id = $q->param('move_cat_id') ) {
        $cat = $class->load( $q->param('move_cat_id') )
            or return;
        move_category($app) or return;
    }
    else {
        for my $p ( $q->param ) {
            my ($parent) = $p =~ /^category-new-parent-(\d+)$/;
            next unless ( defined $parent );

            my $label = $q->param($p);
            $label =~ s/(^\s+|\s+$)//g;
            next unless ( $label ne '' );

            $cat = $class->new;
            my $original = $cat->clone;
            $cat->blog_id($blog_id);
            $cat->label($label);
            $cat->author_id( $app->user->id );
            $cat->parent($parent);

            $app->run_callbacks( 'cms_pre_save.' . $type,
                $app, $cat, $original )
              || return $app->errtrans( "Saving [_1] failed: [_2]", $class->class_label,
                $app->errstr );

            $cat->save
              or return $app->error(
                $app->translate(
                    "Saving [_1] failed: [_2]",
                    $class->class_label, $cat->errstr
                )
              );

            # Now post-process it.
            $app->run_callbacks( 'cms_post_save.' . $type,
                $app, $cat, $original );
        }
    }

    return $app->errtrans( "The [_1] must be given a name!", $class->class_label )
      if !$cat;

    $app->call_return( 'saved' => 1, new_cat_id => $cat->id, );
}

sub bulk_update {
    my $app = shift;
    $app->can_do('manage_categories')
        or return $app->json_error(
            $app->translate( "Permission denied." ));

    my $blog_id = $app->param('blog_id');
    my $blog    = $app->blog;
    my $model   = $app->param('datasource') || 'category';
    my $class   = MT->model($model);

    my $objects;
    if ( my $json = $app->param('objects') ) {
        if ( $json =~ /^".*"$/ ) {
            $json =~ s/^"//;
            $json =~ s/"$//;
            $json =~ s/\\"/"/g;
        }
        require JSON;
        my $decode = JSON->new->utf8(0);
        $objects = $decode->decode($json);
    }
    else {
        $objects = [];
    }
    my @old_objects = $class->load({ blog_id => $blog_id });

    # Test CheckSum
    my $meta = $model . '_order';
    my $text = join(
        ':',
        $app->blog->$meta,
        map {
            join(
                ':',
                $_->id,
                ( $_->parent || '0' ),
                Encode::encode_utf8($_->label),
            )
        }
        sort { $a->id <=> $b->id } @old_objects
    );
    require Digest::MD5;
    if ( $app->param('checksum') ne Digest::MD5::md5_hex( $text ) ) {
        return $app->json_error( $app->translate(
            'Failed to update [_1]: some of [_2] were changed after you opened this screen.',
            $class->class_label_plural,
            $class->class_label_plural,
        ))
    }

    my %old_objects = map { $_->id => $_ } @old_objects;
    my @objects;
    my @creates;
    my @updated;
    for my $obj ( @$objects ) {
        next unless $obj->{id};
        #return $app->json_error(MT->translate('Invalid request')) unless $obj->{id};
        if ( $obj->{id} =~ /^x(\d+)/ ) {
            my $tmp_id = $1;
            my $new_obj = $class->new;
            delete $obj->{id};
            $new_obj->set_values($obj);
            $new_obj->blog_id($blog_id);
            push @objects, $new_obj;
            push @creates, $new_obj;
            $new_obj->{tmp_id} = $tmp_id;
        }
        else {
            my $diff = 0;
            exists $old_objects{$obj->{id}}
                or return $app->json_error(
                    $app->translate(
                        'Tried to update [_1]([_2]), but the object not found.',
                        $model,
                        $obj->{id},
                    ));
            my $exist = delete $old_objects{$obj->{id}};
            for my $key ( keys %$obj ) {
                if ( $exist->$key ne $obj->{$key} ) {
                    $diff++;
                    $exist->$key($obj->{$key});
                }
            }
            push @objects, $exist;
            push @updated, $exist if $diff;
        }
    }
    my %TEMP_MAP;
    for my $create ( @creates ) {
        if ( $create->parent =~ /^x(\d+)/ ) {
            my $tmp_id = $1;
            $create->parent( $TEMP_MAP{$tmp_id} );
        }
        $create->save;
        $TEMP_MAP{ $create->{tmp_id} } = $create->id;
    }
    for my $updated ( @updated ) {
        if ( $updated->parent =~ /^x(\d+)/ ) {
            my $tmp_id = $1;
            $updated->parent( $TEMP_MAP{$tmp_id} );
        }
        $updated->save;
    }

    $class->remove({ id => [ keys %old_objects ] })
        if keys %old_objects;

    my @ordered_ids = map { $_->id } @objects;
    my $order = join ',', @ordered_ids;
    my $meta = $model . '_order';
    $blog->$meta($order);
    $blog->save;
    $app->forward( 'filtered_list' );
}

sub category_add {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type') || 'category';
    my $pkg  = $app->model($type);
    my $data = $app->_build_category_list(
        blog_id => scalar $q->param('blog_id'),
        type    => $type
    );
    my %param;
    $param{'category_loop'} = $data;
    $app->add_breadcrumb( $app->translate( 'Add a [_1]', $pkg->class_label ) );
    $param{object_type}  = $type;
    $param{object_label} = $pkg->class_label;
    $app->load_tmpl( 'popup/category_add.tmpl', \%param );
}

sub category_do_add {
    my $app    = shift;
    my $q      = $app->param;
    my $type   = $q->param('_type') || 'category';
    my $author = $app->user;
    my $pkg    = $app->model($type);
    $app->validate_magic() or return;
    my $name = $q->param('label')
      or return $app->error( $app->translate("No label") );
    $name =~ s/(^\s+|\s+$)//g;
    return $app->errtrans("Category name cannot be blank.")
      if $name eq '';
    my $parent   = $q->param('parent') || '0';
    my $cat      = $pkg->new;
    my $original = $cat->clone;
    $cat->blog_id( scalar $q->param('blog_id') );
    $cat->author_id( $app->user->id );
    $cat->label($name);
    $cat->parent($parent);

    if ( !$author->is_superuser ) {
        $app->run_callbacks( 'cms_save_permission_filter.' . $type,
            $app, undef )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
    }

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . $type, $app )
      || return;

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $cat, $original )
      || return;

    $cat->save or return $app->error( $cat->errstr );

    # Now post-process it.
    $app->run_callbacks( 'cms_post_save.' . $type, $app, $cat, $original )
      or return;

    my $id = $cat->id;
    $name = encode_js($name);
    my %param = ( javascript => <<SCRIPT);
    o.doAddCategoryItem('$name', '$id');
SCRIPT
    $app->load_tmpl( 'reload_opener.tmpl', \%param );
}

sub js_add_category {
    my $app = shift;
    unless ( $app->validate_magic ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;
    my $type    = $app->param('_type') || 'category';
    my $class   = $app->model($type);
    if ( !$class ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $label = $app->param('label');
    my $basename = $app->param('basename');
    if ( !defined($label) || ( $label =~ m/^\s*$/ ) ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $blog = $app->blog;
    if ( !$blog ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $parent;
    if ( my $parent_id = $app->param('parent') ) {
        if ( $parent_id != -1 ) {    # special case for 'root' folder
            $parent = $class->load( { id => $parent_id, blog_id => $blog_id } );
            if ( !$parent ) {
                return $app->json_error( $app->translate("Invalid request.") );
            }
        }
    }

    my $obj      = $class->new;
    my $original = $obj->clone;

    if (
        !$app->run_callbacks(
            'cms_save_permission.' . $type,
            $app, $obj, $original
        )
      )
    {
        return $app->json_error( $app->translate("Permission denied.") );
    }

    $obj->label($label);
    $obj->basename($basename)   if $basename;
    $obj->parent( $parent->id ) if $parent;
    $obj->blog_id($blog_id);
    $obj->author_id( $user->id );
    $obj->created_by( $user->id );

    if (
        !$app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $original ) )
    {
        return $app->json_error( $app->errstr );
    }

    $obj->save;

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original );

    return $app->json_result(
        {
            id       => $obj->id,
            basename => $obj->basename
        }
    );
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('open_category_edit_screen');
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('save_category');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    $app->can_do('delete_category');
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $pkg = $app->model('category');
    if ( defined( my $pass = $app->param('tb_passphrase') ) ) {
        $obj->{__tb_passphrase} = $pass;
    }
    my @siblings = $pkg->load(
        {
            parent  => $obj->parent,
            blog_id => $obj->blog_id
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
"The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.",
                $_->label
            )
        ) if $_->label eq $obj->label;
        return $eh->error(
            $app->translate(
"The category basename '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.",
                $_->label
            )
        ) if $_->basename eq $obj->basename;
    }
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Category '[_1]' created by '[_2]'", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'category',
                category => 'new',
            }
        );
    }
    1;
}

sub save_filter {
    my $eh = shift;
    my ($app) = @_;
    return $app->errtrans( "The name '[_1]' is too long!",
        $app->param('label') )
      if ( length( $app->param('label') ) > 100 );
    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Category '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub _adjust_ancestry {
    my ( $cat, $ancestor ) = @_;
    return unless $cat && $ancestor;
    if ( $ancestor->parent && ( $ancestor->parent != $cat->id ) ) {
        _adjust_ancestry($cat, $ancestor->parent_category);
    }
    else {
        $ancestor->parent($cat->parent);
        $ancestor->save;
    }
}

sub move_category {
    my $app   = shift;
    my $type  = $app->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");
    $app->validate_magic() or return;

    my $cat        = $class->load( $app->param('move_cat_id') )
        or return;

    my $new_parent_id = $app->param('move-radio');

    return 1 if ( $new_parent_id == $cat->parent );

    if ( $new_parent_id ) {
        my $new_parent = $class->load( $new_parent_id )
            or return;
       if ( $cat->is_ancestor( $new_parent ) ) {
            _adjust_ancestry( $cat, $new_parent );
        }
    }
    $cat->parent($new_parent_id);
    if ( $type eq 'category' ) {    # folder is able to have a same label
        my @siblings = $class->load(
            {   parent  => $cat->parent,
                blog_id => $cat->blog_id
            }
        );
        foreach (@siblings) {
            return $app->errtrans(
                "The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.",
                $_->label
            ) if $_->label eq $cat->label;
        }
    }

    $cat->save
      or return $app->error(
        $app->translate( "Saving [_1] failed: [_2]", $class->class_label, $cat->errstr ) );
}

sub pre_load_filtered_list {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    delete $opts->{limit};
    delete $opts->{offset};
    delete $opts->{sort_order};
    $opts->{sort_by} = 'custom_sort';
    @$cols = qw( id parent label entry_count );
}

sub filtered_list_param {
    my ( $cb, $app, $param, $objs ) = @_;
    my $type = $app->param('datasource');
    my $meta = $type . '_order';
    my $text = join(
        ':',
        $app->blog->$meta,
        map {
            join(
                ':',
                $_->id,
                $_->parent,
                Encode::encode_utf8($_->label),
            )
        }
        sort { $a->id <=> $b->id } @$objs
    );
    require Digest::MD5;
    $param->{checksum} = Digest::MD5::md5_hex( $text );
}

1;
