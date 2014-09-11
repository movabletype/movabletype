# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Asset;

use strict;
use Symbol;
use MT::Util
    qw( epoch2ts encode_url format_ts relative_date perl_sha1_digest_hex);

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;
    my $user  = $app->user;
    my $perms = $app->permissions;
    if ($id) {
        my $asset_class = $app->model('asset');
        $param->{asset}        = $obj;
        $param->{search_label} = $app->translate('Assets');

        my $hasher = build_asset_hasher($app);
        $hasher->( $obj, $param, ThumbWidth => 240, ThumbHeight => 240 );

        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        require MT::Tag;
        my $tags = MT::Tag->join( $tag_delim, $obj->tags );
        $param->{tags} = $tags;

        if ($tag_delim) {
            if ( $tag_delim eq ',' ) {
                $param->{'auth_pref_tag_delim_comma'} = 1;
            }
            elsif ( $tag_delim eq ' ' ) {
                $param->{'auth_pref_tag_delim_space'} = 1;
            }
            else {
                $param->{'auth_pref_tag_delim_other'} = 1;
            }
            $param->{'auth_pref_tag_delim'} = $tag_delim;
        }
        require MT::ObjectTag;
        my $tags_js = MT::Util::to_json(
            [   map { $_->name } MT::Tag->load(
                    undef,
                    {   join => [
                            'MT::ObjectTag', 'tag_id',
                            { blog_id => $obj->blog_id }, { unique => 1 }
                        ]
                    }
                )
            ]
        );
        $tags_js =~ s!/!\\/!g;
        $param->{tags_js} = $tags_js;

        my @related;
        if ( $obj->parent ) {
            my $parent = $asset_class->load( $obj->parent );
            push @related,
                $hasher->( $parent, { asset => $parent, is_parent => 1 } );

            push @related,
                map { $hasher->( $_, { asset => $_, is_sibling => 1 } ) }
                $asset_class->search(
                {   id     => { op => '!=', value => $obj->id },
                    class  => '*',
                    parent => $obj->parent
                }
                );
        }
        push @related,
            map { $hasher->( $_, { asset => $_, is_child => 1 } ) }
            $asset_class->search(
            {   class  => '*',
                parent => $obj->id,
            }
            );
        $param->{related} = \@related if @related;

        my @appears_in;
        my $appears_in_uneditables = 0;
        my $place_class            = $app->model('objectasset');
        my $place_iter             = $place_class->load_iter(
            {   blog_id => $obj->blog_id || 0,
                asset_id => $obj->parent ? $obj->parent : $obj->id
            }
        );
        while ( my $place = $place_iter->() ) {
            my $entry_class = $app->model( $place->object_ds ) or next;
            next unless $entry_class->isa('MT::Entry');
            my $entry = $entry_class->load( $place->object_id )
                or next;
            if ( !$perms->can_edit_entry( $entry, $user ) ) {
                $appears_in_uneditables++;
                next;
            }
            my %entry_data = (
                id    => $place->object_id,
                class => $entry->class_type,
                entry => $entry,
                title => $entry->title,
            );
            if ( my $ts = $entry->authored_on ) {
                $entry_data{authored_on_ts} = $ts;
                $entry_data{authored_on_formatted}
                    = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
            if ( my $ts = $entry->created_on ) {
                $entry_data{created_on_ts} = $ts;
                $entry_data{created_on_formatted}
                    = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                    $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
            push @appears_in, \%entry_data;
        }
        $param->{appears_in}             = \@appears_in if @appears_in;
        $param->{appears_in_uneditables} = $appears_in_uneditables;
        $param->{show_appears_in_widget} = scalar @appears_in
            || $appears_in_uneditables;
        my $prev_asset = $obj->nextprev(
            direction => 'previous',
            terms     => { class => '*', blog_id => $obj->blog_id },
        );
        my $next_asset = $obj->nextprev(
            direction => 'next',
            terms     => { class => '*', blog_id => $obj->blog_id },
        );
        $param->{previous_entry_id} = $prev_asset->id if $prev_asset;
        $param->{next_entry_id}     = $next_asset->id if $next_asset;

        my $user = MT::Author->load(
            {   id   => $obj->created_by(),
                type => MT::Author::AUTHOR()
            }
        );
        if ($user) {
            $param->{created_by} = $user->name;
        }
        else {
            $param->{created_by} = $app->translate('(user deleted)');
        }
        if ( $obj->modified_by() ) {
            $user = MT::Author->load(
                {   id   => $obj->modified_by(),
                    type => MT::Author::AUTHOR()
                }
            );
            if ($user) {
                $param->{modified_by} = $user->name;
            }
            else {
                $param->{modified_by} = $app->translate('(user deleted)');
            }
        }
    }
    1;
}

sub dialog_list_asset {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $mode_userpic = $app->param('upload_mode') || '';
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog_id && $mode_userpic ne 'upload_userpic';

    my $blog_class = $app->model('blog');
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;

    if (   $app->param('edit_field')
        && $app->param('edit_field') =~ m/^customfield_.*$/ )
    {
        return $app->permission_denied()
            unless $app->permissions;
    }
    else {
        return $app->permission_denied()
            if $blog_id && !$app->can_do('access_to_insert_asset_list');
    }

    my $asset_class = $app->model('asset') or return;
    my %terms;
    my %args = ( sort => 'created_on', direction => 'descend' );

    my $class_filter;
    my $filter = ( $app->param('filter') || '' );
    if ( $filter eq 'class' ) {
        $class_filter = $app->param('filter_val');
    }
    elsif ( $filter eq 'userpic' ) {
        $class_filter      = 'image';
        $terms{created_by} = $app->param('filter_val');
        $terms{blog_id}    = 0;

        my $tag = MT::Tag->load( { name => '@userpic' },
            { binary => { name => 1 } } );
        if ($tag) {
            require MT::ObjectTag;
            $args{'join'} = MT::ObjectTag->join_on(
                'object_id',
                {   tag_id            => $tag->id,
                    object_datasource => MT::Asset->datasource
                },
                { unique => 1 }
            );
        }
    }

    $app->add_breadcrumb( $app->translate("Files") );

    if ($blog_id) {
        my $blog_ids = $app->_load_child_blog_ids($blog_id);
        push @$blog_ids, $blog_id;
        $terms{blog_id} = $blog_ids;
    }

    my $hasher = build_asset_hasher(
        $app,
        PreviewWidth  => 120,
        PreviewHeight => 120
    );

    if ($class_filter) {
        my $asset_pkg = MT::Asset->class_handler($class_filter);
        $terms{class} = $asset_pkg->type_list;
    }
    else {
        $terms{class} = '*';    # all classes
    }

    # identifier => name
    my $classes = MT::Asset->class_labels;
    my @class_loop;
    foreach my $class ( keys %$classes ) {
        next if $class eq 'asset';
        push @class_loop,
            {
            class_id    => $class,
            class_label => $classes->{$class},
            };
    }

    # Now, sort it
    @class_loop
        = sort { $a->{class_label} cmp $b->{class_label} } @class_loop;

    my $dialog    = $app->param('dialog')    ? 1 : 0;
    my $no_insert = $app->param('no_insert') ? 1 : 0;
    my %carry_params = map { $_ => $app->param($_) || '' }
        (qw( edit_field upload_mode require_type next_mode asset_select ));
    $carry_params{'user_id'} = $app->param('filter_val')
        if $filter eq 'userpic';
    _set_start_upload_params( $app, \%carry_params )
        if $app->can_do('upload');
    my ( $ext_from, $ext_to )
        = ( $app->param('ext_from'), $app->param('ext_to') );

    # Check directory for thumbnail image
    _check_thumbnail_dir( $app, \%carry_params );

    $app->listing(
        {   terms    => \%terms,
            args     => \%args,
            type     => 'asset',
            code     => $hasher,
            template => 'dialog/asset_list.tmpl',
            params   => {
                (   $blog
                    ? ( blog_id      => $blog_id,
                        blog_name    => $blog->name || '',
                        edit_blog_id => $blog_id,
                        ( $blog->is_blog ? ( blog_view => 1 ) : () ),
                        )
                    : (),
                ),
                is_image => defined $class_filter
                    && $class_filter eq 'image' ? 1 : 0,
                dialog_view      => 1,
                dialog           => $dialog,
                no_insert        => $no_insert,
                search_label     => MT::Asset->class_label_plural,
                search_type      => 'asset',
                class_loop       => \@class_loop,
                can_delete_files => $app->can_do('delete_asset_file') ? 1 : 0,
                nav_assets       => 1,
                panel_searchable => 1,
                saved_deleted    => $app->param('saved_deleted') ? 1 : 0,
                object_type      => 'asset',
                (     ( $ext_from && $ext_to )
                    ? ( ext_from => $ext_from, ext_to => $ext_to )
                    : ()
                ),
                %carry_params,
            },
        }
    );
}

sub insert {
    my $app = shift;

    $app->validate_magic() or return;

    if (   $app->param('edit_field')
        && $app->param('edit_field') =~ m/^customfield_.*$/ )
    {
        return $app->permission_denied()
            unless $app->permissions;
    }
    else {
        return $app->permission_denied()
            unless $app->can_do('insert_asset');
    }

    my $text = $app->param('no_insert') ? "" : _process_post_upload($app);
    return unless defined $text;
    my $file_ext_changes = $app->param('changed_file_ext');
    my ( $ext_from, $ext_to ) = split( ",", $file_ext_changes )
        if $file_ext_changes;
    my $extension_message
        = $app->translate( "Extension changed from [_1] to [_2]",
        $ext_from, $ext_to )
        if ( $ext_from && $ext_to );
    my $tmpl;

    my $id = $app->param('id') or return $app->errtrans("Invalid request.");
    my $asset = MT::Asset->load($id);
    if ($extension_message) {
        $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {   upload_html => $text || '',
                edit_field => scalar $app->param('edit_field') || '',
                extension_message => $extension_message,
                asset_type => $asset->class,
            },
        );
    }
    else {
        $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {   upload_html => $text || '',
                edit_field => scalar $app->param('edit_field') || '',
                asset_type => $asset->class,
            },
        );
    }
    my $ctx = $tmpl->context;
    $ctx->stash( 'asset', $asset );
    return $tmpl;
}

sub asset_userpic {
    my $app = shift;
    my ($param) = @_;

    $app->validate_magic() or return;

    my ( $id, $asset );
    if ( $asset = $param->{asset} ) {
        $id = $asset->id;
    }
    else {
        $id = $param->{asset_id} || scalar $app->param('id');
        $asset = $app->model('asset')->lookup($id);
    }

    my $user_id = $param->{user_id} || $app->param('user_id');
    my $user;
    if ($user_id) {
        $user = $app->model('author')->load( { id => $user_id } );
        if ($user) {

            my $appuser = $app->user;
            if (   ( !$appuser->is_superuser )
                && ( $user->id != $appuser->id ) )
            {
                return $app->permission_denied();
            }

           # Delete the author's userpic thumb (if any); it'll be regenerated.
            if ( $user->userpic_asset_id != $asset->id ) {
                my $old_file = $user->userpic_file();
                my $fmgr     = MT::FileMgr->new('Local');
                if ( $fmgr->exists($old_file) ) {
                    $fmgr->delete($old_file);
                }
                $user->userpic_asset_id( $asset->id );
                return $app->error(
                    $app->translate(
                        "Failed to create thumbnail file because [_1] could not handle this image type.",
                        MT->config('ImageDriver')
                    )
                    )
                    unless $asset->has_thumbnail
                    && $asset->can_create_thumbnail;
                $user->save;
            }
        }
    }

    my $thumb_html
        = $user
        ? $user->userpic_html( Asset => $asset )
        : $app->model('author')->userpic_html( Asset => $asset );

    $app->load_tmpl(
        'dialog/asset_userpic.tmpl',
        {   asset_id       => $id,
            edit_field     => $app->param('edit_field') || '',
            author_userpic => $thumb_html,
        },
    );
}

sub start_upload {
    my $app = shift;
    my $dialog
        = defined( $app->param('dialog') ) ? $app->param('dialog') : '';
    $dialog =~ s/\D//g;
    return $app->return_to_dashboard( redirect => 1 )
        if !$app->blog && !$dialog;

    $app->add_breadcrumb( $app->translate('Upload File') );
    my %param;
    %param = @_ if @_;

    _set_start_upload_params( $app, \%param );

    for my $field (
        qw( entry_insert edit_field upload_mode require_type
        asset_select )
        )
    {
        $param{$field} ||= $app->param($field);
    }

    if ( $app->param('uploaded') ) {
        $param{uploaded}          = 1;
        $param{uploaded_filename} = $app->param('uploaded_filename');
    }

    $param{search_label} = $app->translate('Assets');
    $param{search_type}  = 'asset';

    # Check directory for thumbnail image
    _check_thumbnail_dir( $app, \%param );

    $param{dialog} = $dialog;
    my $tmpl_file
        = $dialog ? 'dialog/asset_upload.tmpl' : 'asset_upload.tmpl';
    $app->load_tmpl( $tmpl_file, \%param );
}

sub upload_file {
    my $app = shift;

    if ( my $perms = $app->permissions ) {
        return $app->error( $app->translate("Permission denied.") )
            unless $perms->can_do('upload');
    }
    else {
        return $app->error( $app->translate("Permission denied.") );
    }

    $app->validate_magic() or return;

    my ( $asset, $bytes ) = _upload_file(
        $app,
        require_type => ( $app->param('require_type') || '' ),
        @_,
    );
    return if !defined $asset;
    return $asset if !defined $bytes;    # whatever it is
    complete_insert(
        $app,
        asset => $asset,
        bytes => $bytes,
    );
}

sub complete_insert {
    my $app    = shift;
    my (%args) = @_;
    my $asset  = $args{asset};

    $app->validate_magic() or return;

    if ( !$asset && $app->param('id') ) {
        require MT::Asset;
        $asset = MT::Asset->load( $app->param('id') )
            || return $app->errtrans( "Cannot load file #[_1].",
            $app->param('id') );
    }
    return $app->errtrans('Invalid request.') unless $asset;

    $args{is_image} = $asset->isa('MT::Asset::Image') ? 1 : 0
        unless defined $args{is_image};

    require MT::Blog;
    my $blog = $asset->blog
        or return $app->errtrans( "Cannot load blog #[_1].",
        $app->param('blog_id') );
    my $perms = $app->permissions
        or return $app->errtrans('No permissions');

    # caller wants asset without any option step, so insert immediately
    if ( $app->param('asset_select') || $app->param('no_insert') ) {
        $app->param( 'id', $asset->id );
        return insert($app);
    }

    my $param = {
        asset_id    => $asset->id,
        bytes       => $args{bytes},
        fname       => $asset->file_name,
        is_image    => $args{is_image} || 0,
        url         => $asset->url,
        middle_path => scalar( $app->param('middle_path') ) || '',
        extra_path  => scalar( $app->param('extra_path') ) || '',
    };
    for my $field (
        qw( direct_asset_insert edit_field entry_insert site_path
        asset_select )
        )
    {
        $param->{$field} = scalar $app->param($field) || '';
    }
    if ( $args{is_image} ) {
        $param->{width}  = $asset->image_width;
        $param->{height} = $asset->image_height;
    }
    my ( $extension_message, $ext_from, $ext_to );
    if ( $app->param('changed_file_ext') ) {
        ( $ext_from, $ext_to )
            = split( ",", $app->param('changed_file_ext') );
        $extension_message
            = $app->translate( "Extension changed from [_1] to [_2]",
            $ext_from, $ext_to )
            if ( $ext_from && $ext_to );
        $param->{extension_message} = $extension_message;
        $param->{ext_from}          = $ext_from;
        $param->{ext_to}            = $ext_to;
    }
    if ( !$app->param('asset_select')
        && ( $perms->can_do('insert_asset') ) )
    {
        my $html = $asset->insert_options($param);
        if ( $app->param('force_insert')
            || ( $param->{direct_asset_insert} && !$html ) )
        {
            $app->param( 'id', $asset->id );
            return insert($app);
        }
        $param->{options_snippet} = $html;
    }
    if ($perms) {
        my $pref_param = $app->load_entry_prefs(
            { type => 'entry', prefs => $perms->entry_prefs } );
        %$param = ( %$param, %$pref_param );

        # Completion for tags
        my $author     = $app->user;
        my $auth_prefs = $author->entry_prefs;
        if ( my $delim = chr( $auth_prefs->{tag_delim} ) ) {
            if ( $delim eq ',' ) {
                $param->{'auth_pref_tag_delim_comma'} = 1;
            }
            elsif ( $delim eq ' ' ) {
                $param->{'auth_pref_tag_delim_space'} = 1;
            }
            else {
                $param->{'auth_pref_tag_delim_other'} = 1;
            }
            $param->{'auth_pref_tag_delim'} = $delim;
        }

        require MT::ObjectTag;
        my $q       = $app->param;
        my $blog_id = $q->param('blog_id');
        my $tags_js = MT::Util::to_json(
            [   map { $_->name } MT::Tag->load(
                    undef,
                    {   join => [
                            'MT::ObjectTag', 'tag_id',
                            { blog_id => $blog_id }, { unique => 1 }
                        ]
                    }
                )
            ]
        );
        $tags_js =~ s!/!\\/!g;
        $param->{tags_js} = $tags_js;
    }

    $param->{'no_insert'} = $app->param('no_insert');
    if ( $app->param('dialog') ) {
        $app->load_tmpl( 'dialog/asset_options.tmpl', $param );
    }
    else {
        if ( $app->user->can_do('access_to_asset_list') ) {
            my $redirect_args = {
                blog_id => $app->param('blog_id'),
                (     ( $ext_from && $ext_to )
                    ? ( ext_from => $ext_from, ext_to => $ext_to )
                    : ()
                ),
                _type => 'asset',
            };
            $app->redirect(
                $app->uri(
                    'mode' => 'list',
                    args   => $redirect_args,
                )
            );
        }
        else {
            $app->redirect(
                $app->uri(
                    'mode' => 'start_upload',
                    args   => {
                        blog_id           => $app->param('blog_id'),
                        uploaded          => 1,
                        uploaded_filename => $asset->file_name,
                    },
                )
            );
        }
    }
}

sub cancel_upload {
    # Delete uploaded asset after upload if user cancels on asset options page
    my $app   = shift;
    my %param = $app->param_hash;

    $app->validate_magic() or return;

    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
      or return $app->errtrans("Invalid request.");

    # User has permission to delete asset and asset file, or user created asset
    if ( ( $app->can_do('delete_asset') && $app->can_do('delete_asset_file') )
         || $asset->created_by == $app->user->id )
    {
        # Do not delete asset if asset has been modified since initial upload
        if ($asset->modified_on == $asset->created_on ) {
    
            # Label, description, & tags params exist on asset options
            #   page if we were editing newly upload asset
            if (    exists( $param{label} )
                 && exists( $param{description} )
                 && exists( $param{tags} ) )
            {
                # Count MT::ObjectAsset records for asset
                # Do not delete asset if asset has any associations
                my $oa_class = MT->model('objectasset');
                my $oa_count = $oa_class->count( { asset_id => $asset->id } );
                $asset->remove unless $oa_count;
            }
        }
    }
}

sub complete_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
        or return $app->errtrans("Invalid request.");

    if ( $app->can('edit_assets') || $asset->created_by == $app->user->id ) {
        $asset->label( $param{label} )             if $param{label};
        $asset->description( $param{description} ) if $param{description};
        if ( $param{tags} ) {
            require MT::Tag;
            my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
            my @tags = MT::Tag->split( $tag_delim, $param{tags} );
            $asset->set_tags(@tags);
        }
        $asset->save();
    }

    $asset->on_upload( \%param );

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $app->can_do('access_to_asset_list');

    return $app->redirect(
        $app->uri(
            'mode' => 'list',
            args =>
                { '_type' => 'asset', 'blog_id' => $app->param('blog_id') }
        )
    );
}

sub start_upload_entry {
    my $app = shift;

    $app->validate_magic() or return;

    my $q    = $app->param;
    my $blog = $app->blog;
    my $type = 'entry';
    $type = 'page'
        if ( $blog && !$blog->is_blog() );
    $q->param( '_type', $type );
    defined( my $text = _process_post_upload($app) ) or return;
    $q->param( 'text',     $text );
    $q->param( 'asset_id', $q->param('id') );
    $q->param( 'id',       0 );
    $app->param( 'tags', '' );
    $app->forward("view");
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('open_asset_edit_screen');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    if ( $obj->blog_id ) {
        return $app->user->permissions( $obj->blog_id )
            ->can_do('delete_asset');
    }
    else {
        return $app->can_do('delete_asset');
    }
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('asset')->load($obj);
    }
    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    return $author->permissions($blog_id)->can_do('save_asset');
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog = $app->blog;
        my $fields
            = $blog
            ? $blog->smart_replace_fields
            : MT->config->NwcReplaceField;
        if ( $fields && $fields =~ m/tags/ig ) {
            $tags = MT::App::CMS::_convert_word_chars( $app, $tags );
        }

        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        if (@tags) {
            $obj->set_tags(@tags);
        }
        else {
            $obj->remove_tags();
        }
    }
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {   message => $app->translate(
                    "File '[_1]' uploaded by '[_2]'", $obj->file_name,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'asset',
                category => 'new',
            }
        );
    }
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "File '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->file_name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'asset',
            category => 'delete'
        }
    );
}

sub template_param_edit {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $asset = $param->{asset} or return;
    $asset->edit_template_param(@_);
}

sub build_asset_hasher {
    my $app = shift;
    my (%param) = @_;
    my ($default_thumb_width,   $default_thumb_height,
        $default_preview_width, $default_preview_height
    ) = @param{qw( ThumbWidth ThumbHeight PreviewWidth PreviewHeight )};

    require File::Basename;
    require JSON;
    my %blogs;
    return sub {
        my ( $obj, $row, %param ) = @_;
        my ( $thumb_width, $thumb_height )
            = @param{qw( ThumbWidth ThumbHeight )};
        $row->{id} = $obj->id;
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        $row->{blog_name} = $blog ? $blog->name : '-';
        $row->{url} = $obj->url;    # this has to be called to calculate
        $row->{asset_type}        = $obj->class_type;
        $row->{asset_class_label} = $obj->class_label;
        my $file_path = $obj->file_path;    # has to be called to calculate
        my $meta      = $obj->metadata;

        require MT::FileMgr;
        my $fmgr = MT::FileMgr->new('Local');
        ## TBD: Make sure $file_path is file, not directory.
        if ( $file_path && $fmgr->file_size($file_path) ) {
            $row->{file_path} = $file_path;
            $row->{file_name} = File::Basename::basename($file_path);
            my $size = $fmgr->file_size($file_path);
            $row->{file_size} = $size;
            if ( $size < 1024 ) {
                $row->{file_size_formatted} = sprintf( "%d Bytes", $size );
            }
            elsif ( $size < 1024000 ) {
                $row->{file_size_formatted}
                    = sprintf( "%.1f KB", $size / 1024 );
            }
            else {
                $row->{file_size_formatted}
                    = sprintf( "%.1f MB", $size / 1024000 );
            }
            $meta->{'file_size'} = $row->{file_size_formatted};
        }
        else {
            $row->{file_is_missing} = 1 if $file_path;
        }
        $meta->{file_name} = MT::Util::encode_html( $row->{file_name} );
        $row->{file_label}
            = $row->{label}
            = $obj->label
            || $row->{file_name}
            || $app->translate('Untitled');

        if ( $obj->has_thumbnail && $obj->can_create_thumbnail ) {
            $row->{has_thumbnail} = 1;
            my $height = $thumb_height || $default_thumb_height || 45;
            my $width  = $thumb_width  || $default_thumb_width  || 45;
            my $square = $height == 45 && $width == 45;
            @$meta{qw( thumbnail_url thumbnail_width thumbnail_height )}
                = $obj->thumbnail_url(
                Height => $height,
                Width  => $width,
                Square => $square
                );

            $meta->{thumbnail_width_offset}
                = int( ( $width - $meta->{thumbnail_width} ) / 2 );
            $meta->{thumbnail_height_offset}
                = int( ( $height - $meta->{thumbnail_height} ) / 2 );

            if ( $default_preview_width && $default_preview_height ) {
                @$meta{qw( preview_url preview_width preview_height )}
                    = $obj->thumbnail_url(
                    Height => $default_preview_height,
                    Width  => $default_preview_width,
                    );
                $meta->{preview_width_offset} = int(
                    ( $default_preview_width - $meta->{preview_width} ) / 2 );
                $meta->{preview_height_offset}
                    = int(
                    ( $default_preview_height - $meta->{preview_height} )
                    / 2 );
            }
        }
        else {
            $row->{has_thumbnail} = 0;
        }

        my $ts = $obj->created_on;
        if ( my $by = $obj->created_by ) {
            my $user = MT::Author->load($by);
            $row->{created_by}
                = $user ? $user->name : $app->translate('(user deleted)');
        }
        if ($ts) {
            $row->{created_on_formatted}
                = format_ts( MT::App::CMS::LISTING_DATE_FORMAT(),
                $ts, $blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted}
                = format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(),
                $ts, $blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }

        @$row{ keys %$meta } = values %$meta;
        $row->{metadata_json} = MT::Util::to_json($meta);
        $row;
    };
}

sub build_asset_table {
    my $app = shift;
    my (%args) = @_;

    my $asset_class = $app->model('asset') or return;
    my $perms       = $app->permissions;
    my $list_pref   = $app->list_pref('asset');
    my $limit       = $args{limit};
    my $param       = $args{param} || {};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('asset');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
        $limit = scalar @{ $args{items} };
    }
    return [] unless $iter;

    my @data;
    my $hasher = build_asset_hasher($app);
    while ( my $obj = $iter->() ) {
        my $row = $obj->get_values;
        $hasher->( $obj, $row );
        $row->{object} = $obj;
        push @data, $row;
        last if $limit and @data > $limit;
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'asset';
    $app->load_list_actions( 'asset', $param );
    $param->{object_loop}      = \@data;
    $param->{can_delete_files} = 1
        if $app->can_do('delete_asset_file');
    \@data;
}

sub asset_insert_text {
    my $app     = shift;
    my ($param) = @_;
    my $q       = $app->param;
    my $id      = $app->param('id')
        or return $app->errtrans("Invalid request.");
    require MT::Asset;
    my $asset = MT::Asset->load($id)
        or return $app->errtrans( "Cannot load file #[_1].", $id );
    $param->{enclose} = $app->param('edit_field') =~ /^customfield/ ? 1 : 0;
    return $asset->as_html($param);
}

sub _process_post_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
        or return $app->errtrans("Invalid request.");

    if ( $app->can('edit_assets') || $asset->created_by == $app->user->id ) {
        $asset->label( $param{label} )             if $param{label};
        $asset->description( $param{description} ) if $param{description};
        if ( $param{tags} ) {
            require MT::Tag;
            my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
            my @tags = MT::Tag->split( $tag_delim, $param{tags} );
            $asset->set_tags(@tags);
        }
        $asset->save();
    }

    $asset->on_upload( \%param );
    return asset_insert_text( $app, \%param );
}

sub cms_save_filter {
    my ( $cb, $app ) = @_;
    if ( $app->param('file_name') || $app->param('file_path') ) {
        return $app->errtrans("Invalid request.");
    }
    1;
}

sub _set_start_upload_params {
    my $app = shift;
    my ($param) = @_;

    if ( my $perms = $app->permissions ) {
        return $app->permission_denied()
            unless $perms->can_do('upload');

        my $blog_id = $app->param('blog_id');
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

        $param->{enable_archive_paths} = $blog->column('archive_path');
        $param->{local_site_path}      = $blog->site_path;
        $param->{local_archive_path}   = $blog->archive_path;
        my $label_path;
        if ( $param->{enable_archive_paths} ) {
            $label_path = $app->translate('Archive Root');
        }
        else {
            $label_path = $app->translate('Site Root');
        }
        my @extra_paths;
        my $date_stamp = epoch2ts( $blog, time );
        $date_stamp =~ s!^(\d\d\d\d)(\d\d)(\d\d).*!$1/$2/$3!;
        my $path_hash = {
            path  => $date_stamp,
            label => '<' . $label_path . '>' . '/' . $date_stamp,
        };

        if ( exists( $param->{middle_path} )
            && ( $date_stamp eq $param->{middle_path} ) )
        {
            $path_hash->{selected} = 1;
            delete $param->{archive_path};
        }
        push @extra_paths, $path_hash;
        $param->{extra_paths} = \@extra_paths;
        $param->{refocus}     = 1;
        $param->{missing_paths}
            = (    ( defined $blog->site_path || defined $blog->archive_path )
                && ( -d $blog->site_path || -d $blog->archive_path ) )
            ? 0
            : 1;

        if ( $param->{missing_paths} ) {
            if ($app->user->is_superuser
                || $app->run_callbacks(
                    'cms_view_permission_filter.blog',
                    $app, $blog_id, $blog
                )
                )
            {
                $param->{have_permissions} = 1;
            }
        }

        $param->{enable_destination} = 1;

        my $data = $app->_build_category_list(
            blog_id => $blog_id,
            markers => 1,
            type    => 'folder',
        );
        my $top_cat  = -1;
        my $cat_tree = [
            {   id       => -1,
                label    => '/',
                basename => '/',
                path     => [],
            }
        ];
        foreach (@$data) {
            next unless exists $_->{category_id};
            $_->{category_path_ids} ||= [];
            unshift @{ $_->{category_path_ids} }, -1;
            push @$cat_tree,
                {
                id       => $_->{category_id},
                label    => $_->{category_label} . '/',
                basename => $_->{category_basename} . '/',
                path     => $_->{category_path_ids} || [],
                };
        }
        $param->{category_tree} = $cat_tree;
    }
    else {
        $param->{local_site_path}    = '';
        $param->{local_archive_path} = '';
    }
    my $require_type
        = defined( $param->{require_type} ) ? $param->{require_type} : '';
    $require_type =~ s/\W//g;
    $param->{require_type} = $require_type;

    $param->{auto_rename_if_exists} = 0;
    $param->{normalize_orientation} = 0;

    $param;
}

sub _upload_file {
    my $app = shift;
    my (%upload_param) = @_;
    require MT::Image;

    my $app_id = $app->id;
    my $eh = $upload_param{error_handler} || sub {
        start_upload(@_);
    };
    my $exists_handler = $upload_param{exists_handler} || sub {
        my ( $app, %param ) = @_;
        return $app->load_tmpl(
            $app->param('dialog')
            ? 'dialog/asset_replace.tmpl'
            : 'asset_replace.tmpl',
            \%param
        );
    };
    my $q = $app->param;
    my ( $fh, $info ) = $app->upload_info('file');
    my $mimetype;
    if ($info) {
        $mimetype = $info->{'Content-Type'};
    }
    my $has_overwrite = $q->param('overwrite_yes')
        || $q->param('overwrite_no');
    my %param = (
        entry_insert => scalar( $q->param('entry_insert') ),
        middle_path  => scalar( $q->param('middle_path') ),
        edit_field   => scalar( $q->param('edit_field') ),
        site_path    => scalar( $q->param('site_path') ),
        extra_path   => scalar( $q->param('extra_path') ),
        upload_mode  => $app->mode,
    );
    return $eh->(
        $app, %param,
        error => $app->translate("Please select a file to upload.")
    ) if !$fh && !$has_overwrite;
    my $basename = $q->param('file') || $q->param('fname');
    $basename =~ s!\\!/!g;    ## Change backslashes to forward slashes
    $basename =~ s!^.*/!!;    ## Get rid of full directory paths
    if ( $basename =~ m!\.\.|\0|\|! ) {
        return $eh->(
            $app, %param,
            error => $app->translate( "Invalid filename '[_1]'", $basename )
        );
    }
    $basename
        = Encode::is_utf8($basename)
        ? $basename
        : Encode::decode( $app->charset,
        File::Basename::basename($basename) );

    if ( my $asset_type = $upload_param{require_type} ) {
        require MT::Asset;
        my $asset_pkg = MT::Asset->handler_for_file($basename);

        my %settings_for = (
            audio => {
                class => 'MT::Asset::Audio',
                error =>
                    $app->translate("Please select an audio file to upload."),
            },
            image => {
                class => 'MT::Asset::Image',
                error => $app->translate("Please select an image to upload."),
            },
            video => {
                class => 'MT::Asset::Video',
                error => $app->translate("Please select a video to upload."),
            },
        );

        if ( my $settings = $settings_for{$asset_type} ) {
            return $eh->( $app, %param, error => $settings->{error} )
                if !$asset_pkg->isa( $settings->{class} );
        }
    }

    my ($blog_id,        $blog,         $fmgr,
        $local_file,     $asset_file,   $base_url,
        $asset_base_url, $relative_url, $relative_path
    );
    if ( $blog_id = $q->param('blog_id') ) {
        unless ($has_overwrite) {
            if ( my $ext_new = lc( MT::Image->get_image_type($fh) ) ) {
                my $ext_old
                    = (
                    File::Basename::fileparse( $basename, qr/[A-Za-z0-9]+$/ )
                    )[2];
                if (   $ext_new ne lc($ext_old)
                    && !( lc($ext_old) eq 'jpeg' && $ext_new eq 'jpg' )
                    && !( lc($ext_old) eq 'swf'  && $ext_new eq 'cws' ) )
                {
                    $basename =~ s/$ext_old$/$ext_new/;
                    $app->param( "changed_file_ext", "$ext_old,$ext_new" );
                }
            }
        }

        $param{blog_id} = $blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
        $fmgr = $blog->file_mgr;

        ## Set up the full path to the local file; this path could start
        ## at either the Local Site Path or Local Archive Path, and could
        ## include an extra directory or two in the middle.
        my ( $root_path, $middle_path );
        if ( $q->param('site_path') ) {
            $root_path = $blog->site_path;
        }
        else {
            $root_path = $blog->archive_path;
        }
        return $app->error(
            $app->translate(
                'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.'
            )
        ) unless -d $root_path;
        $relative_path = $q->param('extra_path');
        $middle_path = $q->param('middle_path') || '';
        my $relative_path_save = $relative_path;
        if ( $middle_path ne '' ) {
            $relative_path = $middle_path
                . ( $relative_path ? '/' . $relative_path : '' );
        }

        {
            my $path_info = {};
            @$path_info{qw(rootPath relativePath basename)}
                = ( $root_path, $relative_path, $basename );

            if ( $q->param('auto_rename_if_exists') ) {
                _rename_if_exists( $app, $fmgr, $path_info );
            }

            $app->run_callbacks( $app_id . '_asset_upload_path',
                $app, $fmgr, $path_info );

            ( $root_path, $relative_path, $basename )
                = @$path_info{qw(rootPath relativePath basename)};
        }

        my $path = $root_path;
        if ($relative_path) {
            if ( $relative_path =~ m!\.\.|\0|\|! ) {
                return $eh->(
                    $app, %param,
                    error => $app->translate(
                        "Invalid extra path '[_1]'",
                        $relative_path
                    )
                );
            }
            $path = File::Spec->catdir( $path, $relative_path );
            ## Untaint. We already checked for security holes in $relative_path.
            ($path) = $path =~ /(.+)/s;
            ## Build out the directory structure if it doesn't exist. DirUmask
            ## determines the permissions of the new directories.
            unless ( $fmgr->exists($path) ) {
                $fmgr->mkpath($path)
                    or return $eh->(
                    $app, %param,
                    error => $app->translate(
                        "Cannot make path '[_1]': [_2]", $path,
                        $fmgr->errstr
                    )
                    );
            }
        }
        $relative_url
            = File::Spec->catfile( $relative_path, encode_url($basename) );
        $relative_path
            = $relative_path
            ? File::Spec->catfile( $relative_path, $basename )
            : $basename;
        $asset_file = $q->param('site_path') ? '%r' : '%a';
        $relative_path =~ s/^[\/\\]//;
        $asset_file = File::Spec->catfile( $asset_file, $relative_path );
        $local_file = File::Spec->catfile( $path,       $basename );
        $base_url
            = $app->param('site_path')
            ? $blog->site_url
            : $blog->archive_url;
        $asset_base_url = $app->param('site_path') ? '%r' : '%a';

        ## Untaint. We have already tested $basename and $relative_path for security
        ## issues above, and we have to assume that we can trust the user's
        ## Local Archive Path setting. So we should be safe.
        ($local_file) = $local_file =~ /(.+)/s;

        ## If $local_file already exists, we try to write the upload to a
        ## tempfile, then ask for confirmation of the upload.
        if ( $fmgr->exists($local_file) ) {
            if ($has_overwrite) {
                my $tmp = $q->param('temp');

                return $app->error(
                    $app->translate( "Invalid temp file name '[_1]'", $tmp ) )
                    unless _is_valid_tempfile_basename($tmp);

                my $tmp_dir = $app->config('TempDir');
                my $tmp_file = File::Spec->catfile( $tmp_dir, $tmp );
                if ( $q->param('overwrite_yes') ) {
                    $fh = gensym();
                    open $fh, '<',
                        $tmp_file
                        or return $app->error(
                        $app->translate(
                            "Error opening '[_1]': [_2]",
                            $tmp_file, "$!"
                        )
                        );
                }
                else {
                    if ( -e $tmp_file ) {
                        $fmgr->delete($tmp_file)
                            or return $app->error(
                            $app->translate(
                                "Error deleting '[_1]': [_2]", $tmp_file,
                                "$!"
                            )
                            );
                    }
                    return $eh->($app);
                }
            }
            else {
                eval { require File::Temp };
                if ($@) {
                    return $app->error(
                        $app->translate(
                            "File with name '[_1]' already exists. (Install "
                                . "the File::Temp Perl module if you would like "
                                . "to be able to overwrite existing uploaded files.)",
                            $basename
                        )
                    );
                }
                my $tmp_dir = $app->config('TempDir');
                my ( $tmp_fh, $tmp_file );
                eval {
                    ( $tmp_fh, $tmp_file )
                        = File::Temp::tempfile( DIR => $tmp_dir );
                };
                if ($@) {    #!$tmp_fh
                    return $app->errtrans(
                        "Error creating a temporary file; The webserver should be able "
                            . "to write to this folder.  Please check the TempDir "
                            . "setting in your configuration file, it is currently '[_1]'. ",
                        (     $tmp_dir
                            ? $tmp_dir
                            : '[' . $app->translate('unassigned') . ']'
                        )
                    );
                }
                defined( _write_upload( $fh, $tmp_fh ) )
                    or return $app->error(
                    $app->translate(
                        "File with name '[_1]' already exists; Tried to write "
                            . "to a tempfile, but the webserver could not open it: [_2]",
                        $basename,
                        "$!"
                    )
                    );
                close $tmp_fh;
                my ( $vol, $path, $tmp ) = File::Spec->splitpath($tmp_file);
                my ( $ext_from, $ext_to )
                    = split( ",", $app->param('changed_file_ext') );
                my $extension_message
                    = $app->translate( "Extension changed from [_1] to [_2]",
                    $ext_from, $ext_to )
                    if ( $ext_from && $ext_to );
                return $exists_handler->(
                    $app,
                    temp              => $tmp,
                    extra_path        => $relative_path_save,
                    site_path         => scalar $q->param('site_path'),
                    asset_select      => scalar $q->param('asset_select'),
                    entry_insert      => scalar $q->param('entry_insert'),
                    edit_field        => scalar $app->param('edit_field'),
                    middle_path       => $middle_path,
                    fname             => $basename,
                    no_insert         => $q->param('no_insert') || "",
                    extension_message => $extension_message,
                );
            }
        }
    }
    else {
        $blog_id        = 0;
        $asset_base_url = '%s/uploads';
        $base_url       = $app->support_directory_url . 'uploads';
        $param{support_path}
            = File::Spec->catdir( $app->support_directory_path, 'uploads' );

        require MT::FileMgr;
        $fmgr = MT::FileMgr->new('Local');
        unless ( $fmgr->exists( $param{support_path} ) ) {
            $fmgr->mkpath( $param{support_path} );
            unless ( $fmgr->exists( $param{support_path} ) ) {
                return $app->error(
                    $app->translate(
                        "Could not create upload path '[_1]': [_2]",
                        $param{support_path},
                        $fmgr->errstr
                    )
                );
            }
        }

        require File::Basename;
        my ( $stem, undef, $type )
            = File::Basename::fileparse( $basename, qr/\.[A-Za-z0-9]+$/ );
        my $unique_stem = $stem;
        $local_file = File::Spec->catfile( $param{support_path},
            $unique_stem . $type );
        my $i = 1;
        while ( $fmgr->exists($local_file) ) {
            $unique_stem = join q{-}, $stem, $i++;
            $local_file = File::Spec->catfile( $param{support_path},
                $unique_stem . $type );
        }

        my $unique_basename = $unique_stem . $type;
        $relative_path = $unique_basename;
        $relative_url  = encode_url($unique_basename);
        $asset_file
            = File::Spec->catfile( '%s', 'uploads', $unique_basename );
    }

    if ( my $deny_exts = $app->config->DeniedAssetFileExtensions ) {
        my @deny_exts = map {
            if   ( $_ =~ m/^\./ ) {qr/$_/i}
            else                  {qr/\.$_/i}
        } split '\s?,\s?', $deny_exts;
        my @ret = File::Basename::fileparse( $basename, @deny_exts );
        if ( $ret[2] ) {
            return $app->error(
                $app->translate(
                    'The file ([_1]) that you uploaded is not allowed.',
                    $basename
                )
            );
        }

    }

    if ( my $allow_exts = $app->config('AssetFileExtensions') ) {
        my @allow_exts = map {
            if   ( $_ =~ m/^\./ ) {qr/$_/i}
            else                  {qr/\.$_/i}
        } split '\s?,\s?', $allow_exts;
        my @ret = File::Basename::fileparse( $local_file, @allow_exts );
        unless ( $ret[2] ) {
            return $app->error(
                $app->translate(
                    'The file ([_1]) that you uploaded is not allowed.',
                    $basename
                )
            );
        }
    }

    my ( $w, $h, $id, $write_file ) = MT::Image->check_upload(
        Fh     => $fh,
        Fmgr   => $fmgr,
        Local  => $local_file,
        Max    => $upload_param{max_size},
        MaxDim => $upload_param{max_image_dimension}
    );

    return $app->error( MT::Image->errstr )
        unless $write_file;

    ## File does not exist, or else we have confirmed that we can overwrite.
    my $umask = oct $app->config('UploadUmask');
    my $old   = umask($umask);
    defined( my $bytes = $write_file->() )
        or return $app->error(
        $app->translate(
            "Error writing upload to '[_1]': [_2]", $local_file,
            $fmgr->errstr
        )
        );
    umask($old);

    ## Close up the filehandle.
    close $fh;

    ## If we are overwriting the file, that means we still have a temp file
    ## lying around. Delete it.
    if ( $q->param('overwrite_yes') ) {
        my $tmp = $q->param('temp');

        return $app->error(
            $app->translate( "Invalid temp file name '[_1]'", $tmp ) )
            unless _is_valid_tempfile_basename($tmp);

        my $tmp_file = File::Spec->catfile( $app->config('TempDir'), $tmp );
        $fmgr->delete($tmp_file)
            or return $app->error(
            $app->translate( "Error deleting '[_1]': [_2]", $tmp_file, "$!" )
            );
    }

    ## We are going to use $relative_path as the filename and as the url passed
    ## in to the templates. So, we want to replace all of the '\' characters
    ## with '/' characters so that it won't look like backslashed characters.
    ## Also, get rid of a slash at the front, if present.
    $relative_path =~ s!\\!/!g;
    $relative_path =~ s!^/!!;
    $relative_url =~ s!\\!/!g;
    $relative_url =~ s!^/!!;
    my $url = $base_url;
    $url .= '/' unless $url =~ m!/$!;
    $url .= $relative_url;
    my $asset_url = $asset_base_url . '/' . $relative_url;

    require File::Basename;
    my $local_basename = File::Basename::basename($local_file);
    my $ext
        = ( File::Basename::fileparse( $local_file, qr/[A-Za-z0-9]+$/ ) )[2];

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local_basename);
    my $is_image  = 0;
    if ( defined($w) && defined($h) ) {
        $is_image = 1
            if $asset_pkg->isa('MT::Asset::Image');
    }
    else {

        # rebless to file type
        $asset_pkg = 'MT::Asset'
            if $asset_pkg->isa('MT::Asset::Image');
    }
    return $app->errtrans('Uploaded file is not an image.')
        if !$is_image
        && exists( $upload_param{require_type} )
        && $upload_param{require_type} eq 'image';
    my ( $asset, $original );
    if (!(  $asset = $asset_pkg->load(
                {   class     => '*',
                    file_path => $asset_file,
                    blog_id   => $blog_id
                },
                { binary => { file_path => 1 } }
            )
        )
        )
    {
        $asset    = $asset_pkg->new();
        $original = $asset->clone;
        $asset->file_path($asset_file);
        $asset->file_name($local_basename);
        $asset->file_ext($ext);
        $asset->blog_id($blog_id);
        $asset->label($local_basename);
        $asset->created_by( $app->user->id );
    }
    else {
        if ( $asset->class ne $asset_pkg->class_type ) {
            return $app->error(
                $app->translate(
                    "Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]",
                    $asset->class_label,
                    $asset_pkg->class_label
                )
            );
        }
        $original = $asset->clone;
        $asset->modified_by( $app->user->id );
    }
    $asset->url($asset_url);

    if ($is_image) {
        $asset->image_width($w);
        $asset->image_height($h);

        if ( $q->param('normalize_orientation') ) {
            $asset->normalize_orientation;
        }
    }

    $asset->mime_type($mimetype) if $mimetype;
    $app->run_callbacks( $app_id . '_pre_save.asset',
        $app, $asset, $original )
        || return $app->errtrans( "Saving [_1] failed: [_2]", 'asset',
        $app->errstr );

    $asset->save;
    $app->run_callbacks( $app_id . '_post_save.asset',
        $app, $asset, $original );

    if ($is_image) {
        $app->run_callbacks(
            $app_id . '_upload_file.' . $asset->class,
            File  => $local_file,
            file  => $local_file,
            Url   => $url,
            url   => $url,
            Size  => $bytes,
            size  => $bytes,
            Asset => $asset,
            asset => $asset,
            Type  => 'image',
            type  => 'image',
            Blog  => $blog,
            blog  => $blog
        );
        $app->run_callbacks(
            $app_id . '_upload_image',
            File       => $local_file,
            file       => $local_file,
            Url        => $url,
            url        => $url,
            Size       => $bytes,
            size       => $bytes,
            Asset      => $asset,
            asset      => $asset,
            Height     => $h,
            height     => $h,
            Width      => $w,
            width      => $w,
            Type       => 'image',
            type       => 'image',
            ImageType  => $id,
            image_type => $id,
            Blog       => $blog,
            blog       => $blog
        );
    }
    else {
        $app->run_callbacks(
            $app_id . '_upload_file.' . $asset->class,
            File  => $local_file,
            file  => $local_file,
            Url   => $url,
            url   => $url,
            Size  => $bytes,
            size  => $bytes,
            Asset => $asset,
            asset => $asset,
            Type  => 'file',
            type  => 'file',
            Blog  => $blog,
            blog  => $blog
        );
    }

    return ( $asset, $bytes );
}

sub _is_valid_tempfile_basename {
    my ($filename) = @_;
    $filename
        && File::Basename::basename($filename) eq $filename
        && $filename !~ m!^\.\.|\0|\|!;
}

sub _rename_if_exists {
    my ( $app, $fmgr, $path_info ) = @_;

    my $local_file = File::Spec->catfile(
        @$path_info{qw(rootPath relativePath basename)} );
    if ( $fmgr->exists($local_file) ) {
        my $ext = (
            File::Basename::fileparse(
                $path_info->{basename},
                qr/\.[A-Za-z0-9]+$/
            )
        )[2];

        $path_info->{basename} = perl_sha1_digest_hex(
            join( '-',
                epoch2ts( $app->blog, time ), $app->remote_ip,
                $path_info->{basename} )
        ) . $ext;
    }
}

sub _write_upload {
    my ( $upload_fh, $dest_fh ) = @_;
    my $fh = gensym();
    if ( ref($dest_fh) eq 'GLOB' ) {
        $fh = $dest_fh;
    }
    else {
        open $fh, '>', $dest_fh or return;
    }
    binmode $fh;
    binmode $upload_fh;
    my ( $bytes, $data ) = (0);
    while ( my $len = read $upload_fh, $data, 8192 ) {
        print $fh $data;
        $bytes += $len;
    }
    close $fh;
    $bytes;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    $load_options->{args}->{no_class} = 1;

    my $user = $app->user;
    return if $user->is_superuser;

    my $load_blog_ids = $load_options->{blog_ids} || undef;

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $load_blog_ids
                ? ( blog_id => $load_blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        if ( $perm->can_do('edit_assets') ) {
            push @$blog_ids, $perm->blog_id;
        }
    }

    my $terms = $load_options->{terms} || {};
    $terms->{blog_id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

sub template_param_list {
    my $cb = shift;
    my ( $app, $param, $tmpl ) = @_;

    # Check directory for thumbnail image
    _check_thumbnail_dir( $app, $param );
}

sub _check_thumbnail_dir {
    my $app = shift;
    my ($param) = @_;

    return unless $app->blog;

    require MT::FileMgr;
    require File::Spec;
    my $fmgr            = MT::FileMgr->new('Local');
    my $path            = MT->config('AssetCacheDir');
    my $site_path       = $app->blog->site_path;
    my $site_thumb_path = File::Spec->catdir( $site_path, $path );
    my @warnings;
    if ( $fmgr->exists($site_thumb_path)
        && !$fmgr->can_write($site_thumb_path) )
    {
        my %hash = (
            key  => 'site',
            path => $site_thumb_path,
        );
        push @warnings, \%hash;
    }
    if ( $app->blog->column('archive_path') ) {
        my $archive_path = $app->blog->archive_path;
        my $archive_thumb_path = File::Spec->catdir( $archive_path, $path );
        if ( $fmgr->exists($archive_thumb_path)
            && !$fmgr->can_write($archive_thumb_path) )
        {
            my %hash = (
                key  => 'archive',
                path => $archive_thumb_path,
            );
            push @warnings, \%hash;
        }
    }
    $param->{thumb_dir_warnings} = \@warnings if @warnings;
}

1;
