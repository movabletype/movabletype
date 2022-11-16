# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Category;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   qw(
            label
            description
            basename
            )
    ];
}

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   $MT::DataAPI::Resource::Common::fields{blog},
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class', 'label',
        'description',
        'parent',
        'basename',
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Category - Movable Type class for resources definitions of the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
