package MultiBlog::Tags::LocalBlog;
# $Id$
use strict;
use warnings;

use MT::Blog;

sub local_blog {
    my $plugin = shift;
    my ( $ctx, $args, $cond ) = @_;

    my $blog_id       = $ctx->stash('blog_id');
    my $local_blog_id = $ctx->stash('local_blog_id');

    if ($local_blog_id) {
        $ctx->stash( 'blog_id', $local_blog_id );
        $ctx->stash( 'blog',    MT::Blog->load($local_blog_id) );
    }

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    my $out = $builder->build( $ctx, $tokens )
      or return $ctx->error( $builder->errstr );

    if ($local_blog_id) {
        $ctx->stash( 'blog_id', $blog_id );
        $ctx->stash( 'blog',    MT::Blog->load($blog_id) );
    }

    $out;
}

1;
