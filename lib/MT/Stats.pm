# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Stats;

use strict;
use warnings;

our @EXPORT_OK = qw(readied_provider default_provider_has);
use base qw(Exporter);

my %loaded;

sub readied_provider {
    my ($app, $blog, $provider_arg) = @_;

    my $all_providers = $app->registry('stats_providers');
    return undef unless $all_providers;

    my %seen;
    my @provider_keys = grep { $_ && !$seen{$_}++ } ($provider_arg || MT->config('DefaultStatsProvider'), keys %$all_providers);
    for my $k (@provider_keys) {
        # Ignore if the key is not registered
        my $reg = $all_providers->{$k} or next;

        # Ignore if the registry does not have a provider (probably because of autovivification)
        my $provider = $reg->{provider} or next;

        if (!exists $loaded{$k}) {
            $loaded{$k} = eval "require $provider; 1" ? 1 : 0;
        }
        # Ignore if the provider is not loaded for some reasons
        next unless $loaded{$k};

        if ($provider->is_ready($app, $blog)) {
            return $provider->new($k, $blog);
        }
    }

    return undef;
}

sub default_provider_has {
    my $method   = shift;
    my $name     = MT->config->DefaultStatsProvider                 or return;
    my $reg      = MT->instance->registry('stats_providers', $name) or return;
    my $provider = $reg->{provider}                                 or return;
    if (!exists $loaded{$name}) {
        $loaded{$name} = eval "require $provider; 1" ? 1 : 0;
    }
    return unless $loaded{$name};
    if ($provider->can($method)) {
        return $provider->$method;
    }
    return;
}

1;

__END__

=head1 NAME

MT::Stats - Movable Type class for managing access stats provider.

=head1 SYNOPSIS

    use MT::Stats qw(readied_provider);

    my $app  = MT->instance;
    my $blog = $app->model('blog')->load(1);
    if (my $provider = readied_provider($app, $blog)) {
        $provider->isa('MT::Stats::Provider'); # true
    }

=head1 FUNCTIONS

=head2 readied_provider($app, $blog)

If C<$blog> is associated to a some provider, returns an instance of an implementation class, that is a subclass of L<MT::Stats::Provider>.
If C<$blog> is not associated to any provider, returns undef.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
