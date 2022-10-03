# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v1::Blog;

use strict;
use warnings;

sub updatable_fields {
    [];
}

sub fields {
    [   qw(id class name description archiveUrl),
        {   name  => 'url',
            alias => 'site_url',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v1::Blog - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
