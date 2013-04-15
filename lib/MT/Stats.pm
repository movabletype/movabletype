package MT::Stats;

use strict;
use warnings;

our @EXPORT = qw(readied_provider);
use base qw(Exporter);

our %providers;

sub readied_provider {
    my ( $app, $blog ) = @_;

    if ( !%providers ) {
        for my $k ( keys %{ $app->registry('stats_providers') } ) {
            $providers{$k} = $app->registry( 'stats_providers', $k );
            eval "require $providers{$k}{provider};";
        }
    }

    for my $k ( keys %providers ) {
        if ( $providers{$k}{provider}->is_ready( $app, $blog ) ) {
            return $providers{$k}{provider}->new($blog);
        }
    }

    return undef;
}

1;

