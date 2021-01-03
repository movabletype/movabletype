# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentStatus;
use strict;
use warnings;

use MT::EntryStatus qw(:all);

use Exporter 'import';

our @EXPORT_OK = qw( status_icon );

1;
__END__

=head1 NAME

MT::ContentStatus - Movable Type content data status class

=head1 DESCRIPTION

I<MT::ContentStatus> contains subroutines related to content data status.
Current I<MT::ContentStatus> is almost same as I<MT::EntryStatus>.
Please see documentation of I<MT::EntryStatus>.

=head1 SEE ALSO

L<MT::EntryStatus>

=head1 AUTHOR & COPYRIGHTS

Please see the L<MT> manpage for author, copyright, and license information.

=cut

