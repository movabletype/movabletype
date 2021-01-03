# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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

    require MT::ObjectAsset;
    my @assets = MT::Asset->load(
        { class => '*' },
        {   join => MT::ObjectAsset->join_on(
                undef,
                {   asset_id  => \'= asset_id',
                    object_ds => 'entry',
                    object_id => $entry->id
                }
            )
        }
    );

    return @assets ? join( ',', map { $_->id } @assets ) : '';
}

1;
