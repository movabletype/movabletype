# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Core Summary Object Framework functions for MT::Entry

package MT::Summary::Entry;

use strict;
use warnings;
use MT::Asset;
use MT::Entry;

sub summarize_all_assets {
    my $entry = shift;
    my ($terms) = @_;
    my %args;

    require MT::ObjectAsset;
    my @assets = MT::Asset->load({ class => '*' }, { join => MT::ObjectAsset->join_on(undef, {
        asset_id => \'= asset_id', object_ds => 'entry', object_id => $entry->id })});

    return @assets ? join(',', map {$_->id} @assets) : '';
}

1;
