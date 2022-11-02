# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::App;

use strict;
use warnings;

use BlockEditor;
use MT::ContentFieldType::MultiLineText;

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $param = MT::ContentFieldType::MultiLineText->field_html_params( $app,
        $field_data );

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

    my $blog            = $app->blog;
    my $content_type_id = $app->param('content_type_id')
        or return $app->errtrans("Invalid request.");
    my $content_type = MT::ContentType->load($content_type_id)
        or return $app->errtrans('Invalid request.');

    my $data;
    if ( $app->param('_recover') && !$app->param('reedit') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $autosave_data = $sess_obj->thaw_data;
            if ($autosave_data) {
                $data = $autosave_data->{data};
            }
        }
    }

    if ( $app->param('reedit') ) {
        $data = $app->param('serialized_data');
        if ( $data && !ref $data ) {
            $data = JSON::decode_json($data);
        }
    }

    my $content_data_id = $app->param('id');

    my $content_data;
    if ($content_data_id) {
        $content_data = MT::ContentData->load(
            {   id              => $content_data_id,
                blog_id         => $content_type->blog_id,
                content_type_id => $content_type->id,
            }
            )
            or return $app->error(
            $app->translate(
                'Load failed: [_1]',
                MT::ContentData->errstr
                    || $app->translate('(no reason given)')
            )
            );

        if ( $blog->use_revision ) {

            my $original_revision = $content_data->revision;
            my $rn                = $app->param('r');
            if ( defined $rn && $rn != $content_data->current_revision ) {
                my $rev
                    = $content_data->load_revision( { rev_number => $rn } );
                if ( $rev && @$rev ) {
                    $content_data = $rev->[0];
                }
            }
        }
    }
    $data = $content_data->data if $content_data && !$data;
    my $convert_breaks
        = $content_data
        ? MT::Serialize->unserialize( $content_data->convert_breaks )
        : undef;

    my $blockeditor_data;
    if ( $app->param('block_editor_data') ) {
        $blockeditor_data = $app->param('block_editor_data');
    }
    else {
        if ($content_data) {
            $blockeditor_data = $content_data->block_editor_data();
        }
        elsif ( $content_data_id || $data ) {
            $blockeditor_data = $data->{block_editor_data};
        }
    }
    if ($blockeditor_data) {
        $param->{block_editor_data} = $blockeditor_data;
    }

    return $param;
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;

    my $field_id = $field_data->{id};
    my $options  = $field_data->{options} || {};
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
            my $editor_id
                = 'editor-input-content-field-' . $field_id . '-blockeditor';
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
    } else {
        require MT::ContentFieldType::MultiLineText;
        return MT::ContentFieldType::MultiLineText::data_load_handler(@_);
    }

}

sub pre_save_content_data {
    my ( $cb, $app, $content_data, $org_obj ) = @_;
    return 1 unless $app->mode eq 'save';
    my $block_editor_data = $app->param('block_editor_data');
    $content_data->block_editor_data($block_editor_data);
    1;
}

sub replace_handler {
    my ($search_regex, $replace_string, $field_data,
        $values,       $content_data
    ) = @_;

    return 0 unless defined $values;

    my $replaced = 0;

    $replaced += $values =~ s!$search_regex!$replace_string!g;

    my $convert_breaks
        = $field_data
        ? MT::Serialize->unserialize( $content_data->convert_breaks )
        : undef;
    if ( $$convert_breaks->{ $field_data->{id} } && $$convert_breaks->{ $field_data->{id} } eq 'blockeditor' ) {
        my $block_editor_data = $content_data->block_editor_data;
        my $data
            = eval { MT::Util::from_json( $content_data->block_editor_data ) };
        return unless $data && ref $data eq 'HASH' && %$data;

        my $editor_key
            = 'editor-input-content-field-'
            . $field_data->{id}
            . '-blockeditor';
        for my $key ( keys %{ $data->{$editor_key} } ) {
            $replaced += $data->{$editor_key}->{$key}->{value}
                =~ s!$search_regex!$replace_string!g;
            $replaced += $data->{$editor_key}->{$key}->{html}
                =~ s!$search_regex!$replace_string!g;

            # replace image
            if ( $data->{$editor_key}->{$key}->{type} eq 'image' ) {
                $replaced += $data->{$editor_key}->{$key}->{asset_url}
                    =~ s!$search_regex!$replace_string!g;

                # replace image options
                my $options = $data->{$editor_key}->{$key}->{options};
                if ( ref $options eq 'HASH' && %{$options} ) {
                    $replaced += $options->{alt}
                        =~ s!$search_regex!$replace_string!g;
                    $replaced += $options->{caption}
                        =~ s!$search_regex!$replace_string!g;
                    $replaced += $options->{title}
                        =~ s!$search_regex!$replace_string!g;
                }
            }
        }
        $content_data->block_editor_data( MT::Util::to_json($data) );
    }
    return ( $replaced > 0, $values );
}

sub search_handler {
    my ( $search_regex, $field_data, $values, $content_data ) = @_;
    return 0 unless defined $values;

    my $convert_breaks
        = $field_data
        ? MT::Serialize->unserialize( $content_data->convert_breaks )
        : undef;

    if ( ( $$convert_breaks->{ $field_data->{id} } || '' ) ne 'blockeditor' ) {
        return $search_regex ne '' ? $values =~ m!$search_regex! : 1;
    }

    my $block_editor_data = $content_data->block_editor_data;
    my $data
        = eval { MT::Util::from_json( $content_data->block_editor_data ) };
    return 0 unless $data && ref $data eq 'HASH' && %$data;

    my $editor_key
        = 'editor-input-content-field-' . $field_data->{id} . '-blockeditor';
    for my $key ( keys %{ $data->{$editor_key} } ) {
        return 1
            if $data->{$editor_key}->{$key}->{value} =~ /$search_regex/
            || $data->{$editor_key}->{$key}->{html}  =~ /$search_regex/;

        # parts image
        if ( $data->{$editor_key}->{$key}->{type} eq 'image' ) {
            return 1
                if $data->{$editor_key}->{$key}->{asset_url} =~ $search_regex;

            # search image options
            my $options = $data->{$editor_key}->{$key}->{options};
            if ( ref $options eq 'HASH' && %{$options} ) {
                return 1
                    if $options->{alt}     =~ /$search_regex/
                    || $options->{caption} =~ /$search_regex/
                    || $options->{title}   =~ /$search_regex/;
            }
        }
    }
    return 0;
}

1;
