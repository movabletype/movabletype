# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package NotifyList::Tags;
use strict;

sub hdlr_notify_script {
    my ($ctx) = @_;
    return $ctx->{config}->NotifyScript;
}

1;
