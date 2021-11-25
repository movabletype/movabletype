# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Theme;

use strict;
use warnings;

sub fields {
    return [
        'authorLink', 'authorName', 'description', 'id', 'label', 'version',
        {
            name => 'inUse',
            type => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {
            name => 'uninstallable',
            type => 'MT::DataAPI::Resource::DataType::Boolean',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Theme - Movable Type class for resources definitions of the MT::Theme.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

