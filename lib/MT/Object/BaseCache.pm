# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Object::BaseCache;

use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::BaseCache );

sub is_cacheable {
    my ( $driver, $obj ) = @_;
    return if !defined $obj;

    # default is cacheable
    defined $obj->properties->{cacheable} ? $obj->properties->{cacheable} : 1;
}

1;
