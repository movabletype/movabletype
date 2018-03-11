# Movable Type (r) (C) 2006-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::App;

use strict;
use warnings;

use BlockEditor;
use MT::CMS::Asset;

my $default_thumbnail_size = 60;

sub param_edit_content_data {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blockeditor_fields       = $app->registry('blockeditor_fields');
    my @blockeditor_fields_array = map {
        my $hash = {};
        $hash->{type}  = $_;
        $hash->{label} = $blockeditor_fields->{$_}{label};
        $hash->{path}  = $blockeditor_fields->{$_}{path};
        $hash->{order} = $blockeditor_fields->{$_}{order};
        $hash;
    } keys %$blockeditor_fields;
    @blockeditor_fields_array
        = sort { $a->{order} <=> $b->{order} } @blockeditor_fields_array;
    $param->{blockeditor_fields} = \@blockeditor_fields_array;

    my $editor_tmpl = plugin()->load_tmpl('editor.tmpl');
    $param->{blockeditor_tmpl} = $editor_tmpl;
}
sub ss_validator {
  my ( $app, $field_data, $data ) = @_;

  my $options          = $field_data->{options} || {};
  my $required         = $options->{required};
  if(!$required){
    return undef;
  }
  my $field_label      = $options->{label};
  my $field_type       = $field_data->{type};
  my $field_type_label = $field_data->{type_label};


  my $format = $app->param('content-field-' . $field_data->{id} . '_convert_breaks' );
  if($format eq 'blockeditor'){
    if(!$app->param('block_editor_data')){
      return $app->translate(qq{"${field_label}" field is required.});
    }
  }
  return undef;
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

    my %param;
    MT::CMS::Asset::_set_start_upload_params( $app, \%param );

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

    $param{asset_id} = $app->param('asset_id')
        if defined $app->param('asset_id');
    $param{options} = $app->param('options')
        if defined $app->param('options');

    return plugin()->load_tmpl( 'cms/dialog/asset_modal.tmpl', \%param );
}

sub dialog_insert_options {
    my $app    = shift;
    my (%args) = @_;
    my $assets = $args{assets};

    $app->validate_magic() or return;

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
        my $html = _insert_options( $a, $param ) || '';
        $param->{options} = $html;
        push @$options_loop, $param;
    }

    my %param;
    $param{options_loop} = $options_loop;
    $param{edit_field}   = $app->param('edit_field') || '';
    $param{new_entry}    = $app->param('asset_select') ? 0 : 1;

    return plugin()
        ->load_tmpl( 'cms/dialog/multi_asset_options.tmpl', \%param );
}

sub dialog_insert_asset {
    my $app = shift;
    my ($param) = @_;

    $app->validate_magic() or return;

    my $edit_field = $app->param('edit_field') || '';
    if ( $edit_field =~ m/^customfield_.*$/ ) {
        return $app->permission_denied()
            unless $app->permissions;
    }
    else {
        return $app->permission_denied()
            unless $app->can_do('insert_asset');
    }

    my %param;

    require MT::Asset;
    my $text;
    my $assets;

    # Parse JSON.
    my $prefs = $app->param('prefs_json');
    $prefs =~ s/^"|"$//g;
    $prefs =~ s/\\"/"/g;
    $prefs =~ s/\\\\/\\/g;
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
        $param{new_entry} = $app->param('new_entry') ? 1 : 0;

        $asset->on_upload( \%param );
        if ( $param{thumb} ) {
            $asset = MT->model('asset')->load( $param{thumb_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{thumb_asset_id}
                )
                );
        }
        push @$assets, $asset;
    }

    my @assets_data;
    $param{assets}     = \@$assets;
    $param{edit_field} = $edit_field;
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

    $param->{make_thumb} = $blog->image_default_thumb ? 1 : 0;
    $param->{ 'align_' . $_ }
        = ( $blog->image_default_align || 'none' ) eq $_ ? 1 : 0
        for qw(none left center right);
    $param->{width}
        = $blog->image_default_width
        || $asset->image_width
        || 0;

    return plugin()->load_tmpl( 'cms/include/insert_options.tmpl', $param );
}

1;
