# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Site;
use strict;
use warnings;

###########################################################################

=head2 SiteHasChildSite

A conditional tag that returns True when the current site
in the context has one or more child sites.

=for tags sites,

=cut

sub _hdlr_site_has_child_site {
    my $ctx  = shift;
    my $blog = $ctx->stash('blog');
    return 0 if !$blog || $blog->is_blog;
    $ctx->invoke_handler( 'websitehasblog', @_ );
}

1;

