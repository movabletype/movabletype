# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::Entry::v2;

use strict;
use warnings;

use MT::Category;
use MT::DataAPI::Resource;

sub fields {
    [   {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );

                MT::DataAPI::Resource->from_object(
                    [   sort {
                                  $a->id == $primary ? -1
                                : $b->id == $primary ? 1
                                : $a->label cmp $b->label
                        } @$cats
                    ]
                );
            },
        }
    ];
}

1;

__END__
            
=head1 NAME 
        
MT::DataAPI::Resource::Entry::v2 - Movable Type class for resources definitions of the MT::Entry.
            
=head1 AUTHOR & COPYRIGHT
            
Please see the I<MT> manpage for author, copyright, and license information.
        
=cut  
