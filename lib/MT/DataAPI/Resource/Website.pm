# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Website;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::Blog);

sub fields {
    $_[0]->SUPER::fields();
}

sub updatable_fields {
    $_[0]->SUPER::updatable_fields();
}

1;
