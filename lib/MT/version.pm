# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::version;

use strict;
use warnings;

use version;

sub parse {
    my $class = shift;
    my ($version_string) = @_;
    $version_string .= '.0' if $version_string =~ /^[0-9]+\.[0-9]+$/;
    version->parse($version_string);
}

1;

