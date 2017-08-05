package MT::Theme::ContentType;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentType;

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $content_types = $element->{data} || {};

    for my $ct_key ( keys %{$content_types} ) {
        my $ct_value = $content_types->{$ct_key};

        my $ct = MT::ContentType->new(
            name => defined( $ct_value->{name} )
            ? $ct_value->{name}
            : $ct_key,
            description      => $ct_value->{description},
            user_disp_option => $ct_value->{user_disp_option} ? 1 : 0,
            unique_id        => $ct_value->{unique_id},
            blog_id          => $blog->id,
        );
        $ct->save or die $ct->errstr;

        my $order = 1;
        my @fields;
        for my $cf_value ( @{ $ct_value->{fields} || [] } ) {
            my $cf = MT::ContentField->new(
                name            => $cf_value->{label},
                description     => $cf_value->{description},
                type            => $cf_value->{type},
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
            );
            $cf->save or die $cf->errstr;

            my $field = {
                id        => $cf->id,
                type      => $cf->type,
                unique_id => $cf->unique_id,
                order     => $order,
                options   => {},
            };
            for my $cf_value_key ( keys %{$cf_value} ) {
                next if $cf_value_key eq 'type';
                $field->{options}{$cf_value_key} = $cf_value->{$cf_value_key};
            }
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
    my $content_type_count = scalar %{ $element->{data} };
    sub {
        MT->translate( '[_1] content types.', $content_type_count );
    };
}

sub validator {
    my ( $element, $theme, $blog ) = @_;
    my $content_types = $element->{data};

    my @unique_ids
        = grep {$_} map { $_->{unique_id} } values %{$content_types};
    if ( @unique_ids
        && MT::ContentType->exist( { unique_id => \@unique_ids } ) )
    {
        return $element->trans_error(
            'some content type in this theme have been installed already.');
    }

    1;
}

1;
