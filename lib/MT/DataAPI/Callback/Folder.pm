# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Folder;

use strict;
use warnings;

use MT::DataAPI::Callback::Category;

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    return !$obj->is_category;
}

sub save_filter {
    return MT::DataAPI::Callback::Category::save_filter(@_);
}

1;

__END__
    
=head1 NAME
        
MT::DataAPI::Callback::Folder - Movable Type class for Data API's callbacks about the MT::Folder.

=head1 AUTHOR & COPYRIGHT
    
Please see the I<MT> manpage for author, copyright, and license information.
            
=cut
