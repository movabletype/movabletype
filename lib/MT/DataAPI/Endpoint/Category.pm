# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Category;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res
        = filtered_list( $app, $endpoint, 'category',
        { category_set_id => 0 } )
        or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Category - Movable Type class for endpoint definitions about the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
