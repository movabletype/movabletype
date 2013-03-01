# Movable Type (r) Open Source (C) 2005-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::Upgrade;
use strict;
use warnings;

sub move_current_style_to_meta {
    my $blog = shift;

    my $plugin = MT->component('StyleCatcher');
    my $config = $plugin->get_config_hash();

    # Copy to meta
    $blog->current_style( $config->{ "current_theme_" . $blog->id } || '' );
    $blog->save();
}

sub reset_config {
    my $plugin = MT->component('StyleCatcher');
    $plugin->reset_config();
}

1;
