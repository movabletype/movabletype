# Movable Type (r) Open Source (C) 2006-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package FormattedText;

use strict;
use warnings;

our @EXPORT = qw( plugin translate );
use base qw(Exporter);

sub translate {
    MT->component('FormattedText')->translate(@_);
}

sub plugin {
    MT->component('FormattedText');
}

1;
