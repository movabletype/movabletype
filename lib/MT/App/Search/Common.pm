# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::App::Search::Common;

use strict;
use warnings;

sub init_core_callbacks {
    my $app = shift;
    my $pkg = ref $app;
    my $pfx = '$Core::MT::App::Search';
    $app->_register_core_callbacks(
        {   "${pkg}::search_post_execute" => "${pfx}::_log_search",
            "${pkg}::search_post_render"  => "${pfx}::_cache_out",
            "${pkg}::prepare_throttle"    => "${pfx}::_default_throttle",
            "${pkg}::take_down"           => "${pfx}::_default_takedown",
        }
    );
}

1;

__END__

=head1 NAME

MT::App::Search::Common

=head1 DESCRIPTION

The I<MT::App::Search::Common> module is the common parts of Search element applications.
This module is used by both Search.pm and DataAPI.pm.

=cut
