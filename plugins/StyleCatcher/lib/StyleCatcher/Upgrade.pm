# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::Upgrade;
use strict;
use warnings;

sub move_current_style_to_meta {
    my $blog = shift;

    my $plugin = MT->component('StyleCatcher');
    my $config = $plugin->get_config_hash();

    ## Copy to meta ##
    my $current_theme = $config->{ "current_theme_" . $blog->id };

    # for bug of built-in StyleCatcher repo by MT4.x
    $current_theme =~ s/^repo-\w+:/local:/;

    # for external style by MT3.x
    $current_theme = 'default:' . $current_theme
        if $current_theme && $current_theme !~ /:/;

    $blog->current_style( $current_theme || '' );
    $blog->save();
}

sub reset_config {
    my $plugin = MT->component('StyleCatcher');
    $plugin->reset_config();
}

1;
