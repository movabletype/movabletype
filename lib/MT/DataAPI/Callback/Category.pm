# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Category;

use strict;
use warnings;

use utf8;

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;
    return $app->error( $app->translate('A parameter "label" is required.') )
        if !defined( $obj->label ) || $obj->label eq '';
    return $app->error(
        $app->translate( "The label '[_1]' is too long.", $obj->label ) )
        if length( $obj->label ) > 100;
    return 1;
}

1;

__END__
    
=head1 NAME
        
MT::DataAPI::Callback::Category - Movable Type class for Data API's callbacks about the MT::Category.

=head1 AUTHOR & COPYRIGHT
    
Please see the I<MT> manpage for author, copyright, and license information.
            
=cut   
