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

    for my $key ( keys %{$data} ) {
        my ($ct_name, $ct_unique_id) = ($key, $key);
        if (exists $data->{$key}{__ct_name}) {
            $ct_name = delete $data->{$key}{__ct_name};
        }
        my $ct_name_or_unique_id = $key;

        my $ct;
        if ($ct_unique_id =~ /\A[a-zA-Z0-9]{40}\z/) {
            $ct = MT::ContentType->load( { unique_id => $ct_unique_id } );
        }
        $ct ||= MT::ContentType->load(
            {   blog_id => $blog->id,
                name => $theme->translate_templatized($ct_name),
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
        for my $cd_key ( keys %{$content_data} ) {
            my $cd_value = $content_data->{$cd_key};

            my $label
                = defined( $cd_value->{label} )
                ? $theme->translate_templatized( $cd_value->{label} )
                : '';
            my $identifier
                = defined $cd_value->{identifier}
                ? $cd_value->{identifier}
                : $cd_key;

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
                    authored_on     => $cd_value->{authored_on},
                    unpublished_on  => $cd_value->{unpublished_on},
                    convert_breaks  => $cd_value->{convert_breaks},
                    status          => $cd_value->{status}
                        || MT::ContentStatus::RELEASE(),
                    label => defined( $cd_value->{label} )
                    ? $theme->translate_templatized( $cd_value->{label} )
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

                next unless $cd_value->{data}{$cf_name};

                if ( ref $cd_value->{data}{$cf_name} eq 'HASH' ) {
                    $data->{ $f->{id} } = $cd_value->{data}{$cf_name}{value};
                }
                else {
                    $data->{ $f->{id} } = $cd_value->{data}{$cf_name};
                }
                unless ( ref $data->{ $f->{id} } ) {
                    $data->{ $f->{id} }
                        = $theme->translate_templatized(
                        $data->{ $f->{id} } );
                }

                if ( my $handler = $cf_type->{theme_data_import_handler} ) {
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
                        $cd_value->{data}{$cf_name},
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
