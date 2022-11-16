# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Asset;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   qw(
            label
            description
            tags
            )
    ];
}

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   qw(
            id
            label
            url
            description
            mimeType
            ),
        {   name  => 'filename',
            alias => 'file_name',
        },
        $MT::DataAPI::Resource::Common::fields{tags},
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Asset - Movable Type class for resources definitions of the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
