# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

=head2 SitesLocalSite

This container tag let you refer to the local blog, inside mt:Sites block.
example:

    <mt:Sites blog_ids="1" mode="context">
        <mt:SitesLocalSite>
            <mt:BlogName />
        </mt:SitesLocalSite>
    </mt:Sites>

=cut

=head2 MultiBlogLocalBlog

This tag is an alias for the SitesLocalSite tag

=cut

sub _hdlr_sites_local_site {
    my ( $ctx, $args, $cond ) = @_;

    my $blog_id       = $ctx->stash('blog_id');
    my $local_blog_id = $ctx->stash('local_blog_id');

    if ($local_blog_id) {
        $ctx->stash( 'blog_id', $local_blog_id );
        $ctx->stash( 'blog',    MT->model('blog')->load($local_blog_id) );
    }

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    my $out = $builder->build( $ctx, $tokens )
        or return $ctx->error( $builder->errstr );

    if ($local_blog_id) {
        $ctx->stash( 'blog_id', $blog_id );
        $ctx->stash( 'blog',    MT->model('blog')->load($blog_id) );
    }

    $out;
}

=head2 SitesIfLocalSite

A conditional tag that is true when the mt:Sites is presenting the current 
local blog

=cut

=head2 MultiBlogIfLocalBlog

This tag is an alias for the SitesIfLocalSite tag

=cut

sub _hdlr_sites_if_local_site {
    my $ctx     = shift;
    my $local   = $ctx->stash('local_blog_id');
    my $blog_id = $ctx->stash('blog_id');
    defined($local)
        and defined($blog_id)
        and $blog_id == $local;
}

1;

