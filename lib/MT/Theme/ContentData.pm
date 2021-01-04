# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::ContentData;
use strict;
use warnings;

use MT;
use MT::ContentData;
use MT::ContentStatus;
use MT::ContentType;
use MT::Serialize;
use MT::Theme::Common qw( get_author_id );

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $data = $element->{data} || {};

    my $author_id = get_author_id($blog);
    die "Failed to create theme default content data"
        unless defined $author_id;

    my $current_lang = MT->current_language;
    MT->set_language( $blog->language );

    for my $ct_name_or_unique_id ( keys %{$data} ) {

        my $ct
            = MT::ContentType->load( { unique_id => $ct_name_or_unique_id } );
        $ct ||= MT::ContentType->load(
            {   blog_id => $blog->id,
                name => $theme->translate_templatized($ct_name_or_unique_id),
            }
        );

        if ( !$ct ) {
            MT->set_language($current_lang);
            die MT->translate( 'Failed to find content type: [_1]',
                $ct_name_or_unique_id );
        }

        my $content_field_types = MT->registry('content_field_types');
        my $content_fields      = $ct->fields;

        my $content_data = $data->{$ct_name_or_unique_id};
        for my $ct_key ( keys %{$content_data} ) {
            my $ct_value = $content_data->{$ct_key};

            my $label
                = defined( $ct_value->{label} )
                ? $theme->translate_templatized( $ct_value->{label} )
                : '';
            my $identifier
                = defined $ct_value->{identifier}
                ? $ct_value->{identifier}
                : $ct_key;

            next
                if MT::ContentData->exist(
                {   blog_id => $blog->id,
                    label   => $label,
                }
                );
            next
                if MT::ContentData->exist(
                {   blog_id    => $blog->id,
                    identifier => $identifier,
                }
                );

            my $cd = MT::ContentData->new;
            $cd->set_values(
                {   author_id       => $author_id,
                    blog_id         => $blog->id,
                    content_type_id => $ct->id,
                    ct_unique_id    => $ct->unique_id,
                    identifier      => $identifier,
                    authored_on     => $ct_value->{authored_on},
                    unpublished_on  => $ct_value->{unpublished_on},
                    convert_breaks  => $ct_value->{convert_breaks},
                    status          => $ct_value->{status}
                        || MT::ContentStatus::RELEASE(),
                    label => defined( $ct_value->{label} )
                    ? $theme->translate_templatized( $ct_value->{label} )
                    : '',
                }
            );

            my $convert_breaks = {};
            my $data           = {};
            for my $f ( @{$content_fields} ) {
                my $cf_type = $content_field_types->{ $f->{type} };
                my $cf_name
                    = defined $f->{options}{label}
                    ? $f->{options}{label}
                    : '';

                next unless $ct_value->{data}{$cf_name};

                if ( ref $ct_value->{data}{$cf_name} eq 'HASH' ) {
                    $data->{ $f->{id} } = $ct_value->{data}{$cf_name}{value};
                }
                else {
                    $data->{ $f->{id} } = $ct_value->{data}{$cf_name};
                }
                unless ( ref $data->{ $f->{id} } ) {
                    $data->{ $f->{id} }
                        = $theme->translate_templatized(
                        $data->{ $f->{id} } );
                }

                if ( my $handler = $f->{theme_data_import_handler} ) {
                    if ( !ref $handler ) {
                        $handler = MT->handler_to_coderef($handler);
                    }
                    if ( !$handler || ref $handler ne 'CODE' ) {
                        die MT->translate(
                            'Invalid theme_data_import_handler of [_1].',
                            $f->{type} );
                    }
                    $handler->(
                        $theme, $blog, $ct, $cf_type, $f,
                        $ct_value->{data}{$cf_name},
                        $data, $convert_breaks
                    );
                }
            }
            $cd->data($data);
            $cd->convert_breaks(
                MT::Serialize->serialize( \$convert_breaks ) );

            $cd->save or die $cd->errstr;
        }
    }

    MT->set_language($current_lang);

    1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $content_data_count = scalar %{ $element->{data} };
    sub {
        MT->translate( '[_1] content data.', $content_data_count );
    };
}

1;
