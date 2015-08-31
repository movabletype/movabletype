# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleOpenIDConnect;

use strict;
use warnings;

our @EXPORT = qw( plugin translate get_plugindata );
use base qw(Exporter);

sub translate {
    MT->component('GoogleOpenIDConnect')->translate(@_);
}

sub plugin {
    MT->component('GoogleOpenIDConnect');
}

sub get_plugindata {
    my $scope  = shift;
    my $plugin = plugin();
    my ( $scope_plugindata, $system_plugindata );
    if ( $scope ne 'system' ) {
        $scope_plugindata = $plugin->get_config_hash($scope);
    }
    $system_plugindata = $plugin->get_config_hash('system');

    if (   $scope_plugindata->{client_id}
        && $scope_plugindata->{client_secret} )
    {
        return $scope_plugindata;
    }
    elsif ($system_plugindata->{client_id}
        && $system_plugindata->{client_secret} )
    {
        return $system_plugindata;
    }
    else {
        return {};
    }
}
1;
