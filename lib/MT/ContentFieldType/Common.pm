# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
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
);

use MT;
use MT::Asset;
use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::Util ();

sub get_cd_ids_by_inner_join {
    my $prop       = shift;
    my $join_terms = shift || {};
    my $join_args  = shift || {};
    my ( $args, $db_terms, $db_args ) = @_;

    my $join = MT::ContentFieldIndex->join_on(
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

    my $join = MT::ContentFieldIndex->join_on(
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

sub _get_cd_ids {
    my ( $db_terms, $join ) = @_;
    my @cd_ids;
    my $iter = MT::ContentData->load_iter( $db_terms,
        { join => $join, fetchonly => { id => 1 } } );
    while ( my $cd = $iter->() ) {
        push @cd_ids, $cd->id;
    }
    @cd_ids ? \@cd_ids : 0;
}

sub terms_text {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub terms_datetime {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
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
  <option value="is_selected"><__trans phrase="is selected" escape="js"></option>
  <option value="is_not_selected"><__trans phrase="is not selected" escape="js"></option>
</select>
</mt:setvarblock>
<__trans phrase="In [_1] column, [_2] [_3]"
         params="<mt:var name="label" escape="js">%%
                 <select class="custom-select form-control <mt:var name="type">-value">
                 <mt:loop name="single_select_options">
                   <option value="<mt:var name="value">"><mt:var name="label" encode_html="1" encode_js="1" encode_html="1" ></option>
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
    my $field_id = $field_data->{id};
    my $asset_ids = $app->param( 'content-field-' . $field_id ) || '';
    [ split ',', $asset_ids ];
}

sub ss_validator_datetime {
    my ( $app, $field_data, $data ) = @_;

    unless ( !defined $data || $data eq '' || MT::Util::is_valid_date($data) )
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

    my $options = $field_data->{options} || {};
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
        my $field_label = $options->{label};
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

    my $content_field = MT::ContentField->load( $prop->content_field_id );
    my %label_hash = map { $_->{value} => $_->{label} }
        @{ $content_field->options->{values} };

    my $values = $content_data->data->{ $prop->content_field_id } || [];
    $values = [$values] unless ref $values eq 'ARRAY';
    my @labels = map { $label_hash{$_} } @{$values};

    join ', ', @labels;
}

sub html_datetime_common {
    my $prop = shift;
    my ( $obj, $app, $opts, $date_format ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    my $content_field = MT::ContentField->load( $prop->{content_field_id} )
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

sub single_select_options_multiple {
    my $prop = shift;
    my $app = shift || MT->app;

    my $content_field_id = $prop->{content_field_id};
    my $content_field    = MT::ContentField->load($content_field_id);
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

    my $asset_class
        = $field_data->{type} eq 'asset' ? 'file' : $field_data->{type};
    $asset_class =~ s/^asset_(.*)/$1/;
    my $asset_terms = {
        id     => $value,
        class  => $asset_class,
        parent => \'IS NULL',
    };
    my $asset_args = { null => { parent => 1 } };

    my $iter = MT::Asset->load_iter( $asset_terms, $asset_args );
    my %assets;
    while ( my $asset = $iter->() ) {
        $assets{ $asset->id } = $asset;
    }
    my @ordered_assets = map { $assets{$_} } @{$value};

    local $ctx->{__stash}{assets} = \@ordered_assets;
    local $args->{sort_order} = 'none'
        if !exists $args->{sort_by} && !exists $args->{sort_order};

    $ctx->invoke_handler( 'assets', $args, $cond );
}

sub tag_handler_content_type {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    my $content_type = $ctx->stash('content_type')
        or return $ctx->_no_content_type_error;
    my $content_data = $ctx->stash('content')
        or return $ctx->_no_content_error;

    my $ids = $content_data->data->{ $field_data->{id} };
    my @archive_contents
        = MT->model('content_data')->load( { id => $ids } );
    local $ctx->{__stash}{archive_contents} = \@archive_contents;

    $ctx->invoke_handler( 'contents', $args, $cond );
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
    my $args = shift;
    my %arg_keys = map { $_ => 1 } keys %{ $args || {} };
    delete $arg_keys{$_} for qw( convert_breaks words @ );
    %arg_keys ? 1 : 0;
}

sub feed_value_handler_multiple {
    my ( $app, $field_data, $values ) = @_;
    my %value_label_hash = map { $_->{value} => $_->{label} }
        @{ $field_data->{options}{values} || [] };

    my $contents = '';
    for my $v (@$values) {
        my $label = $value_label_hash{$v};
        $contents .= "<li>$label($v)</li>";
    }
    return "<ul>$contents</ul>";
}

1;

