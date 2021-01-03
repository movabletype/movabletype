# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::ContentType;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentType;

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $content_types = $element->{data} || [];

    my $content_field_types = MT->registry('content_field_types');

    my $current_lang = MT->current_language;

    for my $ct_value ( @{$content_types} ) {

        MT->set_language( $blog->language );

        my $name = $theme->translate_templatized( $ct_value->{name} );

        if ( MT::ContentType->exist( { blog_id => $blog->id, name => $name } )
            )
        {
            MT->set_language($current_lang);
            next;
        }

        my $ct = MT::ContentType->new(
            name => $name,
            description =>
                $theme->translate_templatized( $ct_value->{description} ),
            user_disp_option => $ct_value->{user_disp_option} ? 1 : 0,
            blog_id => $blog->id,
        );
        MT->set_language($current_lang);

        $ct->save or die $ct->errstr;

        my $order = 1;
        my @fields;
        my $data_label_field_uid;
        for my $cf_value ( @{ $ct_value->{fields} || [] } ) {
            next
                unless defined $content_field_types->{ $cf_value->{type} }
                && $content_field_types->{ $cf_value->{type} } ne '';

            MT->set_language( $blog->language );
            my $cf = MT::ContentField->new(
                name => $theme->translate_templatized( $cf_value->{label} ),
                description =>
                    $theme->translate_templatized( $cf_value->{description} ),
                type            => $cf_value->{type},
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
            );
            MT->set_language($current_lang);

            $cf->save or die $cf->errstr;

            $data_label_field_uid = $cf->unique_id
                if $cf_value->{data_label};

            my $field = {
                id        => $cf->id,
                type      => $cf->type,
                unique_id => $cf->unique_id,
                order     => $order,
                options   => {},
            };

            MT->set_language( $blog->language );
            for my $cf_value_key ( keys %{$cf_value} ) {
                next if $cf_value_key eq 'type';
                if ( ref $cf_value->{$cf_value_key} ) {
                    $field->{options}{$cf_value_key}
                        = $cf_value->{$cf_value_key};
                }
                else {
                    $field->{options}{$cf_value_key}
                        = $theme->translate_templatized(
                        $cf_value->{$cf_value_key} );
                }
            }

            my $type       = $cf_value->{type};
            my $field_type = MT->registry('content_field_types')->{$type};
            if ( my $handler = $field_type->{theme_import_handler} ) {
                if ( !ref $handler ) {
                    $handler = MT->handler_to_coderef($handler);
                }
                if ( !$handler || ref $handler ne 'CODE' ) {
                    die MT->translate(
                        'Invalid theme_import_handler of [_1].', $type );
                }
                $handler->( $theme, $blog, $ct, $cf_value, $field, $cf );
            }

            MT->set_language($current_lang);

            push @fields, $field;

            $order++;
        }

        $ct->fields( \@fields );
        $ct->data_label($data_label_field_uid)
            if $data_label_field_uid;
        $ct->save or die $ct->errstr;
    }

    1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $content_type_count = scalar @{ $element->{data} };
    sub {
        MT->translate( '[_1] content types.', $content_type_count );
    };
}

sub validator {
    my ( $element, $theme, $blog ) = @_;
    my $content_types = $element->{data};

    return 1 unless $blog;

    my $content_field_types = MT->registry('content_field_types');

    for my $ct ( @{$content_types} ) {
        next unless ref $ct->{fields} eq 'ARRAY' && @{ $ct->{fields} } > 0;

        my @valid_content_fields = grep {
            defined $content_field_types->{ $_->{type} }
                && $content_field_types->{ $_->{type} } ne ''
        } @{ $ct->{fields} };
        return $element->trans_error(
            'some content field in this theme has invalid type.')
            unless @valid_content_fields;
    }

    my @names = grep {$_} map { $_->{name} } @{$content_types};
    if (@names) {
        my $current_lang = MT->current_language;
        MT->set_language( $blog->language );

        @names = map { $theme->translate_templatized($_) } @names;

        if (MT::ContentType->exist(
                { blog_id => $blog->id, name => \@names }
            )
            )
        {
            MT->set_language($current_lang);
            return $element->trans_error(
                'some content type in this theme have been installed already.'
            );
        }

        MT->set_language($current_lang);
    }

    1;
}

sub template {
    my $app = shift;
    my ( $blog, $saved ) = @_;

    my @content_types
        = MT->model('content_type')->load( { blog_id => $blog->id } )
        or return;

    my %checked_ids
        = $saved
        ? map { $_ => 1 } @{ $saved->{default_content_type_export_ids} }
        : ();

    my @list;
    for my $ct (@content_types) {
        push @list,
            {
            content_type_id   => $ct->id,
            content_type_name => $ct->name,
            checked           => $saved ? $checked_ids{ $ct->id } : 1,
            };
    }

    my %param = ( content_types => \@list );
    return $app->load_tmpl( 'include/theme_exporters/content_type.tmpl',
        \%param );
}

sub export {
    my ( $app, $blog, $settings ) = @_;

    my $terms
        = defined $settings
        ? { id => $settings->{default_content_type_export_ids} }
        : { blog_id => $blog->id };
    my @content_types = MT->model('content_type')->load($terms);

    my @remove_fields = qw( id options type_label unique_id );

    my @data;
    for my $ct (@content_types) {
        my @fields;
        for my $f ( @{ $ct->fields } ) {
            my $type_registry
                = MT->registry('content_field_types')->{ $f->{type} };
            if ( my $hdlr = $type_registry->{theme_export_handler} ) {
                if ( ref $hdlr ne 'CODE' ) {
                    $hdlr = MT->handler_to_coderef($hdlr);
                }
                if ($hdlr) {
                    $hdlr->( $app, $blog, $settings, $ct, $f );
                }
            }
            push @fields,
                +{
                %{$f},
                %{ $f->{options} },
                (   ( $ct->data_label && $ct->data_label eq $f->{unique_id} )
                    ? ( data_label => 1 )
                    : ()
                ),
                };
            delete $fields[-1]{$_} for @remove_fields;
        }
        push @data,
            {
            description => $ct->description,
            @fields ? ( fields => \@fields ) : (),
            name             => $ct->name,
            user_disp_option => $ct->user_disp_option,
            };
    }

    @data ? \@data : undef;
}

sub condition {
    my ($blog) = @_;
    MT->model('content_type')->exist( { blog_id => $blog->id } );
}

1;
