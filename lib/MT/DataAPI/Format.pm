# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Format;

use strict;
use warnings;

our %formats = ();
our $default_format;

sub core_formats {
    my $app = shift;
    my $pkg = '$Core::MT::DataAPI::Format::';
    return {
        'js'   => 'json',
        'json' => {
            mime_type   => 'application/json',
            serialize   => "${pkg}JSON::serialize",
            unserialize => "${pkg}JSON::unserialize",
        },
    };
}

sub find_format {
    my $class = shift;
    my ($key) = @_;
    my $app   = MT->instance;

    if ( !%formats ) {
        my $reg = $app->registry( 'applications', 'data_api', 'formats' );
        %formats = map { $_ => 1 } keys %$reg;
    }

    $default_format = do {
        my $r
            = $app->registry( 'applications', 'data_api', 'default_format' );
        ref $r ? $r->[$#$r] : $r;
    };
    my $format_key
        = $key
        || ( $app->current_endpoint || {} )->{format}
        || $app->param('format')
        || $default_format;

    my $format = $formats{$format_key};
    if ( !defined $format ) {
        $format_key = ( keys %formats )[0];
        $format     = $formats{$format_key};
    }

    if ( !ref $format ) {
        $format = $formats{$format_key}
            = $app->registry( 'applications', 'data_api', 'formats',
            $format_key );

        if ( ref $format ne 'HASH' ) {
            $format = $formats{$format_key}
                = $class->find_format( $format->[0] );
        }
        else {
            for my $k ( keys %$format ) {
                if ( ref $format->{$k} eq 'ARRAY' ) {
                    $format->{$k} = $format->{$k}[-1];
                }
            }
            for my $k (qw(serialize unserialize)) {
                $format->{$k} = $app->handler_to_coderef( $format->{$k} );
            }
        }
    }

    $format;
}

1;

__END__

=head1 NAME

MT::DataAPI::Format - Movable Type class for managing Data API's formats to serialize.

=head1 SYNOPSIS

    use MT::DataAPI::Format;

    if ($my $format = MT::DataAPI::Format->find_format($key)) {
        $format->{serialize}->($data);
    }

=head1 METHODS

=head2 MT::DataAPI::Format->find_format([$key])

Returns a format data if found.
This method looks for a format for a key in following order.

=over 4

=item C<$key>

Given C<$key>.

=item $app->current_endpoint->{format}

The format key of current endpoint.

=item $app->param('format')

The format parameter of this request.

=item $app->registry( 'applications', 'data_api' )->{default_format}

The default format of the system.

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
