package MT::CMS::Asset;

use strict;
use Symbol;
use MT::Util qw( epoch2ts encode_url format_ts relative_date );

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    if ($id) {
        my $asset_class = $app->model('asset');
        $param->{asset} = $obj;
        $param->{search_label} = $app->translate('Assets');

        my $hasher = build_asset_hasher($app);
        $hasher->($obj, $param, ThumbWidth => 240, ThumbHeight => 240);

        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        require MT::Tag;
        my $tags = MT::Tag->join( $tag_delim, $obj->tags );
        $param->{tags} = $tags;

        my @related;
        if ($obj->parent) {
            my $parent = $asset_class->load($obj->parent);
            push @related, $hasher->($parent, { asset => $parent, is_parent => 1 });

            push @related, map { $hasher->($_, { asset => $_, is_sibling => 1 }) }
                $asset_class->search({
                    id     => { op => '!=', value => $obj->id },
                    class  => '*',
                    parent => $obj->parent
                });
        }
        push @related, map { $hasher->($_, { asset => $_, is_child => 1 }) }
            $asset_class->search({
                class  => '*',
                parent => $obj->id,
            });
        $param->{related} = \@related if @related;

        my @appears_in;
        my $place_class = $app->model('objectasset');
        my $place_iter = $place_class->load_iter(
            {
                blog_id => $obj->blog_id || 0,
                asset_id => $obj->parent ? $obj->parent : $obj->id
            }
        );
        while (my $place = $place_iter->()) {
            my $entry_class = $app->model($place->object_ds) or next;
            next unless $entry_class->isa('MT::Entry');
            my $entry = $entry_class->load($place->object_id)
                or next;
            my %entry_data = (
                id    => $place->object_id,
                class => $entry->class_type,
                entry => $entry,
                title => $entry->title,
            );
            if (my $ts = $entry->authored_on) {
                $entry_data{authored_on_ts} = $ts;
                $entry_data{authored_on_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
            if (my $ts = $entry->created_on) {
                $entry_data{created_on_ts} = $ts;
                $entry_data{created_on_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, undef,
                    $app->user ? $app->user->preferred_language : undef );
            }
            push @appears_in, \%entry_data;
        }
        if (11 == @appears_in) {    
            pop @appears_in;
            $param->{appears_in_more} = 1;
        }
        $param->{appears_in} = \@appears_in if @appears_in;

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
    }
    1;
}

sub list {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $blog;
    if ($blog_id) {
        my $blog_class = $app->model('blog');
        $blog = $blog_class->load($blog_id)
          or return $app->errtrans("Invalid request.");
        my $perms = $app->permissions;
        return $app->errtrans("Permission denied.")
          unless $app->user->is_superuser
          || (
            $perms
            && (   $perms->can_edit_assets
                || $perms->can_edit_all_posts
                || $perms->can_create_post )
          );
    }

    my $asset_class = $app->model('asset') or return;
    my %terms;
    my %args = ( sort => 'created_on', direction => 'descend' );

    my $class_filter;
    my $filter = ( $app->param('filter') || '' );
    if ( $filter eq 'class' ) {
        $class_filter = $app->param('filter_val');
    }
    elsif ($filter eq 'userpic') {
        $class_filter = 'image';
        $terms{created_by} = $app->param('filter_val');

        my $tag = MT::Tag->load( { name => '@userpic' },
            { binary => { name => 1 } } );
        if ($tag) {
            require MT::ObjectTag;
            $args{'join'} = MT::ObjectTag->join_on(
                'object_id',
                {
                    tag_id            => $tag->id,
                    object_datasource => MT::Asset->datasource
                },
                { unique => 1 }
            );
        }
    }

    $app->add_breadcrumb( $app->translate("Files") );
    if ($blog_id) {
        $terms{blog_id} = $blog_id;
    }
    else {
        unless ( $app->user->is_superuser ) {
            my @perms = MT::Permission->load( { author_id => $app->user->id } );
            my @blog_ids;
            push @blog_ids, $_->blog_id
              foreach grep { $_->can_edit_assets } @perms;
            $terms{blog_id} = @blog_ids ? \@blog_ids : 0;
        }
    }

    my $hasher = build_asset_hasher( $app,
        PreviewWidth => 240, PreviewHeight => 240 );

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
    @class_loop = sort { $a->{class_label} cmp $b->{class_label} } @class_loop;

    my $dialog_view = $app->param('dialog_view') ? 1 : 0;
    my $no_insert = $app->param('no_insert') ? 1 : 0;
    my $perms = $app->permissions;
    my %carry_params = map { $_ => $app->param($_) || '' }
        (qw( edit_field upload_mode require_type next_mode asset_select ));
    $carry_params{'user_id'} = $app->param('filter_val')
        if $filter eq 'userpic';
    _set_start_upload_params($app, \%carry_params);
    $app->listing(
        {
            terms    => \%terms,
            args     => \%args,
            type     => 'asset',
            code     => $hasher,
            template => $dialog_view
            ? 'dialog/asset_list.tmpl'
            : '',
            params => {
                (
                    $blog
                    ? (
                        blog_id   => $blog_id,
                        blog_name => $blog->name
                          || '',
                        edit_blog_id => $blog_id,
                      )
                    : (),
                ),
                is_image         => defined $class_filter
                  && $class_filter eq 'image' ? 1 : 0,
                dialog_view      => $dialog_view,
                no_insert        => $no_insert,
                search_label     => MT::Asset->class_label_plural,
                search_type      => 'asset',
                class_loop       => \@class_loop,
                can_delete_files => (
                    $perms ? $perms->can_edit_assets : $app->user->is_superuser
                ),
                nav_assets       => 1,
                panel_searchable => 1,
                object_type      => 'asset',
                %carry_params,
            },
        }
    );
}

sub insert {
    my $app  = shift;
    my $text = $app->param('no_insert') ? "" : _process_post_upload( $app );
    return unless defined $text;
    my $file_ext_changes = $app->param('changed_file_ext');
    my ($ext_from, $ext_to) = split(",", $file_ext_changes) if $file_ext_changes;
    my $extension_message = $app->translate("Extension changed from [_1] to [_2]", $ext_from, $ext_to) if ($ext_from && $ext_to);
    my $tmpl;
    if ($extension_message) {
        $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {
                upload_html => $text || '',
                edit_field => scalar $app->param('edit_field') || '',
                extension_message => $extension_message,
            },
        );
    } else {
       $tmpl = $app->load_tmpl(
            'dialog/asset_insert.tmpl',
            {
                upload_html => $text || '',
                edit_field => scalar $app->param('edit_field') || '',
            },
        );
    }
    my $ctx = $tmpl->context;
    my $id = $app->param('id') or return $app->errtrans("Invalid request.");
    my $asset = MT::Asset->load( $id );
    $ctx->stash('asset', $asset);
    return $tmpl;
}

sub asset_userpic {
    my $app = shift;
    my ($param) = @_;

    my ($id, $asset);
    if ($asset = $param->{asset}) {
        $id = $asset->id;
    }
    else {
        $id = $param->{asset_id} || scalar $app->param('id');
        $asset = $app->model('asset')->lookup($id);
    }

    my $thumb_html = $app->model('author')->userpic_html( Asset => $asset );

    my $user_id = $param->{user_id} || $app->param('user_id');
    if ($user_id) {
        my $user = $app->model('author')->load( {id => $user_id} );
        if ($user) {
            # Delete the author's userpic thumb (if any); it'll be regenerated.
            if ($user->userpic_asset_id != $asset->id) {
                my $old_file = $user->userpic_file();
                my $fmgr = MT::FileMgr->new('Local');
                if ($fmgr->exists($old_file)) {
                    $fmgr->delete($old_file);
                }
                $user->userpic_asset_id($asset->id);
                $user->save;
            }
        }
    }

    $app->load_tmpl(
        'dialog/asset_userpic.tmpl',
        {
            asset_id       => $id,
            edit_field     => $app->param('edit_field') || '',
            author_userpic => $thumb_html,
        },
    );
}

sub start_upload {
    my $app = shift;
    $app->add_breadcrumb( $app->translate('Upload File') );
    my %param;
    %param = @_ if @_;

    _set_start_upload_params($app, \%param);

    for my $field (qw( entry_insert edit_field upload_mode require_type
      asset_select )) {
        $param{$field} ||= $app->param($field);
    }

    $app->load_tmpl( 'dialog/asset_upload.tmpl', \%param );
}

sub upload_file {
    my $app = shift;

    my ($asset, $bytes) = _upload_file( $app,
        require_type => ($app->param('require_type') || ''),
        @_,
    );
    return if !defined $asset;
    return $asset if !defined $bytes;  # whatever it is

    complete_insert( $app,
        asset => $asset,
        bytes => $bytes,
    );
}

sub complete_insert {
    my $app = shift;
    my (%args) = @_;
    my $asset = $args{asset};
    if ( !$asset && $app->param('id') ) {
        require MT::Asset;
        $asset = MT::Asset->load( $app->param('id') )
          || return $app->errtrans( "Can't load file #[_1].",
            $app->param('id') );
    }
    return $app->errtrans('Invalid request.') unless $asset;

    $args{is_image} = $asset->isa('MT::Asset::Image') ? 1 : 0 unless defined $args{is_image};

    require MT::Blog;
    my $blog = $asset->blog
      or
      return $app->errtrans( "Can't load blog #[_1].", $app->param('blog_id') );
    my $perms = $app->permissions
      or return $app->errtrans('No permissions');

    # caller wants asset without any option step, so insert immediately
    if ($app->param('asset_select') || $app->param('no_insert')) {
        $app->param( 'id', $asset->id );
        return insert($app);
    }
    
    my $param = {
        asset_id            => $asset->id,
        bytes               => $args{bytes},
        fname               => $asset->file_name,
        is_image            => $args{is_image} || 0,
        url                 => $asset->url,
        middle_path         => $app->param('middle_path') || '',
        extra_path          => $app->param('extra_path') || '',
    };
    for my $field (qw( direct_asset_insert edit_field entry_insert site_path asset_select )) {
        $param->{$field} = scalar $app->param($field) || '';
    }
    if ( $args{is_image} ) {
        $param->{width}  = $asset->image_width;
        $param->{height} = $asset->image_height;
    } if ($app->param('changed_file_ext')) {
        my ($ext_from, $ext_to) = split(",", $app->param('changed_file_ext'));
        $param->{extension_message} = $app->translate("Extension changed from [_1] to [_2]", $ext_from, $ext_to) if ($ext_from && $ext_to);
    }
    if ( !$app->param('asset_select') && ($perms->can_create_post || $app->user->is_superuser) ) {
        my $html = $asset->insert_options($param);
        if ( $param->{direct_asset_insert} && !$html ) {
            $app->param( 'id', $asset->id );
            return insert($app);
        }
        $param->{options_snippet} = $html;
    }
    if ($perms) {
        my $pref_param = $app->load_entry_prefs( $perms->entry_prefs );
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
        $param->{tags_js} = MT::Util::to_json( MT::Tag->cache( blog_id => $blog_id, class => 'MT::Asset', private => 1 ) );
    }
    $param->{'no_insert'} = $app->param('no_insert');
    $app->load_tmpl( 'dialog/asset_options.tmpl', $param );
}

sub complete_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
      or return $app->errtrans("Invalid request.");
    $asset->label( $param{label} )             if $param{label};
    $asset->description( $param{description} ) if $param{description};
    if ( $param{tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $param{tags} );
        $asset->set_tags(@tags);
    }
    $asset->save();
    $asset->on_upload( \%param );

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
        unless $app->user->is_superuser
        || (
            $perms
            && (   $perms->can_edit_assets
                || $perms->can_edit_all_posts
                || $perms->can_create_post )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'list_assets',
            args   => { 'blog_id' => $app->param('blog_id') }
        )
    );
}

sub start_upload_entry {
    my $app = shift;
    my $q   = $app->param;
    $q->param( '_type', 'entry' );
    defined( my $text = _process_post_upload($app) ) or return;
    $q->param( 'text', $text );
    $q->param ('asset_id', $q->param('id'));
    $q->param( 'id', 0 );
    $app->param( 'tags', '' );
    $app->forward("view");
}

sub can_view {
    my ($eh, $app, $id) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_assets();
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return $perms && $perms->can_edit_assets();
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog = $app->blog;
        my $fields = $blog ? $blog->smart_replace_fields
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
            {
                message => $app->translate(
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
        {
            message => $app->translate(
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
    my ($cb, $app, $param, $tmpl) = @_;
    my $asset = $param->{asset} or return;
    $asset->edit_template_param(@_);
}

sub asset_list_filters {
    my $app = shift;

    my %filters;
    my $types = MT::Asset->class_labels;
    foreach my $type ( keys %$types ) {
        my $asset_type = $type;
        $asset_type =~ s/^asset\.//;
        $filters{$asset_type} = {
            label   => sub { MT::Asset->class_handler($type)->class_label_plural },
            handler => sub {
                my ( $terms, $args ) = @_;
                $terms->{class} = $asset_type eq 'asset' ? '*' : $asset_type;
            },
        };
    }
    my @types =
      sort { $filters{$a}{label} cmp $filters{$b}{label} } keys %filters;
    my $order = 100;
    foreach (@types) {
        $filters{$_}{order} = $order;
        $order += 100;
    }
    $filters{'asset'}{order} = 0;
    $filters{'asset'}{label} = "All Assets"; # labels are translated later
                                             # translate("All Assets");
    return \%filters;
}

sub build_asset_hasher {
    my $app = shift;
    my (%param) = @_;
    my ($default_thumb_width, $default_thumb_height, $default_preview_width,
        $default_preview_height) =
        @param{qw( ThumbWidth ThumbHeight PreviewWidth PreviewHeight )};

    require File::Basename;
    require JSON;
    my %blogs;
    return sub {
        my ( $obj, $row, %param ) = @_;
        my ($thumb_width, $thumb_height) = @param{qw( ThumbWidth ThumbHeight )};
        $row->{id} = $obj->id;
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        $row->{blog_name} = $blog ? $blog->name : '-';
        $row->{url} = $obj->url; # this has to be called to calculate
        $row->{asset_type} = $obj->class_type;
        $row->{asset_class_label} = $obj->class_label;
        my $file_path = $obj->file_path; # has to be called to calculate
        my $meta = $obj->metadata;
        if ( $file_path && ( -f $file_path ) ) {
            $row->{file_path} = $file_path;
            $row->{file_name} = File::Basename::basename( $file_path );
            my @stat = stat( $file_path );
            my $size = $stat[7];
            $row->{file_size} = $size;
            if ( $size < 1024 ) {
                $row->{file_size_formatted} = sprintf( "%d Bytes", $size );
            }
            elsif ( $size < 1024000 ) {
                $row->{file_size_formatted} =
                  sprintf( "%.1f KB", $size / 1024 );
            }
            else {
                $row->{file_size_formatted} =
                  sprintf( "%.1f MB", $size / 1024000 );
            }
            $meta->{'file_size'} = $row->{file_size_formatted};
        }
        else {
            $row->{file_is_missing} = 1 if $file_path;
        }
        $row->{file_label} = $row->{label} = $obj->label || $row->{file_name} || $app->translate('Untitled');

        if ($obj->has_thumbnail) { 
            $row->{has_thumbnail} = 1;
            my $height = $thumb_height || $default_thumb_height || 75;
            my $width  = $thumb_width  || $default_thumb_width  || 75;
            @$meta{qw( thumbnail_url thumbnail_width thumbnail_height )}
              = $obj->thumbnail_url( Height => $height, Width => $width );

            $meta->{thumbnail_width_offset}  = int(($width  - $meta->{thumbnail_width})  / 2);
            $meta->{thumbnail_height_offset} = int(($height - $meta->{thumbnail_height}) / 2);

            if ($default_preview_width && $default_preview_height) {
                @$meta{qw( preview_url preview_width preview_height )}
                  = $obj->thumbnail_url(
                    Height => $default_preview_height,
                    Width  => $default_preview_width,
                );
                $meta->{preview_width_offset}  = int(($default_preview_width  - $meta->{preview_width})  / 2);
                $meta->{preview_height_offset} = int(($default_preview_height - $meta->{preview_height}) / 2);
            }
        }
        else {
            $row->{has_thumbnail} = 0;
        }

        my $ts = $obj->created_on;
        if ( my $by = $obj->created_by ) {
            my $user = MT::Author->load($by);
            $row->{created_by} = $user ? $user->name : '';
        }
        if ($ts) {
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_TIMESTAMP_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }

        @$row{keys %$meta} = values %$meta;
        $row->{metadata_json} = MT::Util::to_json($meta);
        $row;
    };
}

sub build_asset_table {
    my $app = shift;
    my (%args) = @_;

    my $asset_class = $app->model('asset') or return;
    my $perms     = $app->permissions;
    my $list_pref = $app->list_pref('asset');
    my $limit     = $args{limit};
    my $param     = $args{param} || {};
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
        $hasher->($obj, $row);
        $row->{object} = $obj;
        push @data, $row;
        last if $limit and @data > $limit;
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'asset';
    $app->load_list_actions( 'asset', $param );
    $param->{object_loop} = \@data;
    $param->{can_delete_files} = 1
        if (($perms && $perms->can_edit_assets) || $app->user->is_superuser);
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
      or return $app->errtrans( "Can't load file #[_1].", $id );
    return $asset->as_html($param);
}

sub _process_post_upload {
    my $app   = shift;
    my %param = $app->param_hash;
    my $asset;
    require MT::Asset;
    $param{id} && ( $asset = MT::Asset->load( $param{id} ) )
      or return $app->errtrans("Invalid request.");
    $asset->label( $param{label} )             if $param{label};
    $asset->description( $param{description} ) if $param{description};
    if ( $param{tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $param{tags} );
        $asset->set_tags(@tags);
    }
    $asset->save();

    $asset->on_upload( \%param );
    return asset_insert_text( $app, \%param );
}

# FIXME: need to make this work
sub save {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;
    my $type  = $q->param('_type');
    my $class = $app->model($type)
      or return $app->errtrans("Invalid request.");

    $app->validate_magic() or return;

    return $app->errtrans("Permission denied.")
      unless $perms && $perms->can_edit_assets;

    my $blog_id = $q->param('blog_id');
    my $id = $q->param('id');
    my $obj = $id ? $class->load($id) : $class->new;
    return unless $obj;
    my $original = $obj->clone();

    $obj->set_values_from_query($q);

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $original )
      || return $app->errtrans( "Saving [_1] failed: [_2]", $type,
        $app->errstr );

    $obj->save
      or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $type, $obj->errstr
        )
      );

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $original );

    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                _type   => $type,
                blog_id => $blog_id,
                id      => $obj->id,
                saved   => 1,
            }
        )
    );
}

sub _set_start_upload_params {
    my $app = shift;
    my ($param) = @_;

    if (my $perms = $app->permissions) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_upload;
        my $blog_id = $app->param('blog_id');
        require MT::Blog;
        my $blog = MT::Blog->load($blog_id)
            or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));

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
        $param->{missing_paths} =
          (      ( defined $blog->site_path || defined $blog->archive_path )
              && ( -d $blog->site_path || -d $blog->archive_path ) ) ? 0 : 1;

        if ( $param->{missing_paths} ) {
            if (
                $app->user->is_superuser
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
        my $top_cat = -1;
        my $cat_tree = [{
            id    => -1,
            label => '/',
            basename => '/',
            path  => [],
        }];
        foreach (@$data) {
            next unless exists $_->{category_id};
            $_->{category_path_ids} ||= [];
            unshift @{ $_->{category_path_ids} }, -1;
            push @$cat_tree,
              {
                id => $_->{category_id},
                label => $_->{category_label} . '/',
                basename => $_->{category_basename} . '/',
                path => $_->{category_path_ids} || [],
              };
        }
        $param->{category_tree} = $cat_tree;
    }
    else {
        $param->{local_site_path}      = '';
        $param->{local_archive_path}   = '';
    }

    $param;
}

sub _upload_file {
    my $app = shift;
    my (%upload_param) = @_;
    require MT::Image;

    if (my $perms = $app->permissions) {
        return $app->error( $app->translate("Permission denied.") )
          unless $perms->can_upload;
    }

    $app->validate_magic() or return;

    my $q = $app->param;
    my ($fh, $info) = $app->upload_info('file');
    my $mimetype;
    if ($info) {
        $mimetype = $info->{'Content-Type'};
    }
    my $has_overwrite = $q->param('overwrite_yes') || $q->param('overwrite_no');
    my %param = (
        entry_insert => $q->param('entry_insert'),
        middle_path  => $q->param('middle_path'),
        edit_field   => $q->param('edit_field'),
        site_path    => $q->param('site_path'),
        extra_path   => $q->param('extra_path'),
        upload_mode  => $app->mode,
    );
    return start_upload( $app, %param,
        error => $app->translate("Please select a file to upload.") )
      if !$fh && !$has_overwrite;
    my $basename = $q->param('file') || $q->param('fname');
    $basename =~ s!\\!/!g;    ## Change backslashes to forward slashes
    $basename =~ s!^.*/!!;    ## Get rid of full directory paths
    if ( $basename =~ m!\.\.|\0|\|! ) {
        return start_upload( $app, %param,
            error => $app->translate( "Invalid filename '[_1]'", $basename ) );
    }

    if (my $asset_type = $upload_param{require_type}) {
        require MT::Asset;
        my $asset_pkg = MT::Asset->handler_for_file($basename);

        my %settings_for = (
            audio => {
                class => 'MT::Asset::Audio',
                error => $app->translate( "Please select an audio file to upload." ),
            },
            image => {
                class => 'MT::Asset::Image',
                error => $app->translate( "Please select an image to upload." ),
            },
            video => {
                class => 'MT::Asset::Video',
                error => $app->translate( "Please select a video to upload." ),
            },
        );

        if (my $settings = $settings_for{$asset_type}) {
            return start_upload( $app, %param, error => $settings->{error} )
                if !$asset_pkg->isa($settings->{class});
        }
    }

    my ($blog_id, $blog, $fmgr, $local_file, $asset_file, $base_url,
      $asset_base_url, $relative_url, $relative_path);
    if ($blog_id = $q->param('blog_id')) {
        $param{blog_id} = $blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id)
            or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
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
                "Before you can upload a file, you need to publish your blog."
            )
        ) unless -d $root_path;
        $relative_path = $q->param('extra_path');
        $middle_path = $q->param('middle_path') || '';
        my $relative_path_save = $relative_path;
        if ( $middle_path ne '' ) {
            $relative_path =
              $middle_path . ( $relative_path ? '/' . $relative_path : '' );
        }
        my $path = $root_path;
        if ($relative_path) {
            if ( $relative_path =~ m!\.\.|\0|\|! ) {
                return start_upload( $app,
                    %param,
                    error => $app->translate(
                        "Invalid extra path '[_1]'", $relative_path
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
                  or return start_upload( $app,
                    %param,
                    error => $app->translate(
                        "Can't make path '[_1]': [_2]",
                        $path, $fmgr->errstr
                    )
                  );
            }
        }
        $relative_url =
          File::Spec->catfile( $relative_path, encode_url($basename) );
        $relative_path = $relative_path
          ? File::Spec->catfile( $relative_path, $basename )
          : $basename;
        $asset_file = $q->param('site_path') ? '%r' : '%a';
        $asset_file = File::Spec->catfile( $asset_file, $relative_path );
        $local_file = File::Spec->catfile( $path, $basename );
        $base_url = $app->param('site_path') ? $blog->site_url
          : $blog->archive_url;
        $asset_base_url = $app->param('site_path') ? '%r' : '%a';

        ## Untaint. We have already tested $basename and $relative_path for security
        ## issues above, and we have to assume that we can trust the user's
        ## Local Archive Path setting. So we should be safe.
        ($local_file) = $local_file =~ /(.+)/s;

        my $real_fh;
        unless ($has_overwrite) {
            my ($w_temp, $h_temp, $ext_temp, $write_file_temp) = MT::Image->check_upload(
                Fh => $fh, Fmgr => $fmgr, Local => $local_file,
                Max => $upload_param{max_size},
                MaxDim => $upload_param{max_image_dimension}
            );
            if ($w_temp && $h_temp && $ext_temp) {
                my $ext_old = ( File::Basename::fileparse( $local_file, qr/[A-Za-z0-9]+$/ ) )[2];
                if (lc($ext_temp) ne lc($ext_old) && ! ( lc($ext_old) eq 'jpeg' && lc($ext_temp) eq 'jpg' )) {
                    $ext_temp = lc($ext_temp);
                    my $target_file = $local_file;
                    $target_file =~ s/$ext_old/$ext_temp/;
                    $relative_path =~ s/$ext_old/$ext_temp/;
                    $relative_url =~ s/$ext_old/$ext_temp/;
                    $asset_file =~ s/$ext_old/$ext_temp/;
                    $basename =~ s/$ext_old/$ext_temp/;
                    rename($local_file, $target_file);
                    $local_file =~ s/$ext_old/$ext_temp/;
                    $real_fh =~ s/$ext_old/$ext_temp/;
                    $app->param("changed_file_ext", "$ext_old,$ext_temp");
                }
            }
        }

        ## If $local_file already exists, we try to write the upload to a
        ## tempfile, then ask for confirmation of the upload.
        if ( $fmgr->exists($local_file) ) {
            if ($has_overwrite) {
                my $tmp = $q->param('temp');
                if ( $tmp =~ m!([^/]+)$! ) {
                    $tmp = $1;
                }
                else {
                    return $app->error(
                        $app->translate( "Invalid temp file name '[_1]'", $tmp ) );
                }
                my $tmp_dir = $app->config('TempDir');
                my $tmp_file = File::Spec->catfile( $tmp_dir, $tmp );
                if ( $q->param('overwrite_yes') ) {
                    $fh = gensym();
                    open $fh, $tmp_file
                      or return $app->error(
                        $app->translate(
                            "Error opening '[_1]': [_2]",
                            $tmp_file, "$!"
                        )
                      );
                }
                else {
                    if ( -e $tmp_file ) {
                        unlink($tmp_file)
                          or return $app->error(
                            $app->translate(
                                "Error deleting '[_1]': [_2]",
                                $tmp_file, "$!"
                            )
                          );
                    }
                    return start_upload($app);
                }
            }
            else {
                eval { require File::Temp };
                if ($@) {
                    return $app->error(
                        $app->translate(
                            "File with name '[_1]' already exists. (Install "
                              . "File::Temp if you'd like to be able to overwrite "
                              . "existing uploaded files.)",
                            $basename
                        )
                    );
                }
                my $tmp_dir = $app->config('TempDir');
                my ( $tmp_fh, $tmp_file );
                eval {
                    ( $tmp_fh, $tmp_file ) =
                      File::Temp::tempfile( DIR => $tmp_dir );
                };
                if ($@) {    #!$tmp_fh
                    return $app->errtrans(
                        "Error creating temporary file; please check your TempDir "
                          . "setting in your coniguration file (currently '[_1]') "
                          . "this location should be writable.",
                        (
                              $tmp_dir
                            ? $tmp_dir
                            : '[' . $app->translate('unassigned') . ']'
                        )
                    );
                }
                defined( _write_upload( $fh, $tmp_fh ) )
                  or return $app->error(
                    $app->translate(
                        "File with name '[_1]' already exists; Tried to write "
                          . "to tempfile, but open failed: [_2]",
                        $basename,
                        "$!"
                    )
                  );
                close $tmp_fh;
                my ( $vol, $path, $tmp ) = File::Spec->splitpath($tmp_file);
                my ($ext_from, $ext_to) = split(",", $app->param('changed_file_ext'));
                my $extension_message = $app->translate("Extension changed from [_1] to [_2]", $ext_from, $ext_to) if ($ext_from && $ext_to);
                return $app->load_tmpl(
                    'dialog/asset_replace.tmpl',
                    {
                        temp         => $tmp,
                        extra_path   => $relative_path_save,
                        site_path    => scalar $q->param('site_path'),
                        asset_select => $q->param('asset_select'),
                        entry_insert => $q->param('entry_insert'),
                        edit_field   => $app->param('edit_field'),
                        middle_path  => $middle_path,
                        fname        => $basename,
                        no_insert    => $q->param('no_insert') || "",
                        extension_message => $extension_message,
                    }
                );
            }
        }
    }
    else {
        $blog_id        = 0;
        $asset_base_url = '%s/support/uploads';
        $base_url       = $app->static_path . 'support/uploads';
        $param{support_path} =
          File::Spec->catdir( $app->static_file_path, 'support', 'uploads' );

        require MT::FileMgr;
        $fmgr = MT::FileMgr->new('Local');
        unless ( $fmgr->exists( $param{support_path} ) ) {
            $fmgr->mkpath( $param{support_path} );
            unless ( $fmgr->exists( $param{support_path} ) ) {
                return $app->error( $app->translate(
                    "Could not create upload path '[_1]': [_2]",
                        $param{support_path}, $fmgr->errstr
                ) );
            }
        }

        require File::Basename;
        my ($stem, undef, $type) = File::Basename::fileparse( $basename,
            qr/\.[A-Za-z0-9]+$/ );
        my $unique_stem = $stem;
        $local_file = File::Spec->catfile( $param{support_path},
            $unique_stem . $type );
        my $i = 1;
        while ($fmgr->exists($local_file)) {
            $unique_stem = join q{-}, $stem, $i++;
            $local_file = File::Spec->catfile( $param{support_path},
                $unique_stem . $type );
        }

        my $unique_basename = $unique_stem . $type;
        $relative_path  = $unique_basename;
        $relative_url   = encode_url($unique_basename);
        $asset_file     = File::Spec->catfile( '%s', 'support', 'uploads',
          $unique_basename );
    }

    my ($w, $h, $id, $write_file) = MT::Image->check_upload(
        Fh => $fh, Fmgr => $fmgr, Local => $local_file,
        Max => $upload_param{max_size},
        MaxDim => $upload_param{max_image_dimension}
    );

    return $app->error(MT::Image->errstr)
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
        if ( $tmp =~ m!([^/]+)$! ) {
            $tmp = $1;
        }
        else {
            return $app->error(
                $app->translate( "Invalid temp file name '[_1]'", $tmp ) );
        }
        my $tmp_file = File::Spec->catfile( $app->config('TempDir'), $tmp );
        unlink($tmp_file)
          or return $app->error(
            $app->translate( "Error deleting '[_1]': [_2]", $tmp_file, "$!" ) );
    }

    ## We are going to use $relative_path as the filename and as the url passed
    ## in to the templates. So, we want to replace all of the '\' characters
    ## with '/' characters so that it won't look like backslashed characters.
    ## Also, get rid of a slash at the front, if present.
    $relative_path =~ s!\\!/!g;
    $relative_path =~ s!^/!!;
    $relative_url  =~ s!\\!/!g;
    $relative_url  =~ s!^/!!;
    my $url = $base_url;
    $url .= '/' unless $url =~ m!/$!;
    $url .= $relative_url;
    my $asset_url = $asset_base_url . '/' . $relative_url;

    require File::Basename;
    my $local_basename = File::Basename::basename($local_file);
    my $ext =
      ( File::Basename::fileparse( $local_file, qr/[A-Za-z0-9]+$/ ) )[2];

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local_basename);
    my $is_image = 0;
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
    my $asset;
    if (
        !(
            $asset = $asset_pkg->load(
                { file_path => $asset_file, blog_id => $blog_id },
                { binary => { file_path => 1 } }
            )
        )
      )
    {
        $asset = $asset_pkg->new();
        $asset->file_path($asset_file);
        $asset->file_name($local_basename);
        $asset->file_ext($ext);
        $asset->blog_id($blog_id);
        $asset->label($local_basename);
        $asset->created_by( $app->user->id );
    }
    else {
        $asset->modified_by( $app->user->id );
    }
    my $original = $asset->clone;
    $asset->url($asset_url);

    if ($is_image) {
        $asset->image_width($w);
        $asset->image_height($h);
    }

    $asset->mime_type($mimetype) if $mimetype;

    $asset->save;
    $app->run_callbacks( 'cms_post_save.asset', $app, $asset, $original );

    if ($is_image) {
        $app->run_callbacks(
            'cms_upload_file.' . $asset->class,
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
            'cms_upload_image',
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
            'cms_upload_file.' . $asset->class,
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

    return ($asset, $bytes);
}

sub _write_upload {
    my ( $upload_fh, $dest_fh ) = @_;
    my $fh = gensym();
    if ( ref($dest_fh) eq 'GLOB' ) {
        $fh = $dest_fh;
    }
    else {
        open $fh, ">$dest_fh" or return;
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

1;