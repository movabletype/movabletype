
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::BlockEditorFieldType::Image;

use strict;
use warnings;

use BlockEditor;
use MT::CMS::Asset;
use MT::Util;
my $default_thumbnail_size = 60;
my $limit = 9;

sub dialog_list_asset {
    my $app = shift;

    return dialog_asset_modal( $app, @_ ) unless $app->param('json');

    $app->validate_param({
        asset_id      => [qw/ID/],
        blog_id       => [qw/ID/],
        d             => [qw/MAYBE_STRING/],
        dialog        => [qw/MAYBE_STRING/],
        edit          => [qw/MAYBE_STRING/],
        edit_field    => [qw/MAYBE_STRING/],
        ext_from      => [qw/MAYBE_STRING/],
        ext_to        => [qw/MAYBE_STRING/],
        filter        => [qw/MAYBE_STRING/],
        filter_val    => [qw/MAYBE_STRING/],
        json          => [qw/MAYBE_STRING/],
        no_insert     => [qw/MAYBE_STRING/],
        offset        => [qw/MAYBE_STRING/],
        saved_deleted => [qw/MAYBE_STRING/],
        search        => [qw/MAYBE_STRING/],
    }) or return;

    my $blog_id    = $app->param('blog_id');
    my $blog_class = $app->model('blog');
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;

    my $edit_field = $app->param('edit_field') || '';

    # return $app->permission_denied()
    #     if $blog_id && !$app->can_do('access_to_insert_asset_list');

    my $asset_class = $app->model('asset') or return;
    my %terms;
    my %args =
      ( sort => 'created_on', direction => 'descend', limit => $limit );

    my $class_filter;
    my $filter = $app->param('filter') || '';
    if ( $filter eq 'class' ) {
        $class_filter = $app->param('filter_val');
    }

    $app->add_breadcrumb( $app->translate("Files") );

    if ($blog_id) {
        my $blog_ids = $app->_load_child_blog_ids($blog_id);
        push @$blog_ids, $blog_id;
        $terms{blog_id} = $blog_ids;
    }

    my $hasher = MT::CMS::Asset::build_asset_hasher(
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
    $args{limit} = $asset_class->count( \%terms ) if ( $app->param('search') );

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
    MT::CMS::Asset::_set_start_upload_params( $app, \%carry_params )
        if $app->can_do('upload');
    my $ext_from = $app->param('ext_from');
    my $ext_to   = $app->param('ext_to');

    # Check directory for thumbnail image
    MT::CMS::Asset::_check_thumbnail_dir( $app, \%carry_params );

    my $pre_build = sub {
        my ($param) = @_;
        my $loop = $param->{object_loop};
        my @new_object_loop;

        if ( $app->param('search') ) {
            my $offset = $app->param('offset') ? $app->param('offset') : 0;
            $offset += 0;
            my $d = $app->param('d') || 0;
            $d =~ s/\D//g;
            my $row_index = 0;
            for my $i ( $offset .. ( $offset + $limit - 1 ) ) {
                if ( $loop->[$i] ) {
                    $new_object_loop[$row_index] = $loop->[$i] if $loop->[$i];
                }
                else {
                    $new_object_loop[$row_index] = {};
                }
                $row_index++;
            }
            my $pager = {
                offset        => $offset,
                limit         => $limit,
                rows          => scalar @new_object_loop,
                d             => $d,
                listTotal     => scalar @{$loop},
                chronological => $param->{list_noncron} ? 0 : 1,
                return_args => MT::Util::encode_html( $app->make_return_args ),
                method      => $app->request_method,
            };
            $param->{object_type} = 'asset';
            $param->{pager_json}  = $pager;
        }
        else {
            for my $i ( 0 .. ( $limit - 1 ) ) {
                if ( $loop->[$i] ) {
                    $new_object_loop[$i] = $loop->[$i] if $loop->[$i];
                }
                else {
                    $new_object_loop[$i] = {};
                }
            }
        }
        $param->{object_loop} = \@new_object_loop;
    };
    return $app->listing(
        {   terms     => \%terms,
            args      => \%args,
            type      => 'asset',
            code      => $hasher,
            template  => 'cms/dialog/asset_modal.tmpl',
            pre_build => $pre_build,
            params    => {
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
                asset_id => scalar( $app->param('asset_id') ) || '',
                edit     => $app->param('edit') ? 1 : 0,
            },
        }
    );
}

sub dialog_asset_modal {
    my $app = shift;

    $app->validate_param({
        asset_id     => [qw/ID/],
        asset_select => [qw/MAYBE_STRING/],
        blog_id      => [qw/ID/],
        can_multi    => [qw/MAYBE_STRING/],
        edit         => [qw/MAYBE_STRING/],
        edit_field   => [qw/MAYBE_STRING/],
        filter       => [qw/MAYBE_STRING/],
        filter_val   => [qw/MAYBE_STRING/],
        next_mode    => [qw/MAYBE_STRING/],
        no_insert    => [qw/MAYBE_STRING/],
        options      => [qw/MAYBE_STRING/],
        search       => [qw/MAYBE_STRING/],
        upload_mode  => [qw/MAYBE_STRING/],
    }) or return;

    my $blog_id    = $app->param('blog_id');
    my $blog_class = $app->model('blog');
    my $blog;
    $blog = $blog_class->load($blog_id) if $blog_id;

    my %param;
    if (   $app->param('edit_field')
        && $app->param('edit_field') =~ m/^customfield_.*$/ )
    {
        # return $app->permission_denied()
        #     unless $app->permissions;
    }
    else {
        # return $app->permission_denied()
        #     if $blog_id && !$app->can_do('access_to_insert_asset_list');
    }

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
    $param{require_type} = 'image';

    if ($blog_id) {
        $param{blog_id}      = $blog_id;
        $param{edit_blog_id} = $blog_id,;
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
    $param{can_delete_files} = $app->can_do('delete_asset_file') ? 1 : 0;

    MT::CMS::Asset::_set_start_upload_params( $app, \%param );
    my $asset_upload_panel
        = $app->build_page( 'cms/dialog/include/asset_upload_panel.tmpl',
        \%param );
    if ($asset_upload_panel) {
        $param{asset_upload_panel} = $asset_upload_panel;
    }
    $param{options} = $app->param('options')
        if defined $app->param('options');
    $param{asset_id} = $app->param('asset_id')
        if defined $app->param('asset_id');
    $param{edit} = $app->param('edit') if defined $app->param('edit');

    return plugin()->load_tmpl( 'cms/dialog/asset_modal.tmpl', \%param );
}

sub dialog_insert_options {
    my $app    = shift;
    my (%args) = @_;
    my $assets = $args{assets};

    $app->validate_param({
        blog_id    => [qw/ID/],
        edit       => [qw/MAYBE_STRING/],
        edit_field => [qw/MAYBE_STRING/],
        id         => [qw/IDS/],
        options    => [qw/MAYBE_STRING/],
    }) or return;

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

    # Permission check
    my $perms = $app->permissions
        or return $app->errtrans('No permissions');
    return $app->errtrans('No permissions')
        unless $perms->can_do('insert_asset');

    # Make a insert option loop
    my $options_loop;
    foreach my $a (@$assets) {
        my $param = {
            id        => $a->id,
            filename  => $a->file_name,
            url       => $a->url,
            label     => $a->label,
            thumbnail => MT::CMS::Asset::_make_thumbnail_url(
                $a, { size => $default_thumbnail_size }
            ),
            thumbnail_type => $a->class,
            class_label    => $a->class_label,
        };
        if ( defined $app->param('options') ) {
            my $options_json = $app->param('options');
            my $options;
            require Encode;
            require JSON;
            if ( Encode::is_utf8($options_json) ) {
                $options = eval { JSON::from_json($options_json) } || {};
            }
            else {
                $options = eval { JSON::decode_json($options_json) } || {};
            }
            $param->{$_} = $options->{$_} for keys %$options;
        }
        if ( defined $app->param('edit') ) {
            $param->{edit} = 1;
        }
        my $html = _insert_options( $a, $param ) || '';
        $param->{options} = $html;
        push @$options_loop, $param;
    }

    my %param;
    $param{options_loop} = $options_loop;
    $param{edit_field} = $app->param('edit_field') || '';

    my $html
        = $app->build_page( 'cms/dialog/multi_asset_options.tmpl', \%param );

    return $html;
}

sub dialog_insert_asset {
    my $app = shift;
    my ($param) = @_;

    return $app->permission_denied()
        unless $app->can_do('insert_asset');

    my %param;

    require MT::Asset;
    my $assets;

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
        my $asset = MT::Asset->load($id)
            or return $app->errtrans( 'Cannot load asset #[_1]', $id );
        foreach my $k ( keys %$item ) {
            my $name = $k;
            if ( $k =~ m/(.*)[-|_]$id/ig ) {
                $param{$1} = $item->{$k};
            }
            $param{$name} = $item->{$k};
        }
        $param{wrap_text} = 1;
        $param{new_entry} = 1;

        $asset->on_upload( \%param );
        if ( $param{thumb} ) {
            $asset = MT->model('asset')->load( $param{thumb_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{thumb_asset_id}
                )
                );

            foreach my $k ( keys %$item ) {
                my $name = $k;
                if ( $k =~ m/(.*)[-|_]$id/ig ) {
                    $param{$1} = $item->{$k};
                    $param{ $1 . '-' . $asset->id } = $item->{$k};
                }
            }

        }
        push @$assets, $asset;
    }
    $param{assets} = $assets;
    return plugin()->load_tmpl( 'cms/dialog/asset_insert.tmpl', \%param );
}

sub _insert_options {
    my $asset = shift;
    my ($param) = @_;

    my $app   = MT->instance;
    my $perms = $app->{perms};
    my $blog  = $asset->blog or return;

    $param->{do_thumb}
        = $asset->has_thumbnail && $asset->can_create_thumbnail ? 1 : 0;

    if ( !$param->{edit} ) {
        $param->{make_thumb} = $blog->image_default_thumb ? 1 : 0;
    }
    else {
        $param->{make_thumb} = 0;
    }

    if ( !$param->{align} ) {
        $param->{'align'}
            = $blog->image_default_align
            ? $blog->image_default_align
            : 'none';
    }
    if ( !$param->{width} ) {
        $param->{width}
            = $blog->image_default_width
            || $asset->image_width
            || 0;
    }

    return plugin()->load_tmpl( 'cms/include/insert_options.tmpl', $param );
}

sub delete {
    my $app = MT->instance;

    $app->param( 'xhr', 1 );
    my $return_arg = MT::CMS::Common::delete($app);
    return $app->json_result($return_arg);

}

1;
