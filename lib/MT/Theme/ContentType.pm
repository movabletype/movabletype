package MT::Theme::ContentType;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentType;

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $content_types = $element->{data} || [];

    my $current_lang = MT->current_language;

    for my $ct_value ( @{$content_types} ) {
        MT->set_language( $blog->language );
        my $ct = MT::ContentType->new(
            name => $theme->translate_templatized( $ct_value->{name} ),
            description =>
                $theme->translate_templatized( $ct_value->{description} ),
            user_disp_option => $ct_value->{user_disp_option} ? 1 : 0,
            unique_id        => $ct_value->{unique_id},
            blog_id          => $blog->id,
        );
        MT->set_language($current_lang);

        $ct->save or die $ct->errstr;

        my $order = 1;
        my @fields;
        for my $cf_value ( @{ $ct_value->{fields} || [] } ) {
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
                $field->{options}{$cf_value_key}
                    = $theme->translate_templatized(
                    $cf_value->{$cf_value_key} );
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
                $handler->( $theme, $blog, $ct, $cf_value, $field );
            }

            MT->set_language($current_lang);

            push @fields, $field;

            $order++;
        }

        $ct->fields( \@fields );
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

    my @unique_ids
        = grep {$_} map { $_->{unique_id} } @{$content_types};
    if ( @unique_ids
        && MT::ContentType->exist( { unique_id => \@unique_ids } ) )
    {
        return $element->trans_error(
            'some content type in this theme have been installed already.');
    }

    1;
}

1;
