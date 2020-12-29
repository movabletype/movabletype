# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Trackback;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];
}

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Trackback - Movable Type class for resources definitions of the MT::TBPing.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
