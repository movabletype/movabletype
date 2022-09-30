# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Website;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::Blog);

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    $_[0]->SUPER::fields();
}

sub updatable_fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    $_[0]->SUPER::updatable_fields();
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Website - Movable Type class for resources definitions of the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
