# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::MultiLineText;
use strict;
use warnings;

use JSON ();
use MT::I18N qw( first_n_text const );


sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $options        = $field_data->{options};
    my $input_format = $options->{input_format};
    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   convert_breaks => $input_format,
        required       => $required,
    };

}

sub theme_data_import_handler {
    my ( $theme, $blog, $ct, $cf_type, $field, $field_data, $data,
        $convert_breaks )
        = @_;

    if ( ref $field_data eq 'HASH' ) {
        $convert_breaks->{ $field->{id} } = $field_data->{convert_breaks};
    }
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    my $convert_breaks
        = $app->param("content-field-${field_id}_convert_breaks");
    $convert_breaks = '' unless defined $convert_breaks;

    if ( $convert_breaks eq 'blockeditor' ) {
        my $data_json = $app->param('block_editor_data');
        my $data_obj;
        my $html = "";
        my @blockdata;
        if ($data_json) {
            $data_obj = JSON->new->utf8(0)->decode($data_json);
            my $editor_id = 'editor-input-content-field-' . $field_id;
            while ( my ( $block_id, $block_data )
                = each( %{ $data_obj->{$editor_id} } ) )
            {
                push( @blockdata, $block_data );
            }
            @blockdata = sort { $a->{order} <=> $b->{order} } @blockdata;
            foreach my $val (@blockdata) {
                $html .= $val->{html};
                $html .= "\n";
            }
        }
        return $html;
    }
    elsif ( $convert_breaks eq 'richtext' ) {
        return scalar $app->param("editor-input-content-field-$field_id");
    }
    else {
        return scalar $app->param("content-field-multi-$field_id");
    }

}

sub options_html_params {
    my ( $app, $param ) = @_;
    my $filters = MT->all_text_filters;

    my @text_filters;
    for my $filter ( keys %$filters ) {
        push @text_filters,
            {
            filter_key   => $filter,
            filter_label => $filters->{$filter}{label},
            };
    }
    @text_filters
        = sort { $a->{filter_key} cmp $b->{filter_key} } @text_filters;
    unshift @text_filters,
        {
        filter_key   => '0',
        filter_label => $app->translate('None'),
        };
    return { text_filters => \@text_filters };
}

sub field_value_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    if ( exists $args->{words} ) {
        $value = first_n_text( $value, $args->{words} );
    }
    elsif ( exists $args->{convert_breaks} ) {
        my $content_data = $ctx->stash('content')
            or return $ctx->_no_content_error;
        my $convert_breaks
            = $content_data
            ? MT::Serialize->unserialize( $content_data->convert_breaks )
            : undef;
        my $filters
            = $convert_breaks ? $$convert_breaks->{ $field_data->{id} } : '';
        $value = MT->apply_text_filters( $value, [$filters], $ctx );
    }

    return $value;
}

1;
