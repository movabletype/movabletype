# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Asset;

use strict;
use warnings;
use Symbol;
use MT::Util
    qw( epoch2ts encode_url format_ts relative_date perl_sha1_digest_hex);

my $default_thumbnail_size = 60;

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    $app->validate_param({
        id => [qw/ID/],
    }) or return;

    my $user  = $app->user;
    my $perms = $app->permissions
        or return $app->permission_denied();
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
        $param->{tags_js} = MT::Tag->get_tags_js( $obj->blog_id );

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

        my $user = MT->model('author')->load(
            {   id   => $obj->created_by(),
                type => MT::Author::AUTHOR()
            }
        );
        if ($user) {
            $param->{created_by} = $user->nickname;
        }
        else {
            $param->{created_by} = $app->translate('(user deleted)');
        }
        if ( $obj->modified_by() ) {
            $user = MT->model('author')->load(
                {   id   => $obj->modified_by(),
                    type => MT::Author::AUTHOR()
                }
            );
            if ($user) {
                $param->{modified_by} = $user->nickname;
            }
            else {
                $param->{modified_by} = $app->translate('(user deleted)');
            }
        }

        $param->{broken_metadata} = $obj->is_metadata_broken;
    }

    $app->add_breadcrumb(
        $app->translate('Assets'),
        $app->uri(
            'mode' => 'list',
            args   => {
                _type   => 'asset',
                blog_id => $app->blog ? $app->blog->id : 0,
            },
        ),
    );
    $app->add_breadcrumb( $obj->label ) if $id;

    1;
}

sub dialog_list_asset {
    my $app = shift;

    return dialog_asset_modal( $app, @_ ) unless $app->param('json');

    my $blog_id = $app->param('blog_id');
    my $mode_userpic = $app->param('upload_mode') || '';
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog_id && $mode_userpic ne 'upload_userpic';

    my $blog_class = $app->model('blog');
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;

    return $app->permission_denied()
        if $blog_id && !$app->can_do('access_to_insert_asset_list');

    my $asset_class = $app->model('asset') or return;
    my %terms;
    my %args = ( sort => 'created_on', direction => 'descend' );

    my $class_filter;
    my $filter = $app->param('filter') || '';
    if ( $filter eq 'class' ) {
        $class_filter = $app->param('filter_val');
    }
    elsif ( $filter eq 'userpic' ) {
        $class_filter      = 'image';
        $terms{created_by} = $app->param('filter_val');
        $terms{blog_id}    = 0;

        my $tag = MT->model('tag')
            ->load( { name => '@userpic' }, { binary => { name => 1 } } );
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

    my $content_field_id = $app->param('content_field_id');
    if ($blog_id && !$content_field_id) {
        my $blog_ids = $app->_load_child_blog_ids($blog_id);
        push @$blog_ids, $blog_id;
        $terms{blog_id} = $blog_ids;
    }

    my $hasher = build_asset_hasher(
        $app,
        PreviewWidth     => 120,
        PreviewHeight    => 120,
        NoTags           => 1,
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
    my %carry_params
        = map { $_ => $app->param($_) || '' }
        (
        qw( edit_field upload_mode require_type next_mode asset_select can_multi )
        );
    $carry_params{'user_id'} = $app->param('filter_val')
        if $filter eq 'userpic';
    _set_start_upload_params( $app, \%carry_params )
        if $app->can_do('upload');
    my $ext_from = $app->param('ext_from');
    my $ext_to   = $app->param('ext_to');

    # Check directory for thumbnail image
    _check_thumbnail_dir( $app, \%carry_params );

    $app->listing(
        {   terms    => \%terms,
            args     => \%args,
            type     => 'asset',
            code     => $hasher,
            template => 'include/async_asset_list.tmpl',
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
                dir_separator => MT::Util::dir_separator,
                %carry_params,
            },
        }
    );
}

sub insert {
    my $app = shift;

    $app->validate_magic() or return;

    return $app->permission_denied()
        unless $app->can_do('insert_asset');

    my $text = $app->param('no_insert') ? "" : _process_post_upload($app);
    return unless defined $text;
    my $extension_message;
    if ( my $file_ext_changes = $app->param('changed_file_ext') ) {
        my ( $ext_from, $ext_to ) = split( ",", $file_ext_changes );
        $extension_message
            = $app->translate( "Extension changed from [_1] to [_2]",
            $ext_from, $ext_to )
            if ( $ext_from && $ext_to );
    }
    my $tmpl;

    my $edit_field = $app->param('edit_field') || '';
    my $id = $app->param('id') or return $app->errtrans("Invalid request.");
    my $asset = MT->model('asset')->load($id);
    if ($extension_message) {
        $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {   upload_html => $text || '',
                edit_field => $edit_field,
                extension_message => $extension_message,
                asset_type        => $asset->class,
            },
        );
    }
    else {
        $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {   upload_html => $text || '',
                edit_field  => $edit_field,
                asset_type  => $asset->class,
            },
        );
    }
    my $ctx    = $tmpl->context;
    my $assets = [$asset];
    $ctx->stash( 'assets', $assets );
    return $tmpl;
}

sub asset_userpic {
    my $app = shift;
    my ($param) = @_;

    $app->validate_magic() or return;

    $app->validate_param({
        edit_field => [qw/MAYBE_STRING/],
        id         => [qw/ID/],
        user_id    => [qw/ID/],
    }) or return;

    my ( $id, $asset );
    if ( $asset = $param->{asset} ) {
        $id = $asset->id;
    }
    else {
        $id = $param->{asset_id} || $app->param('id');
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

            if ( !defined $user->userpic_asset_id
                or $user->userpic_asset_id != $asset->id )
            {
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
        ? $user->userpic_html( Asset => $asset, Ts => 1, Lazy => 1 )
        : $app->model('author')->userpic_html( Asset => $asset, Ts => 1, Lazy => 1 );

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

    return $app->permission_denied unless $app->can_do('upload');

    $app->add_breadcrumb(
        $app->translate('Assets'),
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'asset',
                blog_id => $app->blog->id,
            },
        ),
    );
    $app->add_breadcrumb( $app->translate('Upload Asset') );
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

    $param{can_multi} = 1;

    # Check directory for thumbnail image
    _check_thumbnail_dir( $app, \%param );

    $param{dialog} = $dialog;
    my $tmpl_file
        = $dialog ? 'dialog/asset_upload.tmpl' : 'asset_upload.tmpl';

    # Set directory separator
    $param{dir_separator} = MT::Util::dir_separator;

    $app->load_tmpl( $tmpl_file, \%param );
}

sub js_upload_file {
    my $app = shift;

    my $is_userpic = ( $app->param('type') || '' ) eq 'userpic' ? 1 : 0;
    my $user_id = $app->param('user_id');
    if ($is_userpic) {
        return $app->error(
            $app->json_error( $app->translate("Invalid Request.") ) )
            unless $user_id;

        my $user = $app->model('author')->load( { id => $user_id } )
            or return $app->error(
            $app->json_error( $app->translate("Invalid Request.") ) );

        my $appuser = $app->user;
        if ( ( !$appuser->is_superuser ) && ( $user->id != $appuser->id ) ) {
            return $app->error(
                $app->json_error( $app->translate("Permission denied.") ) );
        }
    }
    else {
        if ( my $perms = $app->permissions ) {
            return $app->error(
                $app->json_error( $app->translate("Permission denied.") ) )
                unless $perms->can_do('upload');
        }
        else {
            return $app->error(
                $app->json_error( $app->translate("Permission denied.") ) );
        }
    }
    $app->validate_magic()
        or return $app->error(
        $app->json_error( $app->translate("Invalid Request.") ) );

    # Save as asset
    my ( $asset, $bytes ) = _upload_file(
        $app,
        require_type => ( $app->param('require_type') || '' ),
        error_handler => sub {
            my ( $_app, %params ) = @_;
            return $app->error( $app->json_error( $params{error} ) );
        },
        cancel_handler => sub {
            my ( $_app, %params ) = @_;
            return $app->json_result(
                {   cancel => $app->translate(
                        "File with name '[_1]' already exists. Upload has been cancelled.",
                        $params{fname}
                    )
                }
            );
        },
        js => 1,
    );
    return unless $asset;

    # Set tag for userpic
    if ($is_userpic) {
        $asset->tags('@userpic');
        $asset->created_by($user_id);
        $asset->save;
    }

    # Make thumbnail
    my $thumb_url;
    my $thumb_type;
    my $thumb_size = $app->param('thumbnail_size') || $default_thumbnail_size;
    if ( $asset->has_thumbnail && $asset->can_create_thumbnail ) {
        my ( $orig_height, $orig_width )
            = ( $asset->image_width, $asset->image_height );
        if ( $orig_width > $thumb_size && $orig_height > $thumb_size ) {
            ($thumb_url) = $asset->thumbnail_url(
                Height => $thumb_size,
                Width  => $thumb_size,
                Square => 1,
                Ts     => 1
            );
        }
        elsif ( $orig_width > $thumb_size ) {
            ($thumb_url)
                = $asset->thumbnail_url( Width => $thumb_size, Ts => 1 );
        }
        elsif ( $orig_height > $thumb_size ) {
            ($thumb_url)
                = $asset->thumbnail_url( Height => $thumb_size, Ts => 1 );
        }
        else {
            $thumb_url = $asset->url;
        }
        $thumb_type = 'image';
    }
    else {
        $thumb_type
            = $asset->class_type eq 'file'  ? 'default'
            : $asset->class_type eq 'video' ? 'movie'
            :                                 $asset->class_type;
    }

    # Check extension auto-change
    my $extension_message;
    if ( my $file_ext_changes = $app->param('changed_file_ext') ) {
        my ( $ext_from, $ext_to ) = split( ",", $file_ext_changes );
        $extension_message
            = $app->translate( "Extension changed from [_1] to [_2]",
            $ext_from, $ext_to )
            if ( $ext_from && $ext_to );
    }

    my $metadata = {
        id             => $asset->id,
        filename       => $asset->file_name,
        blog_id        => $asset->blog_id,
        thumbnail_type => $thumb_type,
        $thumb_url ? ( thumbnail => $thumb_url ) : (),
        ( $extension_message ? ( message => $extension_message ) : () ),
    };
    return $app->json_result( { asset => $metadata } );
}

### DEPRECATED: v6.2
sub upload_file {
    my $app = shift;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.8');

    if ( my $perms = $app->permissions ) {
        return $app->error( $app->translate("Permission denied.") )
            unless $perms->can_do('upload');
    }
    else {
        return $app->error( $app->translate("Permission denied.") );
    }

    $app->validate_magic() or return;

    my ( $asset, $bytes ) = _upload_file_compat(
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

    my $id      = $app->param('id');
    my $blog_id = $app->param('blog_id');

    if ( !$asset && $id ) {
        require MT::Asset;
        $asset = MT->model('asset')->load($id)
            || return $app->errtrans( "Cannot load file #[_1].", $id );
    }
    return $app->errtrans('Invalid request.') unless $asset;

    $args{is_image} = $asset->isa('MT::Asset::Image') ? 1 : 0
        unless defined $args{is_image};

    require MT::Blog;
    my $blog = $asset->blog
        or return $app->errtrans( "Cannot load blog #[_1].", $blog_id );
    my $perms = $app->permissions
        or return $app->errtrans('No permissions');

    # caller wants asset without any option step, so insert immediately
    if ( $app->param('asset_select') || $app->param('no_insert') ) {
        $app->param( 'id', $asset->id );
        return insert($app);
    }

    my $middle_path = $app->param('middle_path') || '';
    my $extra_path  = $app->param('extra_path')  || '';
    my $param       = {
        asset_id    => $asset->id,
        bytes       => $args{bytes},
        fname       => $asset->file_name,
        is_image    => $args{is_image} || 0,
        url         => $asset->url,
        middle_path => $middle_path,
        extra_path  => $extra_path,
    };
    for my $field (
        qw( direct_asset_insert edit_field entry_insert site_path
        asset_select )
        )
    {
        $param->{$field} = $app->param($field) || '';
    }
    if ( $args{is_image} ) {
        $param->{width}  = $asset->image_width;
        $param->{height} = $asset->image_height;
    }
    my ( $extension_message, $ext_from, $ext_to );
    if ( my $file_ext_changes = $app->param('changed_file_ext') ) {
        ( $ext_from, $ext_to ) = split( ",", $file_ext_changes );
        $extension_message
            = $app->translate( "Extension changed from [_1] to [_2]",
            $ext_from, $ext_to )
            if ( $ext_from && $ext_to );
        $param->{extension_message} = $extension_message;
        $param->{ext_from}          = $ext_from;
        $param->{ext_to}            = $ext_to;
    }

    # no need to check asset_select here (returns earlier if it's set)
    if ( $perms->can_do('insert_asset') ) {
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
        my $tags_js = MT::Util::to_json(
            [   map { $_->name } MT->model('tag')->load(
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

    # XXX: useless? should always be false
    $param->{'no_insert'} = $app->param('no_insert');

    if ( $app->param('dialog') ) {
        $app->load_tmpl( 'dialog/asset_options.tmpl', $param );
    }
    else {
        if ( $app->can_do('access_to_asset_list') ) {
            my $redirect_args = {
                blog_id => $blog_id,
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
                        blog_id           => $blog_id,
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
    $param{id} && ( $asset = MT->model('asset')->load( $param{id} ) )
        or return $app->errtrans("Invalid request.");

   # User has permission to delete asset and asset file, or user created asset
    if ( ( $app->can_do('delete_asset') && $app->can_do('delete_asset_file') )
        || $asset->created_by == $app->user->id )
    {
        # Do not delete asset if asset has been modified since initial upload
        if ( $asset->modified_on == $asset->created_on ) {

            # Label, description, & tags params exist on asset options
            #   page if we were editing newly upload asset
            if (   exists( $param{label} )
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
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    my %param   = $app->param_hash;
    my $asset;
    $param{id} && ( $asset = MT->model('asset')->load( $param{id} ) )
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

    return $app->permission_denied()
        unless $app->can_do('access_to_asset_list');

    return $app->redirect(
        $app->uri(
            'mode' => 'list',
            args   => { '_type' => 'asset', 'blog_id' => $blog_id }
        )
    );
}

sub start_upload_entry {
    my $app = shift;

    $app->validate_magic() or return;

    my $id   = $app->param('id');
    my $blog = $app->blog;
    my $type = 'entry';
    $type = 'page'
        if ( $blog && !$blog->is_blog() );
    $app->param( '_type', $type );
    defined( my $text = _process_post_upload($app) ) or return;
    $app->param( 'text',     $text );
    $app->param( 'asset_id', $id );
    $app->param( 'id',       0 );
    $app->param( 'tags',     '' );
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
            level    => MT::Log::NOTICE(),
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
        $default_preview_width, $default_preview_height,
        $no_tags,
    ) = @param{qw( ThumbWidth ThumbHeight PreviewWidth PreviewHeight NoTags )};

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
        my $meta      = $obj->metadata(no_tags => $no_tags);

        $row->{file_is_missing} = 0;

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
            $row->{has_thumbnail}  = 1;
            $row->{can_edit_image} = 1;
            my $height = $thumb_height || $default_thumb_height || $default_thumbnail_size;
            my $width  = $thumb_width  || $default_thumb_width  || $default_thumbnail_size;
            my $square = $height == $default_thumbnail_size && $width == $default_thumbnail_size;
            my $thumbnail_method = $obj->can('maybe_dynamic_thumbnail_url') || 'thumbnail_url';
            @$meta{qw( thumbnail_url thumbnail_width thumbnail_height )}
                = $obj->$thumbnail_method(
                Height => $height,
                Width  => $width,
                Square => $square,
                Ts     => 1,
                );

            $meta->{thumbnail_width_offset}
                = int( ( $width - $meta->{thumbnail_width} ) / 2 );
            $meta->{thumbnail_height_offset}
                = int( ( $height - $meta->{thumbnail_height} ) / 2 );

            if ( $default_preview_width && $default_preview_height ) {
                @$meta{qw( preview_url preview_width preview_height )}
                    = $obj->$thumbnail_method(
                    Height => $default_preview_height,
                    Width  => $default_preview_width,
                    Ts     => 1,
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
            my $user = MT->model('author')->load($by);
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

    my @objs;
    while ( my $obj = $iter->() ) {
        push @objs, $obj;
        last if $limit and @objs > $limit;
    }
    return [] unless @objs;

    require MT::Meta::Proxy;
    MT::Meta::Proxy->bulk_load_meta_objects(\@objs);

    my @data;
    my $hasher = build_asset_hasher($app, NoTags => 1);
    for my $obj (@objs) {
        my $row = $obj->get_values;
        $hasher->( $obj, $row );
        $row->{object} = $obj;
        push @data, $row;
    }

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
    my $id      = $app->param('id')
        or return $app->errtrans("Invalid request.");
    my $asset = MT->model('asset')->load($id)
        or return $app->errtrans( "Cannot load file #[_1].", $id );
    $param->{enclose}
        = ( $app->param('edit_field') || '' ) =~ /^customfield/ ? 1 : 0;
    return $asset->as_html($param);
}

sub _process_post_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    $param{id} && ( $asset = MT->model('asset')->load( $param{id} ) )
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

sub _make_upload_destinations {
    my $app = shift;
    my ( $blog, $real_path ) = @_;

    my @dest_root;
    my $class_label = $app->translate('Site');

    require POSIX;
    my $user_basename;
    my $y;
    my $ym;
    my $ymd;
    my $now = MT::Util::offset_time(time);

    if ($real_path) {
        $user_basename = $app->user->basename;
        $y             = POSIX::strftime( "%Y", gmtime($now) );
        $ym            = POSIX::strftime( "%Y/%m", gmtime($now) );
        $ymd           = POSIX::strftime( "%Y/%m/%d", gmtime($now) );
    }
    else {
        $user_basename = $app->translate('basename of user');
        $y             = 'yyyy';
        $ym            = 'yyyy/mm';
        $ymd           = 'yyyy/mm/dd';
    }

    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>', $class_label ),
        path  => '%s',
        };
    push @dest_root,
        {
        label => $app->translate(
            '<[_1] Root>/[_2]',
            $class_label, $user_basename
        ),
        path => '%s/%u',
        };
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>/[_2]', $class_label, $y ),
        path  => '%s/%y',
        };
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>/[_2]', $class_label, $ym ),
        path  => '%s/%y/%m',
        };
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>/[_2]', $class_label, $ymd ),
        path  => '%s/%y/%m/%d',
        };

    my $archive_flg = { 'archive' => 1, 'disabled' => 0};
    unless ( $blog->column('archive_path') ) {
        $archive_flg->{disabled} = 1;
    }
    $class_label = MT->translate('Archive');
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>', $class_label ),
        path  => '%a',
        %$archive_flg
        };
    push @dest_root,
        {
        label => $app->translate(
            '<[_1] Root>/[_2]',
            $class_label, $user_basename
        ),
        path => '%a/%u',
        %$archive_flg
        };
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>/[_2]', $class_label, $y ),
        path  => '%a/%y',
        %$archive_flg
        };
    push @dest_root,
        {
        label => $app->translate( '<[_1] Root>/[_2]', $class_label, $ym ),
        path  => '%a/%y/%m',
        %$archive_flg
        };
    push @dest_root,
        {
        label =>
            $app->translate( '<[_1] Root>/[_2]', $class_label, $ymd ),
        path => '%a/%y/%m/%d',
        %$archive_flg
        };

    if ( $blog->upload_destination ) {
        if ( my @selected
            = grep { $blog->upload_destination eq $_->{path} } @dest_root )
        {
            $_->{selected} = 1 for @selected;
        }
        else {
            my $label = $blog->upload_destination;
            if ($real_path) {

                # Replace %s and %a.
                if ( $label =~ /^%s/ ) {
                    my $site_root
                        = $app->translate( '<[_1] Root>',
                        $blog->class_label );
                    $label =~ s/^%s/$site_root/;
                }
                elsif ( $label =~ /^%a/ ) {
                    my $archive_root = $app->translate( '<[_1] Root>',
                        MT->translate('Archive') );
                    $label =~ s/^%a/$archive_root/;
                }

                # Replace %u, %y, %m and %d.
                my $u = $app->user->basename;
                my $y = POSIX::strftime( "%Y", gmtime($now) );
                my $m = POSIX::strftime( "%m", gmtime($now) );
                my $d = POSIX::strftime( "%d", gmtime($now) );
                $label =~ s/%u/$u/g;
                $label =~ s/%y/$y/g;
                $label =~ s/%m/$m/g;
                $label =~ s/%d/$d/g;
            }

            unshift @dest_root,
                {
                label    => $label,
                path     => $blog->upload_destination,
                selected => 1,
                };
        }
    }

    push @dest_root, { label => $app->translate('Custom...') };

    return @dest_root;
}

sub _set_start_upload_params {

    my $app = shift;
    my ($param) = @_;

    if ( my $perms = $app->permissions ) {
        my $blog_id = $app->param('blog_id');
        if ($blog_id) {
            my $blog = MT->model('blog')->load($blog_id)
                or return $app->error(
                $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

            # Make a list of upload destination
            my @dest_root = _make_upload_destinations( $app, $blog, 1 );
            $param->{destination_loop} = \@dest_root;

            # Set default upload options
            $param->{allow_to_change_at_upload}
                = defined $blog->allow_to_change_at_upload
                ? $blog->allow_to_change_at_upload
                : 1;
            if ( !$param->{allow_to_change_at_upload} ) {
                foreach my $opt ( grep { $_->{selected} } @dest_root ) {
                    $param->{upload_destination_label} = $opt->{label};
                    $param->{upload_destination_value} = $opt->{path};
                }
            }
            $param->{destination}         = $blog->upload_destination;
            $param->{extra_path}          = $blog->extra_path;
            $param->{operation_if_exists} = $blog->operation_if_exists;
            $param->{normalize_orientation}
                = defined $blog->normalize_orientation
                ? $blog->normalize_orientation
                : 1;
            $param->{auto_rename_non_ascii}
                = defined $blog->auto_rename_non_ascii
                ? $blog->auto_rename_non_ascii
                : 1;
        }
    }
    else {
        $param->{normalize_orientation} = 1;
        $param->{auto_rename_non_ascii} = 1;
    }

    $param->{max_upload_size} = $app->config->CGIMaxUpload;

    $param;
}

### Not used from Web UI since v6.2, but still used by DataAPI endpoints
sub _upload_file_compat {
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
    my ( $fh, $info ) = $app->upload_info('file');
    my $mimetype;
    if ($info) {
        $mimetype = $info->{'Content-Type'};
    }
    my $has_overwrite = $app->param('overwrite_yes')
        || $app->param('overwrite_no');
    my %param = (
        entry_insert => scalar( $app->param('entry_insert') ),
        middle_path  => scalar( $app->param('middle_path') ),
        edit_field   => scalar( $app->param('edit_field') ),
        site_path    => scalar( $app->param('site_path') ),
        extra_path   => scalar( $app->param('extra_path') ),
        upload_mode  => $app->mode,
    );
    return $eh->(
        $app, %param,
        error => $app->translate("Please select a file to upload.")
    ) if !$fh && !$has_overwrite;
    my $basename = $app->param('file') || $app->param('fname');
    $basename =~ s!\\!/!g;    ## Change backslashes to forward slashes
    $basename =~ s!^.*/!!;    ## Get rid of full directory paths
    if ( $basename =~ m!\.\.|\0|\|! ) {
        return $eh->(
            $app, %param,
            error => $app->translate( "Invalid filename '[_1]'", $basename )
        );
    }

    if (   $app->param('auto_rename_non_ascii')
        && $basename =~ m/[^\x20-\x7E]/ )
    {
        # Auto-rename
        my $path_info = { basename => $basename };
        _rename_filename( $app, $path_info );
        $basename = $path_info->{basename};
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
    if ( $blog_id = $app->param('blog_id') ) {
        unless ($has_overwrite) {
            if ( my $ext_new = MT::Image->get_image_type($fh) ) {
                my $ext_old
                    = (
                    File::Basename::fileparse( $basename, qr/[A-Za-z0-9]+$/ )
                    )[2];
                if (   $ext_new ne lc($ext_old)
                    && !( lc($ext_old) eq 'jpeg' && $ext_new eq 'jpg' )
                    && !( lc($ext_old) eq 'ico'  && $ext_new =~ /^(bmp|png|gif)$/ )
                    && !( lc($ext_old) eq 'mpeg' && $ext_new eq 'mpg' )
                    && !( lc($ext_old) eq 'swf'  && $ext_new eq 'cws' ) )
                {
                    if ( $basename eq $ext_old ) {
                        $basename .= '.' . $ext_new;
                        $ext_old = $app->translate('none');
                    }
                    else {
                        $basename =~ s/$ext_old$/$ext_new/;
                    }
                    $app->param( "changed_file_ext", "$ext_old,$ext_new" );
                }
            }
        }

        $param{blog_id} = $blog_id;
        $blog = MT->model('blog')->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
        $fmgr = $blog->file_mgr;

        ## Set up the full path to the local file; this path could start
        ## at either the Local Site Path or Local Archive Path, and could
        ## include an extra directory or two in the middle.
        my ( $root_path, $middle_path );
        if ( $app->param('site_path') ) {
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
        $relative_path = $app->param('extra_path')  || '';
        $middle_path   = $app->param('middle_path') || '';
        my $relative_path_save = $relative_path;
        if ( $middle_path ne '' ) {
            $relative_path = $middle_path
                . ( $relative_path ? '/' . $relative_path : '' );
        }

        {
            my $path_info = {};
            @$path_info{qw(rootPath relativePath basename)}
                = ( $root_path, $relative_path, $basename );

            if ( $app->param('auto_rename_if_exists') ) {
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
                        "Invalid upload path '[_1]'",
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
        $asset_file = $app->param('site_path') ? '%r' : '%a';
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
                my $tmp = $app->param('temp');

                return $app->error(
                    $app->translate( "Invalid temp file name '[_1]'", $tmp ) )
                    unless _is_valid_tempfile_basename($tmp);

                my $tmp_dir = $app->config('TempDir');
                my $tmp_file = File::Spec->catfile( $tmp_dir, $tmp );
                if ( $app->param('overwrite_yes') ) {
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
                my $extension_message;
                if ( my $file_ext_changes = $app->param('changed_file_ext') )
                {
                    my ( $ext_from, $ext_to )
                        = split( ",", $file_ext_changes );
                    $extension_message
                        = $app->translate(
                        "Extension changed from [_1] to [_2]",
                        $ext_from, $ext_to )
                        if ( $ext_from && $ext_to );
                }
                return $exists_handler->(
                    $app,
                    temp         => $tmp,
                    extra_path   => $relative_path_save,
                    site_path    => scalar $app->param('site_path'),
                    asset_select => scalar $app->param('asset_select'),
                    entry_insert => scalar $app->param('entry_insert'),
                    edit_field   => scalar $app->param('edit_field'),
                    middle_path  => $middle_path,
                    fname        => $basename,
                    no_insert    => $app->param('no_insert') || "",
                    (   $extension_message
                        ? ( extension_message => $extension_message )
                        : ()
                    ),
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

    my ( $base, $uploaded_path, $ext )
        = File::Basename::fileparse( $basename, '\.[^\.]*' );

    if ( my $deny_exts = $app->config->DeniedAssetFileExtensions ) {
        my @deny_exts = map {
            if   ( $_ =~ m/^\./ ) {qr/$_(?:\..*)?/i}
            else                  {qr/\.$_(?:\..*)?/i}
        } grep {defined $_ && $_ ne ''} split '\s?,\s?', $deny_exts;
        my @ret = File::Basename::fileparse( $basename, @deny_exts );
        if ( $ret[2] ) {
            return $app->error(
                $app->translate(
                    '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                    $ret[2],
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
                    '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                    $ext,
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
    if ( $app->param('overwrite_yes') ) {
        my $tmp = $app->param('temp');

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
    my $local_ext
        = ( File::Basename::fileparse( $local_file, qr/\.[A-Za-z0-9]+$/ ) )
        [2];
    $local_ext =~ s/^\.//;

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
        $asset->file_ext($local_ext);
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

        if ( $app->param('normalize_orientation') ) {
            $asset->normalize_orientation;
        }

        # Adjust image quality according to ImageQualityJpeg
        # and ImageQualityPng.
        $asset->change_quality
            if $app->config('AutoChangeImageQuality');

        if ($app->config('ForceExifRemoval')) {
            $asset->remove_all_metadata;
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

sub _upload_file {
    my $app = shift;
    my (%upload_param) = @_;

    require MT::Image;
    my $app_id = $app->id;

    # Setup handlers
    my $eh = $upload_param{error_handler} || sub {
        start_upload(@_);
    };

    my ( $fh, $info ) = $app->upload_info('file');
    my $mimetype;
    if ($info) {
        $mimetype = $info->{'Content-Type'};
    }
    my %param = (
        entry_insert => scalar( $app->param('entry_insert') ),
        edit_field   => scalar( $app->param('edit_field') ),
        destination  => scalar( $app->param('destination') ),
        extra_path   => scalar( $app->param('extra_path') ),
        upload_mode  => $app->mode,
    );
    return $eh->(
        $app, %param,
        error => $app->translate("Please select a file to upload.")
    ) if !$fh;

    my $basename = $app->param('file') || $app->param('fname');
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
        : Encode::decode( $upload_param{js} ? 'utf-8' : $app->charset,
        File::Basename::basename($basename) );

    # Change to real file extension
    if ( my $ext_new = MT::Image->get_image_type($fh) ) {
        my $ext_old
            = ( File::Basename::fileparse( $basename, qr/[A-Za-z0-9]+$/ ) )
            [2];

        if (   $ext_new ne lc($ext_old)
            && !( lc($ext_old) eq 'jpeg' && $ext_new eq 'jpg' )
            && !( lc($ext_old) eq 'ico'  && $ext_new =~ /^(?:bmp|png|gif)$/ )
            && !( lc($ext_old) eq 'mpeg' && $ext_new eq 'mpg' )
            && !( lc($ext_old) eq 'swf'  && $ext_new eq 'cws' ) )
        {
            if ( $basename eq $ext_old ) {
                $basename .= '.' . $ext_new;
                $ext_old = $app->translate('none');
            }
            else {
                $basename =~ s/$ext_old$/$ext_new/;
            }
            $app->param( "changed_file_ext", "$ext_old,$ext_new" );
        }
    }

    # Setup exists/cancel handler
    my $exists_handler = $upload_param{exists_handler} || sub {
        return $eh->(
            $app, %param,
            error => $app->translate(
                "File with name '[_1]' already exists.", $basename
            )
        );
    };
    my $cancel_handler = $upload_param{cancel_handler} || sub {
        start_upload(@_);
    };

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
        $asset_base_url, $relative_url, $extra_path
    );
    my $label = $basename;
    if ( $blog_id = $app->param('blog_id') ) {

        $param{blog_id} = $blog_id;
        $blog = MT->model('blog')->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
        $fmgr = $blog->file_mgr;

        ## Build upload destination path
        my $dest = $app->param('destination');
        my $root_path;
        my $is_sitepath;
        if ( $dest =~ m/^%s/i ) {

            # sitepath
            $root_path   = $blog->site_path;
            $is_sitepath = 1;
        }
        else {
            $root_path   = $blog->archive_path;
            $is_sitepath = 0;
        }
        $dest = MT::Util::build_upload_destination($dest);

        # Make directory if not exists
        $extra_path = $app->param('extra_path') || '';
        if ( $dest ne '' ) {
            $extra_path = File::Spec->catdir( $dest, $extra_path );
        }
        if ($extra_path) {
            if ( $extra_path =~ m!\.\.|\0|\|! ) {
                return $eh->(
                    $app, %param,
                    error => $app->translate(
                        "Invalid upload path '[_1]'", $extra_path
                    )
                );
            }
        }

        my $path = File::Spec->catdir( $root_path, $extra_path );
        ## Untaint. We already checked for security holes in $relative_path.
        ($path) = $path =~ /(.+)/s;
        ## Build out the directory structure if it doesn't exist. DirUmask
        ## determines the permissions of the new directories.
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path)
                or return $eh->(
                $app, %param,
                error => $app->translate(
                    "Cannot make path '[_1]': [_2]",
                    $path, $fmgr->errstr
                )
                );
        }

        # Rename filename automatically, or overwrite, or cancel upload
        {
            my $path_info = {};
            @$path_info{qw(rootPath relativePath basename)}
                = ( $root_path, $extra_path, $basename );
            my $local_file = File::Spec->catfile(
                ( $root_path, $extra_path, $basename ) );

            if ( $fmgr->exists($local_file) ) {
                my $operation_if_exists
                    = $app->param('operation_if_exists') || 0;
                if ( $operation_if_exists == 1 ) {

                    # Auto-rename
                    _rename_filename( $app, $path_info );
                }
                elsif ( $operation_if_exists == 2 ) {

                    # Overwrite, do nothing
                }
                elsif ( $operation_if_exists == 3 ) {

                    # Call cancel handler
                    return $cancel_handler->(
                        $app,
                        site_path  => $root_path,
                        extra_path => $extra_path,
                        fname      => $basename,
                    );
                }
                else {
                    # Call exists handler
                    return $exists_handler->(
                        $app,
                        site_path  => $root_path,
                        extra_path => $extra_path,
                        fname      => $basename,
                    );
                }
            }

            # Rename non-ascii filename automatically if option provided.
            if (   $app->param('auto_rename_non_ascii')
                && $path_info->{basename} =~ m/[^\x20-\x7E]/ )
            {
                # Auto-rename
                _rename_filename( $app, $path_info );
            }

            $app->run_callbacks( $app_id . '_asset_upload_path',
                $app, $fmgr, $path_info );

            ( $root_path, $extra_path, $basename )
                = @$path_info{qw(rootPath relativePath basename)};
        }

        $relative_url
            = File::Spec->catfile( $extra_path, encode_url($basename) );
        $extra_path
            = $extra_path
            ? File::Spec->catfile( $extra_path, $basename )
            : $basename;
        $asset_file = $is_sitepath ? '%r' : '%a';
        $extra_path =~ s/^[\/\\]//;
        $asset_file = File::Spec->catfile( $asset_file, $extra_path );
        $local_file = File::Spec->catfile( $path,       $basename );
        $base_url
            = $is_sitepath
            ? $blog->site_url
            : $blog->archive_url;
        $asset_base_url = $is_sitepath ? '%r' : '%a';

        ## Untaint. We have already tested $basename and $extra_path for security
        ## issues above, and we have to assume that we can trust the user's
        ## Local Archive Path setting. So we should be safe.
        ($local_file) = $local_file =~ /(.+)/s;
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

        # Rename non-ascii filename automatically if option provided.
        my $path_info = { basename => $stem };
        if (   $app->param('auto_rename_non_ascii')
            && $path_info->{basename} =~ m/[^\x20-\x7E]/ )
        {
            # Auto-rename
            _rename_filename( $app, $path_info );
        }
        my $unique_stem = $path_info->{basename};
        $local_file = File::Spec->catfile( $param{support_path},
            $unique_stem . $type );
        if ( $fmgr->exists($local_file) ) {
            my $operation_if_exists = $app->param('operation_if_exists') || 0;
            if ( $operation_if_exists == 1 ) {

                # Auto-rename
                _rename_filename( $app, $path_info );
            }
            elsif ( $operation_if_exists == 2 ) {

                # Overwrite, do nothing
            }
            elsif ( $operation_if_exists == 3 ) {

                # Call cancel handler
                return $cancel_handler->(
                    $app,
                    site_path  => $param{support_path},
                    extra_path => '',
                    fname      => $unique_stem,
                );
            }
            else {
                # Call exists handler
                return $exists_handler->(
                    $app,
                    site_path  => $param{support_path},
                    extra_path => '',
                    fname      => $unique_stem,
                );
            }
        }
        $unique_stem = $path_info->{basename};
        $local_file  = File::Spec->catfile( $param{support_path},
            $unique_stem . $type );

        my $unique_basename = $unique_stem . $type;
        $extra_path   = $unique_basename;
        $relative_url = encode_url($unique_basename);
        $asset_file
            = File::Spec->catfile( '%s', 'uploads', $unique_basename );
    }

    my ( $base, $uploaded_path, $ext )
        = File::Basename::fileparse( $basename, '\.[^\.]*' );

    if ( my $deny_exts = $app->config->DeniedAssetFileExtensions ) {
        my @deny_exts = map {
            if   ( $_ =~ m/^\./ ) {qr/$_(?:\..*)?/i}
            else                  {qr/\.$_(?:\..*)?/i}
        } grep { defined $_ && $_ ne '' } split '\s?,\s?', $deny_exts;
        my @ret = File::Basename::fileparse( $basename, @deny_exts );
        if ( $ret[2] ) {
            return $app->error(
                $app->translate(
                    '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                    $ret[2],
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
                    '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                    $ext,
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

    ## We are going to use $extra_path as the filename and as the url passed
    ## in to the templates. So, we want to replace all of the '\' characters
    ## with '/' characters so that it won't look like backslashed characters.
    ## Also, get rid of a slash at the front, if present.
    $extra_path =~ s!\\!/!g;
    $extra_path =~ s!^/!!;
    $relative_url =~ s!\\!/!g;
    $relative_url =~ s!^/!!;
    my $url = $base_url;
    $url .= '/' unless $url =~ m!/$!;
    $url .= $relative_url;
    my $asset_url = $asset_base_url . '/' . $relative_url;

    require File::Basename;
    my $local_basename = File::Basename::basename($local_file);
    my $local_ext
        = ( File::Basename::fileparse( $local_file, qr/\.[A-Za-z0-9]+$/ ) )
        [2];
    $local_ext =~ s/^\.//;

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
        $asset->file_ext($local_ext);
        $asset->blog_id($blog_id);
        $asset->label($label);
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

        if ( $app->param('normalize_orientation') ) {
            $asset->normalize_orientation;
        }

        # Adjust image quality according to ImageQualityJpeg
        # and ImageQualityPng.
        $asset->change_quality
            if $app->config('AutoChangeImageQuality');

        if ($app->config('ForceExifRemoval')) {
            $asset->remove_all_metadata;
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

sub _rename_filename {
    my ( $app, $path_info ) = @_;

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
    return
        if ( $user->is_superuser
        || $user->permissions(0)->can_do('edit_assets') );
    my $load_blog_ids = $load_options->{blog_ids};

    my $iter = MT->model('permission')->load_iter(
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

sub dialog_edit_asset {
    my $app = shift;

    $app->validate_param({
        blog_id     => [qw/ID/],
        id          => [qw/ID/],
        saved_image => [qw/MAYBE_STRING/],
    }) or return;

    $app->validate_magic() or return;

    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog_id;

    my $id = $app->param('id');
    return $app->return_to_dashboard( redirect => 1 )
        if !$id;

    return $app->permission_denied()
        if $blog_id && !$app->can_do('upload');

    my $asset = MT->model('asset')->load($id)
        or return $app->errtrans( "Cannot load asset #[_1].", $id );

    my $param = {
        blog_id           => $blog_id,
        id                => $id,
        file_name         => $asset->file_name,
        label             => $asset->label,
        description       => $asset->description,
        asset_class_label => $asset->class_label,
        asset_type        => $asset->class,
        class             => $asset->class,
    };

    if ( $asset->isa('MT::Asset::Image') ) {
        $param->{image_width}  = $asset->image_width;
        $param->{image_height} = $asset->image_height;
    }

    if ( $asset->has_thumbnail && $asset->can_create_thumbnail ) {
        my ( $thumb_url, $thumb_w, $thumb_h );
        my $thumb_size = 240;
        my ( $orig_height, $orig_width )
            = ( $asset->image_width, $asset->image_height );
        if ( $orig_width > $thumb_size && $orig_height > $thumb_size ) {
            ( $thumb_url, $thumb_w, $thumb_h ) = $asset->thumbnail_url(
                Height => $thumb_size,
                Width  => $thumb_size,
                Square => 1
            );
        }
        elsif ( $orig_width > $thumb_size ) {
            ( $thumb_url, $thumb_w, $thumb_h )
                = $asset->thumbnail_url( Width => $thumb_size, );
        }
        elsif ( $orig_height > $thumb_size ) {
            ( $thumb_url, $thumb_w, $thumb_h )
                = $asset->thumbnail_url( Height => $thumb_size, );
        }
        else {
            $thumb_url = $asset->url;
            $thumb_w   = $orig_width;
            $thumb_h   = $orig_height;
        }
        $param->{has_thumbnail}    = 1;
        $param->{can_edit_image}   = 1;
        $param->{thumbnail_url}    = $thumb_url;
        $param->{thumbnail_width}  = $thumb_w;
        $param->{thumbnail_height} = $thumb_h;
    }
    else {
        $param->{has_thumbnail} = 0;
    }

    require MT::FileMgr;
    my $fmgr      = MT::FileMgr->new('Local');
    my $file_path = $asset->file_path;
    if ( $file_path && $fmgr->file_size($file_path) ) {
        my $size = $fmgr->file_size($file_path);
        $param->{file_size} = $size;
        if ( $size < 1024 ) {
            $param->{file_size_formatted} = sprintf( "%d Bytes", $size );
        }
        elsif ( $size < 1024000 ) {
            $param->{file_size_formatted}
                = sprintf( "%.1f KB", $size / 1024 );
        }
        else {
            $param->{file_size_formatted}
                = sprintf( "%.1f MB", $size / 1024000 );
        }
    }

    require MT::Tag;
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my $tags = MT::Tag->join( $tag_delim, $asset->tags );
    $param->{tags} = $tags;
    $param->{'auth_pref_tag_delim'} = $tag_delim
        if $tag_delim;

    require MT::ObjectTag;
    my $tags_js = MT::Util::to_json(
        [   map { $_->name } MT->model('tag')->load(
                undef,
                {   join => [
                        'MT::ObjectTag', 'tag_id',
                        { blog_id => $asset->blog_id }, { unique => 1 }
                    ]
                }
            )
        ]
    );
    $tags_js =~ s!/!\\/!g;
    $param->{tags_js} = $tags_js;

    $param->{return_args} = $app->make_return_args;
    $param->{saved_image} = 1
        if $app->param('saved_image');

    $param->{broken_metadata} = $asset->is_metadata_broken;

    $app->load_tmpl( 'dialog/asset_edit.tmpl', $param );
}

sub js_save_asset {
    my $app = shift;

    $app->validate_param({
        blog_id     => [qw/ID/],
        description => [qw/MAYBE_STRING/],
        id          => [qw/ID/],
        label       => [qw/MAYBE_STRING/],
    }) or return $app->json_error($app->errstr);

    $app->validate_magic()
        or return $app->error(
        $app->json_error( $app->translate("Invalid Request.") ) );

    my $blog_id = $app->param('blog_id');
    return $app->error(
        $app->json_error( $app->translate("Invalid Request.") ) )
        if !$blog_id;

    my $id = $app->param('id');
    return $app->error(
        $app->json_error( $app->translate("Invalid Request.") ) )
        if !$id;
    return $app->error(
        $app->json_error( $app->translate("Permission denied.") ) )
        if $blog_id && !$app->can_do('upload');

    my $asset = MT->model('asset')->load($id)
        or return $app->error(
        $app->json_error(
            $app->translate( "Cannot load asset #[_1].", $id )
        )
        );

    return $app->error( $app->json_error( $app->errstr ) )
        unless $app->run_callbacks( 'cms_save_filter.asset', $app );

    my $original = $asset->clone();

    my $label       = $app->param('label');
    my $description = $app->param('description');

    $asset->label($label);
    $asset->description($description);
    $asset->modified_by( $app->user->id ) if $asset->id;

    return $app->error(
        $app->json_error(
            $app->translate( "Save failed: [_1]", $app->errstr )
        )
        )
        unless $app->run_callbacks( 'cms_pre_save.asset', $app, $asset,
        $original );

    $asset->save
        or return $app->error(
        $app->json_error(
            $app->translate( "Saving object failed: [_1]", $asset->errstr )
        )
        );

    return $app->error( $app->json_error( $app->errstr() ) )
        unless $app->run_callbacks( 'cms_post_save.asset', $app, $asset,
        $original );

    return $app->json_result( { success => 1 } );
}

sub dialog_edit_image {
    my ($app) = @_;

    $app->validate_param({
        blog_id     => [qw/ID/],
        id          => [qw/ID/],
        return_args => [qw/MAYBE_STRING/],
    }) or return;

    my $asset;

    my $id = $app->param('id');
    my $blog_id = $app->param('blog_id') || 0;
    if ($id) {
        $asset
            = $app->model('asset')
            ->load( { id => $id, blog_id => $blog_id, class => 'image' } );
    }
    if ( !$asset ) {
        return $app->errtrans('Invalid request.');
    }

    # Check.
    if ( !can_save( undef, $app, $asset ) ) {
        return $app->permission_denied;
    }

    # Retrive data of thumbnail.
    my $param  = {};
    my $hasher = build_asset_hasher($app);
    $hasher->( $asset, $param, ThumbWidth => 400, ThumbHeight => 400 );

    # Disable browser cache for image.
    $param->{modified_on} = $asset->modified_on;

    # Check Exif.
    # Cannot remove metadata when it is broken.
    if ( !$asset->is_metadata_broken ) {
        my $has_metadata = $asset->has_metadata;
        if ( defined $has_metadata ) {
            $param->{has_metadata} = $has_metadata;
        }
        else {
            return $app->error( $asset->errstr );
        }
        if ($has_metadata) {
            my $has_gps_metadata = $asset->has_gps_metadata;
            if ( defined $has_gps_metadata ) {
                $param->{has_gps_metadata} = $has_gps_metadata;
            }
            else {
                return $app->error( $asset->errstr );
            }
        }
    }

    $param->{return_args} = $app->param('return_args') || '';

    $app->load_tmpl( 'dialog/edit_image.tmpl', $param );
}

sub thumbnail_image {
    my ($app) = @_;

    my $id = $app->param('id');
    my $blog_id = $app->param('blog_id') || 0;

    # Thumbnail size on "Edit Image" screen is 240.
    my $width  = $app->param('width')  || 400;
    my $height = $app->param('height') || 400;
    my $square = $app->param('square');

    my $asset;

    if ($id) {
        $asset
            = $app->model('asset')
            ->load( { id => $id, blog_id => $blog_id, class => 'image' } );
    }
    if ( !$asset ) {
        return $app->errtrans('Invalid request.');
    }

    # Check permission.
    if ( !$app->can_do('view_thumbnail_image') ) {
        return $app->permission_denied;
    }

    my ($thumbnail)
        = $asset->thumbnail_file( Width => $width, Height => $height, Square => $square )
        or return $app->error( $asset->errstr );

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    my $data = $fmgr->get_data( $thumbnail, 'upload' );

    $app->{no_print_body} = 1;
    $app->send_http_header( $asset->mime_type );
    $app->print($data);
}

sub transform_image {
    my ($app) = @_;

    $app->validate_param({
        actions             => [qw/MAYBE_STRING/],
        id                  => [qw/ID/],
        remove_all_metadata => [qw/MAYBE_STRING/],
        remove_gps_metadata => [qw/MAYBE_STRING/],
        return_args         => [qw/MAYBE_STRING/],
    }) or return;

    if ( !$app->validate_magic ) {
        return;
    }

    # Load image.
    my $id = $app->param('id');
    my $asset = $app->model('asset')->load( { id => $id, class => 'image' } )
        or return $app->errtrans('Invalid request.');

    if ( !can_save( undef, $app, $asset ) ) {
        return $app->permission_denied;
    }

    # Parse JSON.
    my $actions = $app->param('actions');
    $actions =~ s/^"|"$//g;
    $actions =~ s/\\//g;
    $actions = eval { MT::Util::from_json($actions) };
    if ( !$actions || ref $actions ne 'ARRAY' ) {
        return $app->errtrans('Invalid request.');
    }

    $asset->transform(@$actions)
        or return $app->errtrans( 'Transforming image failed: [_1]',
        $asset->errstr );

    if ( $app->param('remove_all_metadata') ) {
        $asset->remove_all_metadata
            or return $app->error( $asset->errstr );
    }
    elsif ( $app->param('remove_gps_metadata') ) {
        $asset->remove_gps_metadata
            or return $app->error( $asset->errstr );
    }

    if ( $app->param('return_args') ) {
        $app->add_return_arg( 'saved_image' => 1 );
        $app->call_return;
    }
    else {
        $app->redirect(
            $app->uri(
                mode => 'view',
                args => {
                    _type       => 'asset',
                    blog_id     => $app->blog ? $app->blog->id : 0,
                    id          => $id,
                    saved_image => 1,
                },
            )
        );
    }
}

sub dialog_asset_modal {
    my $app = shift;

    $app->validate_param({
        asset_select     => [qw/MAYBE_STRING/],
        blog_id          => [qw/ID/],
        can_multi        => [qw/MAYBE_STRING/],
        content_field_id => [qw/ID/],
        edit_field       => [qw/MAYBE_STRING/],
        filter           => [qw/MAYBE_STRING/],
        filter_val       => [qw/MAYBE_STRING/],
        next_mode        => [qw/MAYBE_STRING/],
        no_insert        => [qw/MAYBE_STRING/],
        require_type     => [qw/MAYBE_STRING/],
        search           => [qw/MAYBE_STRING/],
        upload_mode      => [qw/MAYBE_STRING/],
    }) or return;

    my $blog_id = $app->param('blog_id');
    my $mode_userpic = $app->param('upload_mode') || '';
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog_id && $mode_userpic ne 'upload_userpic';

    my $blog_class = $app->model('blog');
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;

    my %param;
    _set_start_upload_params( $app, \%param );

    return $app->permission_denied()
        if $blog_id && !$app->can_do('access_to_insert_asset_list');

    $param{can_multi} = 1
        if ( $app->param('upload_mode') || '' ) ne 'upload_userpic'
        && $app->param('can_multi');

    $param{filter} = $app->param('filter')
        if defined $app->param('filter');
    $param{filter_val} = $app->param('filter_val')
        if defined $app->param('filter_val');
    $param{search} = $app->param('search') if defined $app->param('search');
    $param{edit_field} = $app->param('edit_field')
        if defined $app->param('edit_field');
    $param{next_mode}    = $app->param('next_mode');
    $param{no_insert}    = $app->param('no_insert') ? 1 : 0;
    $param{asset_select} = $app->param('asset_select');
    $param{require_type} = $app->param('require_type');

    if ($blog_id) {
        $param{blog_id}      = $blog_id;
        $param{edit_blog_id} = $blog_id,;
    }

    $param{upload_mode} = $mode_userpic;
    if ($mode_userpic) {
        $param{user_id}      = $param{filter_val} || $app->user->id;
        $param{require_type} = 'image';
        $param{'is_image'}   = 1;
        $param{can_upload}   = 1;
    }

    if ( $param{require_type} ) {
        my $req_class = $app->model( $param{require_type} );
        $param{require_type_label} = $req_class->class_label;
    }

    require MT::Asset;
    my $subclasses = MT::Asset->list_subclasses;

    my @class_filters;
    foreach my $k (@$subclasses) {
        my $c = $k->{class};
        push @class_filters,
            {
            key   => $k->{type},
            label => $c->class_label_plural,
            };
    }
    $param{class_filter_loop} = \@class_filters if @class_filters;

    # Set directory separator
    $param{dir_separator} = MT::Util::dir_separator;

    if ( my $content_field_id = $app->param('content_field_id') ) {
        require MT::ContentField;
        if ( my $content_field = MT::ContentField->load($content_field_id) ) {
            $param{content_field_id} = $content_field_id;
            my $options = $content_field->options;
            $param{can_multi}  = $options->{multiple}     ? 1 : 0;
            $param{can_upload} = $options->{allow_upload} ? 1 : 0;
        }
    }

    $app->load_tmpl( 'dialog/asset_modal.tmpl', \%param );
}

sub dialog_insert_options {
    my $app    = shift;
    my (%args) = @_;
    my $assets = $args{assets};

    $app->validate_param({
        asset_select        => [qw/MAYBE_STRING/],
        blog_id             => [qw/ID/],
        content_field_id    => [qw/ID/],
        direct_asset_insert => [qw/MAYBE_STRING/],
        edit_field          => [qw/MAYBE_STRING/],
        id                  => [qw/IDS/],
        no_insert           => [qw/MAYBE_STRING/],
    }) or return;

    # Validate magic token
    $app->validate_magic() or return;

    # Load assets
    if ( !$assets ) {
        my $ids = $app->param('id');
        return $app->errtrans('Invalid request.') unless $ids;

        my @ids = split ',', $ids;
        return $app->errtrans('Invalid request.') unless @ids;
        my @assets = $app->model('asset')->load( { id => \@ids } );

        # Sort by @ids order.
        my %assets = map { $_->id => $_ } @assets;
        @assets = map { $assets{$_} } @ids;

        $assets = \@assets;
    }
    $assets = [$assets] if 'ARRAY' ne ref $assets;

    # Should not allow to insert asset from other site.
    my $blog_id = $app->param('blog_id');
    my $blog    = MT->model('blog')->load($blog_id)
        or return $app->errtrans( "Cannot load blog #[_1].", $blog_id );
    my %blog_ids;
    if ( !$blog->is_blog ) {
        %blog_ids = map { $_->id => 1 } @{ $blog->blogs };
    }
    $blog_ids{$blog_id} = 1;
    foreach my $a (@$assets) {
        return $app->errtrans('Invalid request.')
            unless defined $blog_ids{ $a->blog_id };
    }

    # If no_insert option provided, should not displaying insert option
    if ( $app->param('no_insert') || $app->param('direct_asset_insert') ) {
        return insert_asset( $app, { assets => $assets } );
    }

    # Permission check
    my $perms = $app->permissions
        or return $app->errtrans('No permissions');
    return $app->errtrans('No permissions')
        unless $perms->can_do('insert_asset');

    # Make a insert option loop
    my $options_loop;
    foreach my $a (@$assets) {
        my $thumb_type
            = $a->class_type eq 'file'  ? 'default'
            : $a->class_type eq 'video' ? 'movie'
            :                             $a->class_type;
        my $param = {
            id        => $a->id,
            filename  => $a->file_name,
            url       => $a->url,
            label     => $a->label,
            thumbnail => _make_thumbnail_url(
                $a, { size => $default_thumbnail_size }
            ),
            thumbnail_type => $thumb_type,
            class_label    => $a->class_label,
        };
        my $html = $a->insert_options($param) || '';
        $param->{options} = $html;
        push @$options_loop, $param;
    }

    my %param;
    $param{options_loop} = $options_loop;
    $param{edit_field}   = $app->param('edit_field');
    $param{new_entry}    = $app->param('asset_select') ? 0 : 1;

    $app->load_tmpl( 'dialog/multi_asset_options.tmpl', \%param );
}

sub insert_asset {
    my $app = shift;
    my ($param) = @_;

    $app->validate_magic() or return;

    $app->validate_param({
        content_field_id    => [qw/ID/],
        direct_asset_insert => [qw/MAYBE_STRING/],
        edit_field          => [qw/MAYBE_STRING/],
        new_entry           => [qw/MAYBE_STRING/],
        no_insert           => [qw/MAYBE_STRING/],
        prefs_json          => [qw/MAYBE_STRING/],
    }) or return;

    my $edit_field = $app->param('edit_field') || '';
    return $app->permission_denied()
        unless $app->can_do('insert_asset');

    require MT::Asset;
    my $text;
    my $assets;
    if ( $app->param('no_insert') ) {
        $text   = '';
        $assets = $param->{assets};
    }
    elsif ( $app->param('direct_asset_insert') ) {
        $assets = $param->{assets};
        foreach my $a (@$assets) {
            my %param;
            $param{wrap_text} = 1;
            $param{new_entry} = $app->param('new_entry') ? 1 : 0;

            $a->on_upload( \%param );
            $param{enclose} = $edit_field =~ /^customfield/ ? 1 : 0;
            my $html = $a->as_html( \%param );
            return $app->error( $a->error ) unless defined $html;

            $text .= $html;
        }
    }
    else {
        # Parse JSON.
        my $prefs = $app->param('prefs_json');
        if (MT->config->UseMTCommonJSON) {
            $prefs =~ s/^"|"$//g;
            $prefs =~ s/\\"/"/g;
            $prefs =~ s/\\\\/\\/g;
        }
        $prefs = eval { MT::Util::from_json($prefs) };
        if ( !$prefs ) {
            return $app->errtrans('Invalid request.');
        }

        foreach my $item (@$prefs) {
            my $id = $item->{id};
            return $app->errtrans('Invalid request.')
                unless $id;
            my $asset = MT->model('asset')->load($id)
                or return $app->errtrans( 'Cannot load asset #[_1]', $id );
            my %param;
            foreach my $k ( keys %$item ) {
                my $name = $k;
                if ( $k =~ m/(.*)[-|_]$id/ig ) {
                    $name = $1;
                }
                $param{$name} = $item->{$k};
            }
            $param{wrap_text} = 1;
            $param{new_entry} = $app->param('new_entry') ? 1 : 0;

            $asset->on_upload( \%param );
            $param{enclose} = $edit_field =~ /^customfield/ ? 1 : 0;
            my $html = $asset->as_html( \%param );
            return $app->error( $asset->error ) unless defined $html;

            $text .= $html;
            push @$assets, $asset;
        }
    }

    my $can_multi;
    my $content_field_id = $app->param('content_field_id');
    my $options;
    if ($content_field_id) {
        require MT::ContentField;
        if ( my $content_field = MT::ContentField->load($content_field_id) ) {
            $options = $content_field->options;
            $can_multi = $options->{multiple} ? 1 : 0;
        }
        else {
            $content_field_id = undef;
        }
    }

    if ($content_field_id) {
        my @assets_data;
        my $hasher = build_asset_hasher(
            $app,
            PreviewWidth  => $options->{preview_width} || 80,
            PreviewHeight => $options->{preview_height} || 80,
        );
        for my $obj (@$assets) {
            my $row = $obj->get_values;
            $hasher->( $obj, $row );
            push @assets_data,
                {
                asset_dimensions     => $row->{'Actual Dimensions'},
                asset_file_name      => $row->{file_name},
                asset_id             => $row->{id},
                asset_label          => $row->{label},
                asset_preview_url    => $row->{preview_url},
                asset_preview_height => $row->{preview_height},
                asset_preview_width  => $row->{preview_width},
                asset_type           => $row->{class},
                };
        }
        return $app->load_tmpl(
            'dialog/asset_field_insert.tmpl',
            {   assets           => \@assets_data,
                can_multi        => $can_multi,
                content_field_id => $content_field_id,
            }
        );
    }
    else {
        my $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {   upload_html => $text || '',
                edit_field => $edit_field,
            },
        );
        my $ctx = $tmpl->context;
        $ctx->stash( 'assets', $assets );
        return $tmpl;
    }
}

sub _make_thumbnail_url {
    my $asset = shift;
    my ($param) = @_;
    my $thumb_url;
    my $thumb_size
        = $param && $param->{size} ? $param->{size} : $default_thumbnail_size;

    if ( $asset->has_thumbnail && $asset->can_create_thumbnail ) {
        my ( $orig_height, $orig_width )
            = ( $asset->image_width, $asset->image_height );
        if ( $orig_width > $thumb_size && $orig_height > $thumb_size ) {
            ($thumb_url) = $asset->thumbnail_url(
                Height => $thumb_size,
                Width  => $thumb_size,
                Square => 1
            );
        }
        elsif ( $orig_width > $thumb_size ) {
            ($thumb_url) = $asset->thumbnail_url( Width => $thumb_size, );
        }
        elsif ( $orig_height > $thumb_size ) {
            ($thumb_url) = $asset->thumbnail_url( Height => $thumb_size, );
        }
        else {
            $thumb_url = $asset->url;
        }
    }

    return $thumb_url;
}
1;
