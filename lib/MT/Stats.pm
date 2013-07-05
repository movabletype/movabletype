# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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
            return $providers{$k}{provider}->new($k, $blog);
        }
    }

    return undef;
}

1;

