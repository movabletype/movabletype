# Movable Type (r) (C) 2006-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::DataAPI::Resource::FormattedText::v2;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            label
            text
            description
            ),
    ];
}

sub fields {
    [   qw(
            id
            label
            text
            description
            ),
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdUser},
        $MT::DataAPI::Resource::Common::fields{modifiedUser},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

1;

__END__

=head1 NAME

FormattedText::DataAPI::Resource::FormattedText::v2 - Movable Type class for resources definitions
of the FormattedText::FormattedText.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
