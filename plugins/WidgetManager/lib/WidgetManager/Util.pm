# Widget Manager Movable Type Plugin Utility Package
# Copyright (C) 2005-2006 Six Apart, Ltd.
#
# $Id$

package WidgetManager::Util;

use strict;

sub debug {
    my $err = shift;
    my $mark = shift || '>';
    print STDERR "$mark $err\n" if $MT::Plugin::WidgetManager::DEBUG;
}

1;
