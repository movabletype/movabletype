# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Common;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw(
    get_cd_ids_by_inner_join
    get_cd_ids_by_left_join
    field_type_icon
);

use MT;
use MT::Util;

sub get_cd_ids_by_inner_join {
    my $prop       = shift;
    my $join_terms = shift || {};
    my $join_args  = shift || {};
    my ( $args, $db_terms, $db_args ) = @_;

    my $join = MT->model('content_field_index')->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
            %{$join_terms},
        },
        {   unique => 1,
            %{$join_args},
        },
    );
    _get_cd_ids( $db_terms, $join );
}

sub get_cd_ids_by_left_join {
    my $prop       = shift;
    my $join_terms = shift;
    my $join_args  = shift || {};
    my ( $args, $db_terms, $db_args ) = @_;

    my $join = MT->model('content_field_index')->join_on(
        undef,
        $join_terms,
        {   type      => 'left',
            condition => {
                content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            unique => 1,
            %{$join_args},
        }
    );
    _get_cd_ids( $db_terms, $join );
}

sub field_type_icon {
    my ( $id, $title ) = @_;

    $id = 'ic_contentstype' unless $id;
    if ($title) {
        $title = qq {<title>$title</title>};
    }
    else {
        $title = '';
    }

    my $static_uri = MT->static_path;

    return
        qq{<svg role="img" class="mt-icon">$title<use xlink:href="${static_uri}images/sprite.svg#$id"></use></svg>};
}

sub _get_cd_ids {
    my ( $db_terms, $join ) = @_;
    my @cd_ids;
    my $iter = MT->model('content_data')
        ->load_iter( $db_terms, { join => $join, fetchonly => { id => 1 } } );
    while ( my $cd = $iter->() ) {
        push @cd_ids, $cd->id;
    }
    @cd_ids ? \@cd_ids : 0;
}

sub terms_text {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids     = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub terms_datetime {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids     = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub terms_multiple {
    my $prop = shift;
    my ( $args, $base_terms, $base_args, $opts ) = @_;

    my $val       = $args->{value};
    my $data_type = $prop->{data_type};

    my $join_terms = { "value_${data_type}" => $val };
    my $cd_ids = get_cd_ids_by_inner_join( $prop, $join_terms, undef, @_ );

    if ( $args->{option} && $args->{option} eq 'is_not_selected' ) {
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        { id => $cd_ids };
    }
}

sub filter_tmpl_multiple {
    return <<'__TMPL__';
<mt:setvarblock name="select_options">
<select class="custom-select form-control <mt:var name="type">-option">
  <option value="is_selected"><__trans phrase="is selected" encode_html="1"></option>
  <option value="is_not_selected"><__trans phrase="is not selected" encode_html="1"></option>
</select>
</mt:setvarblock>
<__trans phrase="In [_1] column, [_2] [_3]"
         params="<mt:var name="label">%%
                 <select class="custom-select form-control <mt:var name="type">-value">
                 <mt:loop name="single_select_options">
                   <option value="<mt:var name="value" encode_html="1">"><mt:var name="label" encode_html="1" ></option>
                 </mt:loop>
                 </select>%%<mt:var name="select_options">">
__TMPL__
}

sub data_load_handler_multiple {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    [ $app->multi_param("content-field-${field_id}") ];
}

sub data_load_handler_asset {
    my ( $app, $field_data ) = @_;
    my $field_id  = $field_data->{id};
    my @asset_ids = $app->multi_param( 'content-field-' . $field_id );
    \@asset_ids;
}

sub ss_validator_datetime {
    my ( $app, $field_data, $data ) = @_;

    unless ( !defined $data
        || $data eq ''
        || ( MT::Util::is_valid_date($data) && length($data) == 14 ) )
    {
        my $field_type  = $field_data->{type};
        my $field_label = $field_data->{options}{label};

        return $app->translate( 'Invalid [_1] in "[_2]" field.',
            $field_type, $field_label );
    }

    undef;
}

sub ss_validator_multiple {
    my ( $app, $field_data, $data, $type_label, $type_label_plural ) = @_;

    if ( !defined $type_label_plural ) {
        if ( defined $type_label ) {
            $type_label_plural = $type_label;
        }
        else {
            $type_label        = 'option';
            $type_label_plural = 'options';
        }
    }

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};

    $data = [] unless defined $data;
    if ( $multiple && $max && @{$data} > $max ) {
        return $app->translate(
            '[_1] less than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $max, $field_label
        );
    }
    elsif ( $multiple && $min && @{$data} < $min ) {
        return $app->translate(
            '[_1] greater than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $min, $field_label
        );
    }
    if ( !$multiple && @{$data} >= 2 ) {
        return $app->translate(
            'Only 1 [_1] can be selected in "[_2]" field.',
            lc($type_label), $field_label );
    }

    exists $options->{values} ? ss_validator_values(@_) : undef;
}

sub ss_validator_values {
    my ( $app, $field_data, $data ) = @_;
    return undef unless defined $data && $data ne '';
    $data = [$data] unless ref $data eq 'ARRAY';

    my $options      = $field_data->{options} || {};
    my @valid_values = map { $_->{value} }
        grep { $_ && ref $_ eq 'HASH' } @{ $options->{values} || [] };

    my @invalid_values;
    for my $d ( @{$data} ) {
        unless ( grep { $_ eq $d } @valid_values ) {
            push @invalid_values, $d;
        }
    }

    if (@invalid_values) {
        my $invalid_values = join ', ', sort(@invalid_values);
        my $field_label    = $options->{label};
        return $app->translate( 'Invalid values in "[_1]" field: [_2]',
            $field_label, $invalid_values );
    }

    undef;
}

sub ss_validator_number_common {
    my ( $app, $field_data, $data ) = @_;

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $max_value   = $options->{max_value};
    my $min_value   = $options->{min_value};

    if ( defined $max_value && $max_value ne '' ) {
        if ( $data > $max_value ) {
            return $app->translate(
                '"[_1]" field value must be less than or equal to [_2].',
                $field_label, $max_value );
        }
    }
    if ( defined $min_value && $min_value ne '' ) {
        if ( $data < $min_value ) {
            return $app->translate(
                '"[_1]" field value must be greater than or equal to [_2]',
                $field_label, $min_value );
        }
    }

    undef;
}

sub html_multiple {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $content_field
        = MT->model('content_field')->load( $prop->content_field_id );
    my %label_hash = map { $_->{value} => $_->{label} }
        @{ $content_field->options->{values} };

    my $values = $content_data->data->{ $prop->content_field_id } || [];
    $values = [$values] unless ref $values eq 'ARRAY';

    my $can_double_encode = 1;
    my @labels
        = map { MT::Util::encode_html( $label_hash{$_}, $can_double_encode ) }
        @{$values};

    join ', ', @labels;
}

sub html_datetime_common {
    my $prop = shift;
    my ( $obj, $app, $opts, $date_format ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    my $content_field
        = MT->model('content_field')->load( $prop->{content_field_id} )
        or return '';
    $date_format = eval { $content_field->options->{date_format} }
        || $date_format;
    return '' unless $date_format;

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );

}

sub html_text {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $content_field
        = MT->model('content_field')->load( $prop->content_field_id );
    my $text = $content_data->data->{ $prop->content_field_id };
    return '' unless defined $text;

    if ( length $text > 40 ) {
        return MT::Util::encode_html( substr( $text, 0, 40 ) ) . '...';
    }
    else {
        return MT::Util::encode_html($text);
    }
}

sub single_select_options_multiple {
    my $prop = shift;
    my $app  = shift || MT->app;

    my $content_field_id = $prop->{content_field_id};
    my $content_field = MT->model('content_field')->load($content_field_id);
    return $content_field->options->{values} || [];
}

sub tag_handler_multiple {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};
    my $out     = '';
    my $i       = 1;
    my $glue    = $args->{glue};

    my @values;
    if ( defined $value ) {
        if ( ref $value eq 'ARRAY' ) {
            @values = @$value;
        }
        else {
            @values = ($value);
        }
    }

    my %value_label_hash = map { $_->{value} => $_->{label} }
        @{ $field_data->{options}{values} || [] };

    for my $v (@values) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @values;
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        local $vars->{__key__}     = $value_label_hash{$v};
        local $vars->{__value__}   = $v;

        defined(
            my $res = $builder->build(
                $ctx, $tok,
                {   %{$cond},
                    ContentFieldHeader => $i == 1,
                    ContentFieldFooter => $i == scalar @values,
                }
            )
        ) or return $ctx->error( $builder->errstr );

        if ( $res ne '' ) {
            $out .= $glue
                if defined $glue && $i > 1 && length($out) && length($res);
            $out .= $res;
            $i++;
        }
    }

    $out;
}

sub tag_handler_asset {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    my $asset_terms = {
        id     => @$value ? $value : 0,
        class  => '*',
    };
    my $iter = MT->model('asset')->load_iter( $asset_terms );
    my %assets;
    while ( my $asset = $iter->() ) {
        $assets{ $asset->id } = $asset;
    }
    my @ordered_assets = grep {$_} map { $assets{$_} } @{$value};

    local $ctx->{__stash}{assets} = \@ordered_assets;
    local $args->{sort_order} = 'none'
        if !exists $args->{sort_by} && !exists $args->{sort_order};

    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $glue    = $args->{glue};
    my $per_row = $args->{assets_per_row} || 0;
    $per_row -= 1 if $per_row;
    my $row_count   = 0;
    my $i           = 0;
    my $total_count = @ordered_assets;
    my $vars        = $ctx->{__stash}{vars} ||= {};

    MT::Meta::Proxy->bulk_load_meta_objects( \@ordered_assets );
    for my $asset (@ordered_assets) {
        local $ctx->{__stash}{asset} = $asset;
        local $vars->{__first__}     = !$i;
        local $vars->{__last__}      = !defined $ordered_assets[ $i + 1 ];
        local $vars->{__odd__}     = ( $i % 2 ) == 0;    # 0-based $i
        local $vars->{__even__}    = ( $i % 2 ) == 1;
        local $vars->{__counter__} = $i + 1;
        my $f = $row_count == 0;
        my $l = $row_count == $per_row;
        $l = 1 if ( ( $i + 1 ) == $total_count );
        my $out = $builder->build(
            $ctx, $tok,
            {   %$cond,
                AssetIsFirstInRow  => $f,
                AssetIsLastInRow   => $l,
                AssetsHeader       => !$i,
                AssetsFooter       => !defined $ordered_assets[ $i + 1 ],
                ContentFieldHeader => !$i,
                ContentFieldFooter => !defined $ordered_assets[ $i + 1 ],
            }
        );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $glue if defined $glue && length($res) && length($out);
        $res .= $out;
        $row_count++;
        $row_count = 0 if $row_count > $per_row;
        $i++;
    }
    if ( !@ordered_assets ) {
        return $ctx->_hdlr_pass_tokens_else(@_);
    }

    $res;
}

sub field_value_handler_datetime {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};

    my $field_type = $field_data->{type};

    local $args->{format} = '%x'
        if $field_type eq 'date_only' && !_has_some_modifier($args);
    local $args->{format} = '%X'
        if $field_type eq 'time_only' && !_has_some_modifier($args);

    local $args->{ts} = $value;

    return $ctx->build_date($args);
}

sub _has_some_modifier {
    my $args     = shift;
    my %arg_keys = map { $_ => 1 } keys %{ $args || {} };
    delete $arg_keys{$_} for qw( convert_breaks words @ );
    %arg_keys ? 1 : 0;
}

sub feed_value_handler_multiple {
    my ( $app, $field_data, $values ) = @_;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    my %value_label_hash = map { $_->{value} => $_->{label} }
        @{ $field_data->{options}{values} || [] };

    my $contents = '';
    for my $v (@$values) {
        next unless defined $v && $v ne '';
        my $encoded_v     = MT::Util::encode_html($v);
        my $encoded_label = MT::Util::encode_html( $value_label_hash{$v} );
        $contents .= "<li>$encoded_label($encoded_v)</li>";
    }
    return "<ul>$contents</ul>";
}

sub preview_handler_multiple {
    my ( $field_data, $values, $content_data ) = @_;
    return '' unless $values;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    return '' unless @$values;

    my %value_label_hash = map { $_->{value} => $_->{label} }
        @{ $field_data->{options}{values} || [] };

    my $contents = '';
    for my $v (@$values) {
        my $encoded_v     = MT::Util::encode_html($v);
        my $encoded_label = MT::Util::encode_html( $value_label_hash{$v} );
        $contents .= "<li>$encoded_label ($encoded_v)</li>";
    }
    return qq{<ul class="list-unstyled">$contents</ul>};
}

sub search_handler_multiple {
    my ( $search_regex, $field_data, $values, $content_data ) = @_;
    $values = ''        unless defined $values;
    $values = [$values] unless ref $values eq 'ARRAY';
    my %value_label_hash = map { $_->{value} => $_->{label} }
        @{ $field_data->{options}{values} || [] };
    for my $value (@$values) {
        $value = '' unless defined $value;
        my $label = $value_label_hash{$value};
        $label = '' unless defined $label;
        return 1 if $value =~ /$search_regex/ || $label =~ /$search_regex/;
    }
    0;
}

sub search_handler_reference {
    my ( $search_regex, $field_data, $raw_object_ids, $content_data ) = @_;
    return 0 unless $raw_object_ids;
    my @object_ids
        = ref $raw_object_ids eq 'ARRAY'
        ? @$raw_object_ids
        : ($raw_object_ids);
    return 0 unless @object_ids;
    my $field_registry
        = MT->registry( 'content_field_types', $field_data->{type} );
    my $iter = MT->model( $field_registry->{search_class} )
        ->load_iter( { id => \@object_ids } );
    while ( my $obj = $iter->() ) {
        for my $col ( @{ $field_registry->{search_columns} } ) {
            my $text = defined $obj->$col ? $obj->$col : '';
            return 1 if $text =~ /$search_regex/;
        }
    }
    0;
}

1;

