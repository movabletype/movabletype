# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::ContentField;
use strict;
use warnings;

use Hash::Merge::Simple;

my %display_options = (
    force    => 1,
    default  => 1,
    optional => 1,
    none     => 1,
);

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    my $registry;
    my $type_registry;
    unless ( defined $obj->type && $obj->type ne '' ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'type' ) );
    }
    else {
        $registry = $app->registry('content_field_types');
        my %types = map { $_ => $registry->{$_} } keys %$registry;
        unless ( $type_registry = $types{ $obj->type } ) {
            return $app->error(
                $app->translate(
                    'A parameter "[_1]" is invalid: [_2]', 'type',
                    $obj->type
                )
            );
        }
    }

    unless ( defined $obj->name && $obj->name ne '' ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'label' ) );
    }

    my $hashes
        = $app->request('data_api_content_field_hashes_for_callback') || [];
    my $hash = shift @$hashes;
    $hash ||= {};
    $hash->{options} ||= {};

    my $options
        = Hash::Merge::Simple->merge( $obj->options, $hash->{options} );

    $options->{display} = 'default' unless exists $options->{display};
    my $display = $options->{display};
    if ( !$display ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is required.',
                'options{display}'
            )
        );
    }
    elsif ( !$display_options{$display} ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is invalid: [_2]', 'options{display}',
                $display
            )
        );
    }

    my %allowed_options_keys
        = map { $_ => 1 } @{ $type_registry->{options} || [] };
    if (%allowed_options_keys) {
        my @invalid_options_keys
            = grep { !$allowed_options_keys{$_} } keys %$options;
        if (@invalid_options_keys) {
            return $app->error(
                $app->translate(
                    'Invalid option key(s): [_1]',
                    join( ', ', @invalid_options_keys )
                )
            );
        }
    }

    my $options_validation_handler
        = $type_registry->{options_validation_handler};
    if ($options_validation_handler) {
        unless ( ref $options_validation_handler ) {
            $options_validation_handler
                = $app->handler_to_coderef($options_validation_handler);
        }
        unless ( ref $options_validation_handler ) {
            return $app->error(
                $app->translate(
                    'options_validation_handler of "[_1]" type is invalid',
                    $obj->type
                )
            );
        }
        my $error = $options_validation_handler->(
            $app, $obj->type, $obj->name, $type_registry->{label}, $options
        );
        if ($error) {
            return $app->error(
                $app->translate( 'Invalid option(s): [_1]', $error ) );
        }
    }

    1;
}

1;

