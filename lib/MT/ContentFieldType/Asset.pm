# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Asset;
use strict;
use warnings;

use MT;
use MT::Asset;
use MT::Author;
use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::FileMgr;
use MT::ObjectTag;
use MT::Tag;

# content field idx_type => asset class
my %ClassTable = (
    'asset' => 'file',
    'audio' => 'audio',
    'image' => 'image',
    'video' => 'video',
);

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value} || [];
    $value = [$value] unless ref $value eq 'ARRAY';

    my @asset_loop;
    my $type = $field_data->{type};
    $type =~ s/_/\./g if $type =~ /_/;
    my $iter = $app->model($type)->load_iter( { id => $value } );
    while ( my $asset = $iter->() ) {
        push @asset_loop,
            {
            asset_id      => $asset->id,
            asset_blog_id => $asset->blog_id,
            asset_label   => $asset->label,
            asset_thumb   => $asset->thumbnail_url( Width => 100 ),
            };
    }

    my $options = $field_data->{options} || {};

    my $multiple = '';
    if ( $options->{multiple} ) {
        $multiple = $options->{multiple} ? 'data-mt-multiple="1"' : '';
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    my $asset_class = $app->model($type);

    {   asset_loop => @asset_loop ? \@asset_loop : undef,
        asset_type => $asset_class->class_type,
        multiple   => $multiple,
        required   => $required,
        type_label => $asset_class->class_label,
        type_label_plural => $asset_class->class_label_plural,
    };
}

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_field_id => $prop->content_field_id,
            value_integer    => \'= asset_id',
        },
        { unique => 1 },
    );
    my @options;
    my $iter = MT::Asset->load_iter( undef,
        { join => $cf_idx_join, fetchonly => { id => 1, label => 1 } } );
    while ( my $asset = $iter->() ) {
        my $label = $asset->label . ' (id:' . $asset->id . ')';
        push @options,
            {
            label => $label,
            value => $asset->id,
            };
    }

    \@options;
}

sub terms_author_name {
    my $prop = shift;
    my ( $args, $load_terms, $load_args ) = @_;

    my $prop_super = MT->registry( 'list_properties', '__virtual', 'string' );

    my ( $name_query, $nick_query );
    {
        local $prop->{col} = 'name';
        $name_query = $prop_super->{terms}->( $prop, @_ );
    }
    {
        local $prop->{col} = 'nickname';
        $nick_query = $prop_super->{terms}->( $prop, @_ );
    }

    my $option = $args->{option} || '';
    if ( $option eq 'not_contains' ) {
        my $string       = $args->{string};
        my $author_terms = [
            { name => { like => "%${string}%" } },
            '-or',
            { nickname => { like => "%${string}%" } },
        ];
        my $author_join = MT::Author->join_on( undef,
            [ $author_terms, { id => \'= asset_created_by' } ] );
        my @asset_ids;
        my $iter = MT::Asset->load_iter(
            {   blog_id => MT->app->blog->id,
                class   => $ClassTable{ $prop->idx_type },
            },
            { join => $author_join, fetchonly => { id => 1 } },
        );
        while ( my $asset = $iter->() ) {
            push @asset_ids, $asset->id;
        }
        my $join_terms = { value_integer => [ \'IS NULL', @asset_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $author_terms = [ $name_query, $nick_query ];
        my $author_join
            = MT::Author->join_on( undef,
            [ { id => \'= asset_created_by' }, $author_terms ] );
        my $asset_join = MT::Asset->join_on(
            undef,
            { id   => \'= cf_idx_value_integer' },
            { join => $author_join, },
        );
        my $join_args = { join => $asset_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub terms_author_status {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $status_query = $prop->super(@_);
    my $author_join
        = MT::Author->join_on( undef,
        [ { id => \'= asset_created_by' }, $status_query ] );
    my $asset_join = MT::Asset->join_on(
        undef,
        { id   => \'= cf_idx_value_integer' },
        { join => $author_join, }
    );
    my $join_args = { join => $asset_join };
    my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
    { id => $cd_ids };
}

sub terms_date {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $query = $prop->super(@_);

    my $asset_join = MT::Asset->join_on( undef,
        [ { id => \'= cf_idx_value_integer' }, $query ] );

    my $join_args = { join => $asset_join };
    my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
    { id => $cd_ids };
}

sub terms_tag {
    my $prop = shift;
    my ( $args, $base_terms, $base_args, $opts ) = @_;

    my $query = $prop->super(@_);

    my $option = $args->{option};
    if ( 'not_contains' eq $option ) {
        my $string   = $args->{string};
        my $tag_join = MT::Tag->join_on(
            undef,
            {   name => { like => "%${string}%" },
                id   => \'= objecttag_tag_id'
            }
        );
        my @asset_ids;
        my $iter = MT::ObjectTag->load_iter(
            {   blog_id           => MT->app->blog->id,
                object_datasource => 'asset',
            },
            {   join      => $tag_join,
                fetchonly => { object_id => 1 },
            },
        );
        while ( my $ot = $iter->() ) {
            push @asset_ids, $ot->object_id;
        }
        my $join_terms = { value_integer => [ \'IS NULL', @asset_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    elsif ( 'blank' eq $option ) {
        my $objecttag_join = MT::ObjectTag->join_on(
            undef,
            { object_id => \'IS NULL' },
            {   type      => 'left',
                condition => {
                    object_datasource => 'asset',
                    object_id         => \'= cf_idx_value_integer',
                },
            },
        );
        my $join_args = { join => $objecttag_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
    else {
        my $tag_join = MT::Tag->join_on( undef,
            [ { id => \'= objecttag_tag_id' }, $query ] );
        my $objecttag_join = MT::ObjectTag->join_on(
            undef,
            {   object_datasource => 'asset',
                object_id         => \'= cf_idx_value_integer',
            },
            { join => $tag_join },
        );
        my $join_args = { join => $objecttag_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub terms_image_size {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $super = MT->registry( 'list_properties', '__virtual', 'integer' );
    my $super_terms = $super->{terms}->( $prop, @_ );

    my $option = $args->{option} || '';
    if ( $option eq 'not_equal' ) {
        my $value = $args->{value} || 0;
        my $asset_meta_join
            = MT::Asset->meta_pkg->join_on( 'asset_id',
            { type => $prop->meta_type, vinteger => $value },
            );
        my @asset_ids;
        my $iter = MT::Asset->load_iter(
            {   blog_id => MT->app->blog->id,
                class   => $ClassTable{ $prop->idx_type },
            },
            {   join      => $asset_meta_join,
                fetchonly => { id => 1 },
            },
        );
        while ( my $asset = $iter->() ) {
            push @asset_ids, $asset->id;
        }
        my $join_terms = { value_integer => [ \'IS NULL', @asset_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $asset_meta_join
            = MT::Asset->meta_pkg->join_on( 'asset_id',
            [ { type => $prop->meta_type }, $super_terms ],
            );
        my $asset_join = MT::Asset->join_on(
            undef,
            { id   => \'= cf_idx_value_integer' },
            { join => $asset_meta_join, },
        );
        my $join_args = { join => $asset_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub terms_missing_file {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $fmgr = MT::FileMgr->new('Local');

    my $filter
        = $args->{value}
        ? sub { !$fmgr->exists( $_[0] ) }
        : sub { $fmgr->exists( $_[0] ) };

    my $iter = MT::Asset->load_iter(
        {   blog_id => MT->app->blog->id,
            class   => $ClassTable{ $prop->idx_type },
        },
        {   join => MT::ContentFieldIndex->join_on(
                undef,
                {   value_integer    => \'= asset_id',
                    content_field_id => $prop->content_field_id,
                },
            )
        }
    );

    my @asset_ids;
    while ( my $asset = $iter->() ) {
        push @asset_ids, $asset->id
            if defined $asset->file_path
            && $asset->file_path ne ''
            && $filter->( $asset->file_path );
    }

    return { id => 0 } unless @asset_ids;    # no data

    my $join_terms = { value_integer => \@asset_ids };
    my $cd_ids = get_cd_ids_by_inner_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub terms_text {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';

    if ( $option eq 'not_contains' ) {
        my $col    = $prop->col;
        my $string = $args->{string};
        my @asset_ids;
        my $iter = MT::Asset->load_iter(
            {   blog_id => MT->app->blog->id,
                class   => $ClassTable{ $prop->idx_type },
                $col => { like => "%${string}%" },
            },
            { fetchonly => { id => 1 } },
        );
        while ( my $asset = $iter->() ) {
            push @asset_ids, $asset->id;
        }
        my $join_terms = { value_integer => [ \'IS NULL', @asset_ids ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $query      = $prop->super(@_);
        my $asset_join = MT::Asset->join_on( undef,
            [ { id => \'= cf_idx_value_integer' }, $query ] );
        my $join_args = { join => $asset_join };
        my $cd_ids = get_cd_ids_by_inner_join( $prop, undef, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub terms_id {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';

    if ( $option eq 'not_equal' ) {
        my $col        = $prop->col;
        my $value      = $args->{value} || 0;
        my $join_terms = { $col => [ \'IS NULL', $value ] };
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $join_terms = $prop->super(@_);
        my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
        { id => $cd_ids };
    }
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $is_image  = $prop->idx_type eq 'image';
    my $cd_id     = $content_data->id;
    my $field_id  = $prop->content_field_id;
    my $asset_ids = $content_data->data->{$field_id} || [];

    my %assets;
    my $iter = MT::Asset->load_iter( { id => $asset_ids } );
    while ( my $asset = $iter->() ) {
        $assets{ $asset->id } = $asset;
    }
    my @assets = grep {$_} map { $assets{$_} } @$asset_ids;

    my ( @labels, @thumbnails );
    for my $asset (@assets) {
        my $label = $asset->label;
        my $edit_link = _edit_link( $app, $asset );

        push @labels,
            qq{<a href="${edit_link}" class="asset-field-label">${label}</a>};
        if ($is_image) {
            my $thumbnail_html = _thumbnail_html( $app, $asset );
            push @thumbnails,
                qq{<a href="${edit_link}">${thumbnail_html}</a>};
        }
    }

    my $labels_html
        = qq{<span id="asset-labels-${cd_id}-${field_id}" class="label">}
        . join( '', @labels )
        . '</span>';

    if ($is_image) {
        my $thumbnails_html
            = qq{<span id="asset-thumbnails-${cd_id}-${field_id}" class="thumbnail">}
            . join( '', @thumbnails )
            . '</span>';
        my $js = <<"__JS__";
<script>
jQuery(document).ready(function() {
  jQuery("#custom-prefs-content_field_${field_id}\\\\.thumbnail").change(function() {
    changeLabels();
  });

  function changeLabels() {
    if (jQuery("#custom-prefs-content_field_${field_id}\\\\.thumbnail").prop('checked')) {
      jQuery('#asset-labels-${cd_id}-${field_id}').css('display', 'none');
    } else {
      jQuery('#asset-labels-${cd_id}-${field_id}').css('display', 'inline');
    }
  }

  changeLabels();
});
</script>
__JS__

        $labels_html . $thumbnails_html . $js;
    }
    else {
        $labels_html;
    }
}

sub _edit_link {
    my ( $app, $asset ) = @_;
    $app->uri(
        mode => 'edit',
        args => {
            _type   => 'asset',
            blog_id => $asset->blog_id,
            id      => $asset->id,
        },
    );
}

sub _thumbnail_html {
    my ( $app, $asset ) = @_;

    my $thumb_size = 45;
    my $class_type = $asset->class_type;
    my $file_path  = $asset->file_path;
    my $img
        = MT->static_path
        . 'images/asset/'
        . $class_type . '-'
        . $thumb_size . '.png';

    my ( $orig_width, $orig_height )
        = ( $asset->image_width, $asset->image_height );
    my ( $thumbnail_url, $thumbnail_width, $thumbnail_height );
    if (   $orig_width > $thumb_size
        && $orig_height > $thumb_size )
    {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Height => $thumb_size,
            Width  => $thumb_size,
            Square => 1,
            Ts     => 1
            );
    }
    elsif ( $orig_width > $thumb_size ) {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Width => $thumb_size,
            Ts    => 1
            );
    }
    elsif ( $orig_height > $thumb_size ) {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Height => $thumb_size,
            Ts     => 1
            );
    }
    else {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height ) = (
            $asset->url . '?ts=' . $asset->modified_on,
            $orig_width, $orig_height
        );
    }

    my $thumbnail_width_offset
        = int( ( $thumb_size - $thumbnail_width ) / 2 );
    my $thumbnail_height_offset
        = int( ( $thumb_size - $thumbnail_height ) / 2 );

    qq{<img alt="" src="${thumbnail_url}" style="padding: ${thumbnail_height_offset}px ${thumbnail_width_offset}px" />};
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options          = $field_data->{options} || {};
    my $field_label      = $options->{label};
    my $field_type       = $field_data->{type};
    my $field_type_label = $field_data->{type_label};

    my $asset_class
        = $field_type eq 'asset'        ? '*'
        : $field_type =~ /^asset_(.*)$/ ? $1
        :                                 undef;
    return $app->translate( '[_1] is invalid asset type ([_2].',
        $field_label, $field_type )
        unless $asset_class;

    my $iter = MT::Asset->load_iter(
        {   id      => $data,
            blog_id => $app->blog->id,
            class   => $asset_class
        },
        { fetchonly => { id => 1 } }
    );

    my %valid_assets;
    while ( my $asset = $iter->() ) {
        $valid_assets{ $asset->id } = 1;
    }
    if ( my @invalid_asset_ids = grep { !$valid_assets{$_} } @{$data} ) {
        my $invalid_asset_ids = join ', ', @invalid_asset_ids;
        return $app->translate(
            "You must select or upload correct assets for a field '[_1]' that asset type is '[_2]'.",
            $field_label, $field_type_label
        );
    }

    my $type_label_plural = $field_type . 's';
    MT::ContentFieldType::Common::ss_validator_multiple( @_, $field_type_label,
        $type_label_plural );
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $multiple = $options->{multiple};
    if ($multiple) {
        my $min = $options->{min};
        return $app->translate(
            "A number of minimum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
            $label, $field_label
        ) if '' ne $min and $min !~ /^\d+$/;

        my $max = $options->{max};
        return $app->translate(
            "A number of maximum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
            $label,
            $field_label
        ) if '' ne $max and ( $max !~ /^\d+$/ or $max < 1 );

        return $app->translate(
            "A number of maximum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to a number of minimum selection.",
            $label,
            $field_label
            )
            if '' ne $min
            and '' ne $max
            and $max < $min;
    }

    return;
}

1;

