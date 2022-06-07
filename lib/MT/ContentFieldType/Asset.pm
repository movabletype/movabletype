# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
use MT::Util;

# content field idx_type => asset class
my %ClassTable = (
    'asset' => 'file',
    'audio' => 'audio',
    'image' => 'image',
    'video' => 'video',
);

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $raw_value = $field_data->{value} || [];
    my @value = ref $raw_value eq 'ARRAY' ? @$raw_value : ($raw_value);

    my @asset_loop;
    my $type = $field_data->{type};
    $type =~ s/_/\./g if $type =~ /_/;

    my $options = $field_data->{options} || {};

    if (@value) {
        require MT::CMS::Asset;
        my $hasher = MT::CMS::Asset::build_asset_hasher(
            $app,
            PreviewWidth  => $options->{preview_width} || 80,
            PreviewHeight => $options->{preview_height} || 80,
        );

        my $iter = $app->model($type)->load_iter( { id => \@value } );
        my %asset_hash;
        while ( my $asset = $iter->() ) {
            $asset_hash{ $asset->id } = $asset;
        }
        for my $asset_id (@value) {
            my $asset = $asset_hash{$asset_id} or next;

            my $row = $asset->get_values;
            $hasher->( $asset, $row );

            push @asset_loop,
                {
                asset_id             => $row->{id},
                asset_blog_id        => $row->{blog_id},
                asset_dimensions     => $row->{'Actual Dimensions'},
                asset_file_name      => $row->{file_name},
                asset_file_size      => $row->{file_size},
                asset_label          => $row->{label},
                asset_preview_url    => $row->{preview_url},
                asset_preview_height => $row->{preview_height},
                asset_preview_width  => $row->{preview_width},
                asset_type           => $row->{class},
                };
        }
    }

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
        asset_type_for_field => $asset_class->class_type,
        multiple             => $multiple,
        required             => $required,
        type_label           => $asset_class->class_label,
        type_label_plural    => $asset_class->class_label_plural,
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
    my $iter = MT::Asset->load_iter( { class => '*' },
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
            { tag_id => \'IS NULL' },
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
    elsif ( 'not_blank' eq $option ) {
        my $objecttag_join = MT::ObjectTag->join_on(
            undef,
            {   object_datasource => 'asset',
                object_id         => \'= cf_idx_value_integer',
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

    my $cd_id         = $content_data->id;
    my $field_id      = $prop->content_field_id;
    my $raw_asset_ids = $content_data->data->{$field_id} or return '';
    my @asset_ids
        = ref $raw_asset_ids eq 'ARRAY' ? @$raw_asset_ids : ($raw_asset_ids);
    return '' unless @asset_ids;

    my $asset_count = MT::Asset->count( { id => \@asset_ids } ) || 0;

    if ( $asset_count == 1 ) {
        my $can_double_encode = 1;
        my $asset = MT::Asset->load( { id => \@asset_ids } );
        my $encoded_label
            = MT::Util::encode_html( $asset->label, $can_double_encode );
        my $edit_link = _edit_link( $app, $asset );
        return qq{<a href="$edit_link">$encoded_label</a>};
    }
    elsif ( $asset_count > 1 ) {
        my $href = $app->uri(
            mode => 'list',
            args => {
                _type           => 'asset',
                blog_id         => $app->blog->id,
                filter          => 'content_field',
                filter_val      => $field_id,
                content_data_id => $cd_id,
            },
        );
        return
              qq{<a href="$href">(}
            . $app->translate( 'Show all [_1] assets', $asset_count )
            . ')</a>';
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

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options          = $field_data->{options} || {};
    my $field_label      = $options->{label};
    my $field_type       = $field_data->{type};
    my $field_type_label = $field_data->{type_label};

    my $iter = MT::Asset->load_iter(
        {   id => @{ $data || [] } ? $data : 0,
            blog_id => $app->blog->id,
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
            "You must select or upload correct assets for field '[_1]' that has asset type '[_2]'.",
            $field_label, $field_type_label
        );
    }

    my $type_label_plural = $field_type . 's';
    MT::ContentFieldType::Common::ss_validator_multiple( @_,
        $field_type_label, $type_label_plural );
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $multiple = $options->{multiple};
    if ($multiple) {
        my $min = $options->{min};
        return $app->translate(
            "A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
            $label, $field_label
        ) if '' ne $min and $min !~ /^\d+$/;

        my $max = $options->{max};
        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
            $label,
            $field_label
        ) if '' ne $max and ( $max !~ /^\d+$/ or $max < 1 );

        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.",
            $label,
            $field_label
            )
            if '' ne $min
            and '' ne $max
            and $max < $min;
    }

    return;
}

sub field_value_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $asset = $ctx->stash('asset');
    return $asset ? $asset->id : '';
}

sub feed_value_handler {
    my ( $app, $field_data, $values ) = @_;

    my $asset_ids = 0;
    if ($values) {
        if ( ref $values eq 'ARRAY' ) {
            $asset_ids = @$values ? $values : 0;
        }
        else {
            $asset_ids = $values || 0;
        }
    }
    my @assets = MT->model('asset')->load(
        { id => $asset_ids, class => '*' },
        { fetchonly => { id => 1, label => 1 } },
    );
    my %label_hash = map { $_->id => $_->label } @assets;

    my $contents = '';
    for my $id (@$values) {
        my $label = $label_hash{$id};
        $label = '' unless defined $label && $label ne '';
        my $encoded_label = MT::Util::encode_html($label);
        $contents .= "<li>$encoded_label (ID:$id)</li>";
    }

    return "<ul>$contents</ul>";
}

sub preview_handler {
    my ( $field_data, $values, $content_data ) = @_;
    return '' unless $values;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    return '' unless @$values;

    my @assets = MT->model('asset')->load( { id => $values, class => '*' } );
    my %asset_hash = map { $_->id => $_ } @assets;

    require MT::FileMgr;
    my $fmgr       = MT::FileMgr->new('Local');
    my $static_uri = MT->static_path;

    my $contents = '';
    for my $id (@$values) {
        my $asset = $asset_hash{$id} or next;

        my $label = $asset->label;
        $label = '' unless defined $label && $label ne '';
        my $encoded_label = MT::Util::encode_html($label);

        my $svg_class
            = $asset->class eq 'file'  ? 'default'
            : $asset->class eq 'video' ? 'movie'
            :                            $asset->class;

        if ( $fmgr->exists( $asset->file_path ) ) {
            my ( $url, $w, $h ) = $asset->thumbnail_url(
                Width  => 60,
                Height => 60,
                Square => 1
            );

            if ($url) {
                $contents .= qq{
                        <li>
                            <img class="img-thumbnail p-0" width="60" height="60" src="$url" loading="lazy" decoding="async">
                            <span>$encoded_label (ID:$id)</span>
                        </li>
                    };
            }
            else {
                my $svg
                    = qq{<img src="${static_uri}images/file-$svg_class.svg" width="60" height="60" loading="lazy" decoding="async">};
                $contents .= qq{
                    <li>
                        $svg
                        <span>$encoded_label (ID:$id)</span>
                    </li>
                };
            }
        }
        else {
            my $svg = qq{
              <div class="mt-user">
                <img src="${static_uri}images/file-$svg_class.svg" width="60" height="60" loading="lazy" decoding="async">
                <div class="mt-user__badge--warning">
                  <svg class="mt-icon--inverse mt-icon--sm">
                    <title>Warning</title>
                    <use xlink:href="${static_uri}images/sprite.svg#ic_error"></use>
                  </svg>
                </div>
              </div>
            };
            $contents .= qq{
                <li>
                    $svg
                    <span>$encoded_label (ID:$id)</span>
                </li>
            };
        }
    }

    return qq{<ul class="list-unstyled">$contents</ul>};
}

sub site_data_import_handler {
    my ( $field_data, $field_value, $content_data, $all_objects ) = @_;
    return unless $field_value;
    my @old_asset_ids
        = ref $field_value eq 'ARRAY' ? @$field_value : ($field_value);
    my @new_asset_ids = map { $_->id }
        grep {$_} map { $all_objects->{"MT::Asset#$_"} } @old_asset_ids;
    @new_asset_ids ? \@new_asset_ids : undef;
}

1;
