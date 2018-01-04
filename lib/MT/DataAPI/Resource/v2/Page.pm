# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::v2::Page;

use strict;
use warnings;

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Entry;
use MT::DataAPI::Resource::v2::Entry;

sub updatable_fields {
    [   @{ MT::DataAPI::Resource::Entry::updatable_fields() },
        @{ MT::DataAPI::Resource::v2::Entry::updatable_fields() },
    ];
}

sub fields {
    [   @{ MT::DataAPI::Resource::Entry::fields() },
        @{ MT::DataAPI::Resource::v2::Entry::fields() },
        {   name        => 'categories',
            from_object => sub { },        # Do nothing.
        },
        {   name        => 'folder',
            from_object => sub {
                my ($obj) = @_;
                if ( my $folder = $obj->category ) {
                    return MT::DataAPI::Resource->from_object( $folder,
                        [qw( id label parent )] );
                }
                else {
                    return undef;
                }
            },
        },
    ];
}

1;

__END__
            
=head1 NAME 
        
MT::DataAPI::Resource::v2::Page - Movable Type class for resources definitions of the MT::Page.
            
=head1 AUTHOR & COPYRIGHT
            
Please see the I<MT> manpage for author, copyright, and license information.
        
=cut
