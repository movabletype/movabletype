# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::v5::Page;

use strict;
use warnings;

use MT::DataAPI::Resource::v5::Entry;

sub fields {
    [
        @{ MT::DataAPI::Resource::v5::Entry::fields() },
    ];
}

1;

__END__
            
=head1 NAME 
        
MT::DataAPI::Resource::v5::Page - Movable Type class for resources definitions of the MT::Page.
            
=head1 AUTHOR & COPYRIGHT
            
Please see the I<MT> manpage for author, copyright, and license information.
        
=cut
