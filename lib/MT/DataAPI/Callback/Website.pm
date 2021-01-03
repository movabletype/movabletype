# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Website;

use strict;
use warnings;

use MT::DataAPI::Callback::Blog;

sub save_filter {
    MT::DataAPI::Callback::Blog::save_filter(@_);
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Website - Movable Type class for Data API's callbacks about the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
