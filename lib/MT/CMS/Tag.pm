# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Tag;

use strict;
use warnings;

use MT::ObjectTag;
use MT::Tag;

sub rename_tag {
    my $app = shift;
    $app->validate_magic or return;

    my $blog_id;
    $blog_id = $app->blog->id if $app->blog;
    $app->can_do('rename_tag')
        or return $app->permission_denied();
    my $id   = $app->param('__id');
    my $name = $app->param('tag_name')
        or return $app->error(
        $app->translate("A new name for the tag must be specified.") );
    my $obj_type  = $app->param('__type');
    my $tag_class = $app->model('tag');
    my $ot_class  = $app->model('objecttag');
    my $tag       = $tag_class->load($id)
        or return $app->error( $app->translate("No such tag") );
    my $tag2
        = $tag_class->load( { name => $name }, { binary => { name => 1 } } );

    if ($obj_type) {
        my $obj_class = $app->model($obj_type);
        if ($tag2) {
            return $app->call_return if $tag->id == $tag2->id;
        }
        my $terms = { tag_id => $tag->id };
        if ($blog_id) {
            my $blog = $app->model('blog')->load($blog_id);
            if ( $blog->is_blog ) {
                $terms->{blog_id} = $blog_id if $blog_id;
            }
            else {
                my @blog_ids = map { $_->id } @{ $blog->blogs };
                $terms->{blog_id} = \@blog_ids;
            }
        }
        my $iter = $obj_class->load_iter(
            {   (   $obj_type =~ m/asset/i
                    ? ( class => '*' )
                    : ( class => $obj_type )
                )
            },
            { join => MT::ObjectTag->join_on( 'object_id', $terms ) }
        );
        my @tagged_objects;
        while ( my $o = $iter->() ) {
            $o->remove_tags( $tag->name );
            $o->add_tags($name);
            push @tagged_objects, $o;
        }
        $_->save foreach @tagged_objects;

    }
    elsif (
        !$tag2
        and (
            !$blog_id
            or not $ot_class->exist(
                { tag_id => $tag->id, blog_id => { not => $blog_id }, }
            )
        )
        )
    {
        $tag->name($name);
        $tag->save();
    }
    else {
        my @b_terms = ( $blog_id ? ( blog_id => $blog_id ) : () );
        my %already_tagged;
        if ( !$tag2 ) {
            $tag2 = $tag->clone();
            $tag2->name($name);
            $tag2->id(undef);
            $tag2->save();
        }
        else {
            %already_tagged
                = map { ( $_->object_id . '|' . $_->object_datasource, 1 ) }
                $ot_class->load( { @b_terms, tag_id => $tag2->id } );
        }

        my $iter = $ot_class->load_iter( { @b_terms, tag_id => $tag->id } );
        while ( my $ot = $iter->() ) {
            my $tag_sign = $ot->object_id . '|' . $ot->object_datasource;
            if ( exists $already_tagged{$tag_sign} ) {
                $ot->remove();
            }
            else {
                $ot->tag_id( $tag2->id );
                $ot->save;
            }
        }
        if ( not $blog_id or not $ot_class->exist( { tag_id => $tag->id } ) )
        {
            $tag->remove();
        }
    }

    if ($tag2) {
        $app->add_return_arg( merged => 1 );
    }
    else {
        $app->add_return_arg( renamed => 1 );
    }
    if ( $app->param('xhr') ) {
        return $app->forward(
            'filtered_list',
            {   messages => [
                    {   cls => 'success',
                        msg => MT->translate(
                            'The tag was successfully renamed',
                        )
                    }
                ],
            }
        );
    }
    $app->call_return;
}

sub js_tag_check {
    my $app = shift;

    return $app->json_error( $app->translate('Permission denied.') )
        unless $app->can_do('edit_tags');

    my $name      = $app->param('tag_name');
    my $blog_id   = $app->param('blog_id');
    my $type      = $app->param('_type') || 'entry';
    my $tag_class = $app->model('tag')
        or return $app->json_error( $app->translate("Invalid request.") );
    require MT::Tag;
    my $n8d = MT::Tag->normalize($name);
    return $app->json_result( { valid => 0 } )
        unless defined($n8d) && length($n8d);

    my $tag
        = $tag_class->load( { name => $name }, { binary => { name => 1 } } );
    my $class = $app->model($type)
        or $app->json_error( $app->translate("Invalid request.") );
    if ( $tag && $blog_id ) {
        my $ot_class = $app->model('objecttag');
        my $exist    = $ot_class->exist(
            {   object_datasource => $class->datasource,
                blog_id           => $blog_id,
                tag_id            => $tag->id
            }
        );
        undef $tag unless $exist;
    }
    return $app->json_result( { valid => 1, exists => $tag ? 1 : 0 } );
}

sub add_tags_to_entries {
    my $app = shift;
    $app->validate_magic or return;

    $app->validate_param({
        id                   => [qw/ID MULTI/],
        itemset_action_input => [qw/MAYBE_STRING/],
        xhr                  => [qw/MAYBE_STRING/],
    }) or return;

    my $xhr = $app->param('xhr');
    my @id  = $app->multi_param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $xhr ? undef : $app->call_return unless @tags;

    require MT::Entry;

    my $user        = $app->user;
    my $entry_count = 0;
    foreach my $id (@id) {
        next unless $id;
        my $entry = MT::Entry->load($id) or next;
        my $perms = $app->user->permissions( $entry->blog_id );
        return $app->permission_denied()
            unless $entry && $perms->can_edit_entry( $entry, $user );

        $entry_count++;
        $entry->add_tags(@tags);
        $entry->modified_by( $user->id );
        $entry->save
            or return $app->trans_error( "Error saving entry: [_1]",
            $entry->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    return $xhr
        ? {
        messages => [
            {   cls => 'success',
                msg => MT->translate(
                    'Successfully added [_1] tags for [_2] entries.',
                    scalar @tags, $entry_count,
                )
            }
        ]
        }
        : $app->call_return;
}

sub remove_tags_from_entries {
    my $app = shift;
    $app->validate_magic or return;

    $app->validate_param({
        id                   => [qw/ID MULTI/],
        itemset_action_input => [qw/MAYBE_STRING/],
    }) or return;

    my @id = $app->multi_param('id');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Entry;

    my $user = $app->user;
    foreach my $id (@id) {
        next unless $id;
        my $entry = MT::Entry->load($id) or next;
        my $perms = $app->user->permissions( $entry->blog_id );
        return $app->permission_denied()
            unless $entry && $perms->can_edit_entry( $entry, $user );
        $entry->remove_tags(@tags);
        $entry->modified_by( $user->id );
        $entry->save
            or return $app->trans_error( "Error saving entry: [_1]",
            $entry->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub add_tags_to_assets {
    my $app = shift;
    $app->validate_magic or return;

    $app->validate_param({
        blog_id              => [qw/ID/],
        id                   => [qw/ID MULTI/],
        itemset_action_input => [qw/MAYBE_STRING/],
    }) or return;

    my @id      = $app->multi_param('id');
    my $blog_id = $app->param('blog_id');
    return $app->call_return
        if $blog_id and !$app->can_do('add_tags_to_assets');
    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Asset;
    my %approved_blogs;
    foreach my $id (@id) {
        next unless $id;
        my $asset = MT::Asset->load($id) or next;
        if ($blog_id) {
            next unless $asset->blog_id == $blog_id;
        }
        elsif ( $asset->blog_id ) {
            if ( not $approved_blogs{ $asset->blog_id } ) {
                next
                    unless $app->user->can_do(
                    'add_tags_to_assets',
                    blog_id      => $asset->blog_id,
                    at_least_one => 1
                    );
                $approved_blogs{ $asset->blog_id } = 1;
            }
        }
        else {
            next unless $app->user->is_superuser;
        }
        $asset->add_tags(@tags);
        $asset->modified_by( $app->user->id );
        $asset->save
            or return $app->trans_error( "Error saving file: [_1]",
            $asset->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub remove_tags_from_assets {
    my $app = shift;
    $app->validate_magic or return;

    $app->validate_param({
        blog_id              => [qw/ID/],
        id                   => [qw/ID MULTI/],
        itemset_action_input => [qw/MAYBE_STRING/],
    }) or return;

    my @id      = $app->multi_param('id');
    my $blog_id = $app->param('blog_id');
    return $app->call_return
        if $blog_id and !$app->can_do('remove_tags_from_assets');

    require MT::Tag;
    my $tags      = $app->param('itemset_action_input');
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tags      = MT::Tag->split( $tag_delim, $tags );
    return $app->call_return unless @tags;

    require MT::Asset;
    my %approved_blogs;
    foreach my $id (@id) {
        next unless $id;
        my $asset = MT::Asset->load($id) or next;
        if ($blog_id) {
            next unless $asset->blog_id == $blog_id;
        }
        elsif ( $asset->blog_id ) {
            if ( not $approved_blogs{ $asset->blog_id } ) {
                next
                    unless $app->user->can_do(
                    'remove_tags_from_assets',
                    blog_id      => $asset->blog_id,
                    at_least_one => 1
                    );
                $approved_blogs{ $asset->blog_id } = 1;
            }
        }
        else {
            next unless $app->user->is_superuser;
        }
        $asset->remove_tags(@tags);
        $asset->modified_by( $app->user->id );
        $asset->save
            or return $app->trans_error( "Error saving file: [_1]",
            $asset->errstr );
    }

    $app->add_return_arg( 'saved' => 1 );
    $app->call_return;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    return $author->permissions( $app->blog->id )->can_do('remove_tag');
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Tag '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'tag',
            category => 'delete'
        }
    );
}

sub build_tag_table {
    my $app = shift;
    my (%args) = @_;

    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('tag');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { shift @{ $args{items} } };
    }
    return [] unless $iter;

    my $param    = $args{param} || {};
    my $blog_id  = $app->param('blog_id');
    my $pkg      = $args{'package'};
    my $blog_ids = $app->_load_child_blog_ids($blog_id);
    push @$blog_ids, $blog_id;

    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );

    my @data;
    while ( my $tag = $iter->() ) {
        my $count = $pkg->tagged_count(
            $tag->id,
            {   ( $blog_ids         ? ( blog_id => $blog_ids ) : () ),
                ( $pkg =~ m/asset/i ? ( class   => '*' )       : () )
            }
        );
        $count ||= 0;
        my $name = $tag->name;
        if ( $name =~ m/$tag_delim/ ) {
            $name = '"' . $name . '"';
        }
        my $row = {
            tag_id    => $tag->id,
            tag_name  => $name,
            tag_count => $count,
            object    => $tag,
        };
        push @data, $row;
    }
    return [] unless @data;

    $param->{tag_table}[0]{object_loop} = \@data;
    $app->load_list_actions( 'tag', $param->{tag_table}[0] );
    $param->{object_loop} = $param->{tag_table}[0]{object_loop};
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $user = $app->user;

    my $blog_id = $load_options->{blog_id};
    my $terms   = $load_options->{terms};
    delete $terms->{blog_id}
        if exists $terms->{blog_id};
    my $args = $load_options->{args};
    $args->{joins} ||= [];

    push @{ $args->{joins} },
        MT->model('objecttag')
        ->join_on( 'tag_id', { blog_id => $blog_id }, { unique => 1 }, );
}

sub js_add_tag {
    my $app = shift;
    unless ( $app->validate_magic ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;

    my $label = $app->param('label');
    if ( !defined($label) || ( $label =~ m/^\s*$/ ) ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $blog = $app->blog;
    if ( !$blog ) {
        return $app->json_error( $app->translate("Invalid request.") );
    }

    my $obj
        = MT::Tag->load( { name => $label }, { binary => { name => 1 } } );
    if ($obj) {
        return $app->json_result(
            {   id       => $obj->id,
                basename => $obj->name,
            }
        );
    }

    $obj = MT::Tag->new;
    my $original = $obj->clone;

    $obj->name($label);

    if (!$app->run_callbacks( 'cms_save_permission_filter.tag', $app, $obj ) )
    {
        return $app->json_error( $app->translate("Permission denied.") );
    }

    if ( !$app->run_callbacks( 'cms_pre_save.tag', $app, $obj, $original ) ) {
        return $app->json_error( $app->errstr );
    }

    $obj->save;

    $app->run_callbacks( 'cms_post_save.tag', $app, $obj, $original );

    return $app->json_result(
        {   id       => $obj->id,
            basename => $obj->name,
        }
    );
}

1;
