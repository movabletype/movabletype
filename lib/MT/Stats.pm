# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
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
        my $all_providers = $app->registry('stats_providers');
        return undef unless $all_providers;
        for my $k ( keys %$all_providers ) {
            $providers{$k} = $app->registry( 'stats_providers', $k );
            eval "require $providers{$k}{provider};";
        }
    }

    for my $k ( keys %providers ) {
        if ( $providers{$k}{provider}->is_ready( $app, $blog ) ) {
            return $providers{$k}{provider}->new( $k, $blog );
        }
    }

    return undef;
}

1;

__END__

=head1 NAME

MT::Stats - Movable Type class for managing access stats provider.

=head1 SYNOPSIS

    use MT::Stats;

    my $app  = MT->instance;
    my $blog = $app->model('blog')->load(1);
    if (my $provider = MT::Stats->readied_provider($app, $blog)) {
        $provider->isa('MT::Stats::Provider'); # true
    }

=head1 METHODS

=head2 MT::Stats->readied_provider($app, $blog)

If C<$blog> is associated to a some provider, returns an instance of an implementation class, that is a subclass of L<MT::Stats::Provider>.
If C<$blog> is not associated to any provider, returns undef.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
