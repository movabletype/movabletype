# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentData::Validator;
use strict;
use warnings;

sub verify_content_data {
    my ( $app, $content_type, $cd ) = @_;
    my $content_field_types = $app->registry('content_field_types');
    my @errors = ();

    my $data = $cd->data;
    foreach my $f ( @{ $content_type->fields } ) {
        my $field_type  = $content_field_types->{ $f->{type} };
        my $options     = $f->{options};
        my $val         = $data->{ $f->{id} };

        my $not_fill_in_error;
        if ( exists($options->{required}) and $options->{required} ) {
            if ( not _is_filled_in($f, $val) ) {
                my $field_label = $f->{options}{label};
                $not_fill_in_error = $app->translate(
                    '"[_1]" is required field.',
                    $field_label );
            }
        }

        if ( $not_fill_in_error ) {
            push @errors,
                {
                field_id => $f->{id},
                error    => $not_fill_in_error
                };
        } elsif ( my $ss_validator = $field_type->{ss_validator} ) {
            if ( !ref $ss_validator ) {
                $ss_validator = $app->handler_to_coderef($ss_validator);
            }
            if ( 'CODE' eq ref $ss_validator ) {
                if ( my $error = $ss_validator->( $app, $f, $val ) ) {
                    push @errors,
                        {
                        field_id => $f->{id},
                        error    => $error,
                        };
                }
            }
        }
    }

    return @errors ? \@errors : undef;
}

sub _is_filled_in {
    my ( $f, $val ) = @_;

    if ( !defined($val) ) {
        return 0;
    } elsif ( ref($val) eq 'ARRAY' ) {
        if ( ($f->{type} eq 'select_box') and (@{$val} == 1) ) {
            return $val->[0] ne '';
        } else {
            return 0 < scalar(@{$val});
        }
    } else {
        return $val ne '';
    }
}

1;
