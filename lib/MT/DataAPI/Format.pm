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
            content_type => 'application/json',
            serialize    => "${pkg}JSON::serialize",
            unserialize  => "${pkg}JSON::unserialize",
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

    $default_format ||= $app->registry( 'applications', 'data_api' )->{default_format};
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
            for my $k (qw(serialize unserialize)) {
                $format->{$k} = $app->handler_to_coderef( $format->{$k} );
            }
        }
    }

    $format;
}

1;
