# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package GoogleAnalytics;

use strict;
use warnings;

our @EXPORT = qw( plugin translate );
use base qw(Exporter);

sub translate {
    MT->component('GoogleAnalytics')->translate(@_);
}

sub plugin {
    MT->component('GoogleAnalytics');
}

sub _find_current_config_hash {
    my ( $app, $blog ) = @_;

    my @keys = ( 'configuration:blog:' . $blog->id );
    if ( $blog->parent_id ) {
        push @keys, 'configuration:blog:' . $blog->parent_id;
    }
    my @objs = $app->model('plugindata')->load(
        {   plugin => plugin()->key,
            key    => \@keys,
        }
    ) or return 0;

    # Blog's config has a priority higher than website's config.
    @objs = reverse @objs
        if ( scalar(@objs) == 2 && $objs[0]->key ne $keys[0] );

    for my $o (@objs) {
        my $data = $o->data();
        if ( $data && $data->{profile_id} ) {
            return $data;
        }
    }

    return 0;
}

sub current_config_hash {
    my ( $app, $blog ) = @_;

    my $hash = $app->request('ga_current_config_hash');
    defined($hash)
        ? $hash
        : $app->request( 'ga_current_config_hash',
        _find_current_config_hash(@_) );
}

sub ready_to_provide {
    my ( $app, $blog ) = @_;

    current_config_hash(@_) ? 1 : 0;
}

1;
