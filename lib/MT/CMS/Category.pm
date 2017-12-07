# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Category;

use strict;
use warnings;
use MT::Util qw( encode_url encode_js );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

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
        $param->{path_prefix}
            = $site_url . ( $parent ? $parent->publish_path : '' );
        $param->{path_prefix} .= '/' unless $param->{path_prefix} =~ m!/$!;
        require MT::Trackback;
        my $tb = MT::Trackback->load( { category_id => $obj->id } );

        if ($tb) {
            my $list_pref = $app->list_pref('ping');
            %$param = ( %$param, %$list_pref );
            my $path = $app->config('CGIPath');
            $path .= '/' unless $path =~ m!/$!;
            if ( $path =~ m!^/! ) {
                my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
                $path = $blog_domain . $path;
            }

            my $script = $app->config('TrackbackScript');
            $param->{tb}     = 1;
            $param->{tb_url} = $path . $script . '/' . $tb->id;
            if ( $param->{tb_passphrase} = $tb->passphrase ) {
                $param->{tb_url}
                    .= '/' . encode_url( $param->{tb_passphrase} );
            }
            $app->load_list_actions( 'ping', $param->{ping_table}[0],
                'pings' );
        }
    }

    my $type
        = $app->param('type')
        || $app->param('_type')
        || MT::Category->class_type;
    my $entry_class;
    my $entry_type;
    if ( $type eq 'category' ) {
        $entry_type = 'entry';
    }
    elsif ( $type eq 'folder' ) {
        $entry_type = 'page';
    }
    $entry_class = $app->model($entry_type);

    $param->{search_label} = $entry_class->class_label_plural;
    $param->{search_type}  = $entry_type;

    $param->{can_view_trackbacks} = $app->can_do('access_to_trackback_list');

    ## author_id parameter of the author currently logged in.
    delete $param->{'author_id'};

    1;
}

sub save {
    my $app   = shift;
    my $perms = $app->permissions;
    my $type  = $app->param('_type');
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
    else {
        return $app->errtrans("Invalid request.");
    }

    $app->validate_magic() or return;

    my $blog_id = $app->param('blog_id');
    my $cat;
    if ( my $moved_cat_id = $app->param('move_cat_id') ) {
        $cat = $class->load($moved_cat_id) or return;
        move_category($app) or return;
    }
    else {
        for my $p ( $app->multi_param ) {
            my ($parent) = $p =~ /^category-new-parent-(\d+)$/;
            next unless ( defined $parent );

            my $label = $app->param($p);
            next unless defined $label;

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
                || return $app->errtrans( "Saving [_1] failed: [_2]",
                $class->class_label, $app->errstr );

            $cat->save
                or return $app->error(
                $app->translate(
                    "Saving [_1] failed: [_2]", $class->class_label,
                    $cat->errstr
                )
                );

            # Now post-process it.
            $app->run_callbacks( 'cms_post_save.' . $type,
                $app, $cat, $original );
        }
    }

    return $app->errtrans( "The [_1] must be given a name!",
        $class->class_label )
        if !$cat;

    $app->call_return( 'saved' => 1, new_cat_id => $cat->id, );
}

sub bulk_update {
    my $app = shift;
    $app->validate_magic or return;

    my $is_category_set = $app->param('is_category_set');
    my $set_id          = $app->param('set_id');

    my $model = $app->param('datasource') || 'category';
    if ( 'category' eq $model ) {
        $app->can_do('edit_categories')
            or
            return $app->json_error( $app->translate("Permission denied.") );

        if ($is_category_set) {
            return $app->json_error( $app->translate('Permission defined.') )
                unless $app->can_do('save_category_set');
        }
    }
    elsif ( 'folder' eq $model ) {
        $app->can_do('save_folder')
            or
            return $app->json_error( $app->translate("Permission denied.") );
    }
    else {
        return $app->json_error( $app->translate('Invalid request.') );
    }

    my $blog_id = $app->param('blog_id');
    my $blog    = $app->blog;
    my $class   = MT->model($model);
    my @messages;
    my $objects;
    if ( my $json = $app->param('objects') ) {
        if ( $json =~ /^".*"$/ ) {
            $json =~ s/^"//;
            $json =~ s/"$//;
            $json = MT::Util::decode_js($json);
        }
        require JSON;
        my $decode = JSON->new->utf8(0);
        $objects = $decode->decode($json);
    }
    else {
        $objects = [];
    }

    my $set;
    if ($is_category_set) {
        if ($set_id) {
            $set = MT->model('category_set')->load($set_id)
                or return $app->errtrans( 'Invalid category_set_id: [_1]',
                $set_id );
            $set->name( scalar $app->param('set_name') );
            $set->save or return $app->error( $set->errstr );
        }
        else {
            $set = MT->model('category_set')->new;
            $set->set_values(
                {   blog_id => $blog_id,
                    name    => scalar $app->param('set_name'),
                }
            );
            $set->save or return $app->error( $set->errstr );
            $set_id = $set->id;
            $app->request( 'new_category_set_id', $set_id );
        }
    }

    my $old_objects_terms;
    if ($set_id) {
        $old_objects_terms
            = { blog_id => $blog_id, category_set_id => $set_id };
    }
    elsif ($is_category_set) {
        $old_objects_terms = { id => 0 };    # no data
    }
    else {
        $old_objects_terms
            = { blog_id => $blog_id, category_set_id => [ \'IS NULL', 0 ] };
    }
    my @old_objects = $class->load($old_objects_terms);

    # Test CheckSum
    my $cat_order;
    my $meta = $model . '_order';
    if ($is_category_set) {
        $cat_order = $set->order || '';
    }
    else {
        $cat_order = $app->blog->$meta || '';
    }

    my $text = join(
        ':',
        $cat_order,
        map {
            join( ':',
                $_->id,
                ( $_->parent || '0' ),
                Encode::encode_utf8( $_->label ),
                )
            }
            sort { $a->id <=> $b->id } @old_objects
    );
    require Digest::MD5;
    if ( ( $app->param('checksum') || '' ) ne Digest::MD5::md5_hex($text) ) {
        return $app->json_error(
            $app->translate(
                'Failed to update [_1]: Some of [_2] were changed after you opened this page.',
                $class->class_label_plural,
                $class->class_label_plural,
            )
        );
    }

    my %old_objects = map { $_->id => $_ } @old_objects;
    my %clone_objects;
    my @objects;
    my @creates;
    my @updated;
    for my $obj (@$objects) {
        next unless $obj->{id};

 #return $app->json_error(MT->translate('Invalid request')) unless $obj->{id};
        if ( $obj->{id} =~ /^x(\d+)/ ) {
            my $tmp_id  = $1;
            my $new_obj = $class->new;
            $clone_objects{ $obj->{id} } = $new_obj->clone;
            delete $obj->{id};
            $new_obj->set_values($obj);
            $new_obj->blog_id($blog_id);
            $new_obj->author_id( $app->user->id );
            $new_obj->category_set_id($set_id) if $set_id;
            push @objects, $new_obj;
            push @creates, $new_obj;
            $new_obj->{tmp_id} = $tmp_id;
        }
        else {
            my $diff = 0;
            exists $old_objects{ $obj->{id} }
                or return $app->json_error(
                $app->translate(
                    'Tried to update [_1]([_2]), but the object was not found.',
                    $model,
                    $obj->{id},
                )
                );
            my $exist = delete $old_objects{ $obj->{id} };
            $clone_objects{ $obj->{id} } = $exist->clone;
            for my $key ( keys %$obj ) {
                if ( $exist->$key ne $obj->{$key} ) {
                    $diff++;
                    $exist->$key( $obj->{$key} );
                }
            }
            push @objects, $exist;
            push @updated, $exist if $diff;
        }
    }
    my %TEMP_MAP;
    my ( $creates, $updates, $deletes ) = ( 0, 0, 0 );
    for my $create (@creates) {
        if ( $create->parent =~ /^x(\d+)/ ) {
            my $tmp_id = $1;
            $create->parent( $TEMP_MAP{$tmp_id} );
        }
        my $original = $clone_objects{ 'x' . $create->{tmp_id} };
        $app->run_callbacks( 'cms_pre_save.' . $model,
            $app, $create, $original )
            or return $app->json_error( $app->errstr() );
        $create->save;
        $app->run_callbacks( 'cms_post_save.' . $model,
            $app, $create, $original )
            or return $app->json_error( $app->errstr() );
        $creates++;
        $TEMP_MAP{ $create->{tmp_id} } = $create->id;
    }
    for my $updated (@updated) {
        if ( $updated->parent =~ /^x(\d+)/ ) {
            my $tmp_id = $1;
            $updated->parent( $TEMP_MAP{$tmp_id} );
        }
        my $original = $clone_objects{ $updated->id };
        $app->run_callbacks( 'cms_pre_save.' . $model,
            $app, $updated, $original )
            or return $app->json_error( $app->errstr() );

        # Setting modified_by updates modified_on which we want to do before
        # a save but after pre_save callbacks fire.
        $updated->modified_by( $app->user->id );

        $updated->save;
        $app->run_callbacks( 'cms_post_save.' . $model,
            $app, $updated, $original )
            or return $app->json_error( $app->errstr() );
        $updates++;
    }

    for my $obj ( values %old_objects ) {
        if ( 'category' eq $model ) {

            # Remove published archive files.
            pre_delete( $app, $obj );
        }
        $obj->remove;
        $app->run_callbacks( 'cms_post_delete.' . $model, $app, $obj );
        $deletes++;
    }

    $app->touch_blogs;

    my $previous_order;
    if ($is_category_set) {
        $previous_order = $set->order || '';
    }
    else {
        $previous_order = $blog->$meta || '';
    }

    my @ordered_ids = map { $_->id } @objects;
    my $new_order = join ',', @ordered_ids;
    if ( $previous_order ne $new_order ) {
        $app->log(
            {   message => $app->translate(
                    "[_1] order has been edited by '[_2]'.",
                    $class->class_label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => $blog->class,
                category => 'edit',
                metadata => "[${previous_order}] => [${new_order}]",
            }
        );

        if ($is_category_set) {
            $set->order($new_order);
            $set->save;
        }
        else {
            $blog->$meta($new_order);
            $blog->save;
        }
    }

    $app->run_callbacks( 'cms_post_bulk_save.' . $model, $app, \@objects );

    my $rebuild_url = $app->uri(
        mode => 'rebuild_confirm',
        args => { blog_id => $blog_id, }
    );
    my $rebuild_open
        = qq!window.open('$rebuild_url', 'rebuild_blog_$blog_id', 'width=400,height=400,resizable=yes'); return false;!;

    push @messages,
        {
        cls => 'info',
        msg => MT->translate(
            'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.',
            $creates, $updates, $deletes, $rebuild_open
        ),
        };

    $app->forward( 'filtered_list', messages => \@messages );
}

# DEPRECATED: will be removed.
sub category_add {
    my $app     = shift;
    my $type    = $app->param('_type') || 'category';
    my $blog_id = $app->param('blog_id');
    my $pkg     = $app->model($type);
    my $data    = $app->_build_category_list(
        blog_id => $blog_id,
        type    => $type
    );
    my %param;
    $param{'category_loop'} = $data;
    $app->add_breadcrumb(
        $app->translate( 'Add a [_1]', $pkg->class_label ) );
    $param{object_type}  = $type;
    $param{object_label} = $pkg->class_label;
    $app->load_tmpl( 'popup/category_add.tmpl', \%param );
}

sub category_do_add {
    my $app = shift;
    my $type = $app->param('_type') || 'category';
    return $app->errtrans("Invalid request.")
        unless ( $type eq 'category' )
        or ( $type eq 'folder' );
    my $author = $app->user;
    my $pkg    = $app->model($type);
    $app->validate_magic() or return;
    my $name = $app->param('label')
        or return $app->error( $app->translate("No label") );
    $name =~ s/(^\s+|\s+$)//g;
    return $app->errtrans("The category name cannot be blank.")
        if $name eq '';
    my $parent   = $app->param('parent') || '0';
    my $blog_id  = $app->param('blog_id');
    my $cat      = $pkg->new;
    my $original = $cat->clone;
    $cat->blog_id($blog_id);
    $cat->author_id( $app->user->id );
    $cat->label($name);
    $cat->parent($parent);

    if ( !$author->is_superuser ) {
        $app->run_callbacks( 'cms_save_permission_filter.' . $type,
            $app, undef )
            || return $app->error( $app->translate("Permission denied") );
    }

    my $filter_result
        = $app->run_callbacks( 'cms_save_filter.' . $type, $app )
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
    my $user            = $app->user;
    my $blog_id         = $app->param('blog_id');
    my $perms           = $app->permissions;
    my $type            = $app->param('_type') || 'category';
    my $category_set_id = 0;
    if ( $type eq 'category' ) {
        $category_set_id = $app->param('category_set_id') || 0;
    }
    return $app->json_error( $app->translate("Invalid request.") )
        unless ( $type eq 'category' )
        or ( $type eq 'folder' );
    my $class = $app->model($type);

    if ( !$class ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $label    = $app->param('label');
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
            $parent = $class->load(
                {   id              => $parent_id,
                    blog_id         => $blog_id,
                    category_set_id => $category_set_id || [ \'IS NULL', 0 ],
                }
            );
            if ( !$parent ) {
                return $app->json_error(
                    $app->translate("Invalid request.") );
            }
        }
    }

    my $obj      = $class->new;
    my $original = $obj->clone;

    $obj->label($label);
    $obj->basename($basename)   if $basename;
    $obj->parent( $parent->id ) if $parent;
    $obj->blog_id($blog_id);
    $obj->category_set_id($category_set_id);
    $obj->author_id( $user->id );
    $obj->created_by( $user->id );

    if (!$app->run_callbacks(
            'cms_save_permission_filter.' . $type,
            $app, $obj
        )
        )
    {
        return $app->json_error( $app->translate("Permission denied.") );
    }

    if (!$app->run_callbacks(
            'cms_pre_save.' . $type, $app, $obj, $original
        )
        )
    {
        return $app->json_error( $app->errstr );
    }

    $obj->save;

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original );

    # Update category/folder order by low cost method.
    # So, broken order cannot be updated correctly.
    my $order_field;
    my @order;
    if ($category_set_id) {
        @order = split ',', ( $obj->category_set->order || '' );
    }
    else {
        $order_field = "${type}_order";
        @order = split ',', ( $blog->$order_field || '' );
    }
    if ($parent) {
        @order = map { $_ == $parent->id ? ( $_, $obj->id ) : $_ } @order;
    }
    else {
        unshift @order, $obj->id;
    }
    my $new_order = join ',', @order;
    if ($category_set_id) {
        my $category_set = $obj->category_set;
        $category_set->order($new_order);
        $category_set->save;
    }
    else {
        $blog->$order_field($new_order);
        $blog->save;    # Ignore error.
    }

    return $app->json_result(
        {   id       => $obj->id,
            basename => $obj->basename
        }
    );
}

sub can_view {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('category')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->is_category;
    }

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)
        ->can_do('open_category_edit_screen');
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('category')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->is_category;
    }

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('save_category');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('category')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->is_category;
    }

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_category');
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $pkg = $app->model('category');
    if ( defined( my $pass = $app->param('tb_passphrase') ) ) {
        $obj->{__tb_passphrase} = $pass;
    }
    my @siblings = $pkg->load(
        {   parent          => $obj->parent,
            blog_id         => $obj->blog_id,
            category_set_id => $obj->category_set_id || [ \'IS NULL', 0 ],
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
                "The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.",
                $_->label
            )
        ) if $_->label eq $obj->label;
        return $eh->error(
            $app->translate(
                "The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.",
                $_->basename
            )
        ) if defined $obj->basename and $_->basename eq $obj->basename;
    }
    return $eh->error(
        $app->translate( "The name '[_1]' is too long!", $obj->label ) )
        if ( length( $obj->label ) > 100 );

    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {   message => $app->translate(
                    "Category '[_1]' created by '[_2]'.", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'category',
                category => 'new',
            }
        );
    }
    else {
        $app->log(
            {   message => $app->translate(
                    "Category '[_1]' (ID:[_2]) edited by '[_3]'",
                    $obj->label, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => $obj->class,
                category => 'edit',
                metadata => $obj->id,
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

sub pre_delete {
    my ( $app, $obj ) = @_;

    return 1 unless $app->config('DeleteFilesAtRebuild');

    my $blog = $app->blog or return;
    my $at = $blog->archive_type;

    return 1 unless $at && $at ne 'None';

    require MT::Blog;
    require MT::Entry;
    require MT::Placement;

    # Remove published archive files.

    my @at = split /,/, $at;
    for my $target (@at) {
        my $archiver = $app->publisher->archiver($target);
        next unless $archiver && $archiver->category_based;
        if ( $archiver->date_based ) {
            my @entries = MT::Entry->load(
                { status => MT::Entry::RELEASE() },
                {   join => MT::Placement->join_on(
                        'entry_id',
                        { category_id => $obj->id },
                        { unique      => 1 }
                    )
                }
            );
            for (@entries) {
                $app->publisher->remove_entry_archive_file(
                    Category    => $obj,
                    ArchiveType => $target,
                    Entry       => $_
                );
            }
        }
        else {
            $app->publisher->remove_entry_archive_file(
                Category    => $obj,
                ArchiveType => $target
            );
        }
    }

    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Category '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'category',
            category => 'delete'
        }
    );
}

sub _adjust_ancestry {
    my ( $cat, $ancestor ) = @_;
    return unless $cat && $ancestor;
    if ( $ancestor->parent && ( $ancestor->parent != $cat->id ) ) {
        _adjust_ancestry( $cat, $ancestor->parent_category );
    }
    else {
        $ancestor->parent( $cat->parent );
        $ancestor->save;
    }
}

sub move_category {
    my $app   = shift;
    my $type  = $app->param('_type');
    my $class = $app->model($type)
        or return $app->errtrans("Invalid request.");
    $app->validate_magic() or return;

    my $move_cat_id = $app->param('move_cat_id');
    my $cat         = $class->load($move_cat_id)
        or return;

    my $new_parent_id = $app->param('move-radio') || 0;

    return 1 if ( $new_parent_id == $cat->parent );

    if ($new_parent_id) {
        my $new_parent = $class->load($new_parent_id)
            or return;
        if ( $cat->is_ancestor($new_parent) ) {
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
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $cat->errstr
        )
        );
}

sub template_param_list {
    my ( $cb, $app, $param, $tmpl ) = @_;

    if ( $param->{is_category_set} = $app->param('is_category_set') ) {
        my $set_id = $app->param('id');
        my $set = MT->model('category_set')->load( $set_id || 0 );

        if ($set) {
            $param->{id}       = $set->id;
            $param->{set_name} = $set->name;
        }

        my $verb = $set ? 'Edit' : 'Create';
        my $object_label = $app->translate('Category Set');
        $param->{page_title}
            = $app->translate( "${verb} [_1]", $object_label );
    }
    else {
        $param->{page_title}
            = $app->translate( 'Manage [_1]', $param->{object_label_plural} );
    }

    my $blog = $app->blog or return;
    $param->{basename_limit} = $blog->basename_limit || 30; #FIXME: hardcoded.
    my $type  = $app->param('_type');
    my $class = MT->model($type);
    $param->{basename_prefix} = $class->basename_prefix;

    # for category_set
    if ( $app->isa('MT::App::CMS') ) {
        $param->{saved} = $app->param('saved') ? 1 : 0;
    }
}

sub pre_load_filtered_list {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    delete $opts->{limit};
    delete $opts->{offset};
    delete $opts->{sort_order};
    $opts->{sort_by} = 'custom_sort';
    @$cols = qw( id parent label basename entry_count );

    if ( my $set_id = $app->param('set_id') ) {
        $opts->{terms} ||= {};
        $opts->{terms}{category_set_id} = $set_id;
    }
    elsif ( $app->param('is_category_set') ) {
        $opts->{terms} ||= {};
        $opts->{terms}{id} = 0;    # return no data
    }
    else {
        my $set_id_terms = { category_set_id => [ \'IS NULL', 0 ] };
        if ( $opts->{terms} ) {
            $opts->{terms} = [ $opts->{terms}, $set_id_terms ];
        }
        else {
            $opts->{terms} = $set_id_terms;
        }
    }
}

sub filtered_list_param {
    my ( $cb, $app, $param, $objs ) = @_;

    my $sort_order = '';
    if ( $app->param('is_category_set') ) {
        if ( my $set_id = $app->param('set_id') ) {
            my $set = $app->model('category_set')->load($set_id);
            $sort_order = $set->order || '';
        }
    }
    else {
        my $type = $app->param('datasource');
        my $meta = $type . '_order';
        $sort_order = $app->blog->$meta || '';
    }

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

    if ( my $new_set_id = $app->request('new_category_set_id') ) {
        $param->{redirect_url} = $app->uri(
            mode => 'view',
            args => {
                _type   => 'category_set',
                blog_id => $app->blog->id,
                id      => $new_set_id,
                saved   => 1,
            },
        );
    }
}

1;
