package MultiBlog::Tags;
# $Id$
use strict;
use warnings;

use base qw( MultiBlog );

sub MultiBlog {
    my $plugin = shift;
    require MultiBlog::Tags::MultiBlog;
    &MultiBlog::Tags::MultiBlog::multiblog($plugin, @_);    
}
sub OtherBlog { MultiBlog(@_); }

sub MultiBlogLocalBlog {
    my $plugin = shift;
    require MultiBlog::Tags::LocalBlog;
    &MultiBlog::Tags::LocalBlog::local_blog($plugin, @_);
}

sub MultiBlogIfLocalBlog {
    my $plugin = shift;
    my $ctx = shift;
    my $local = $ctx->stash('local_blog_id');
    my $blog_id = $ctx->stash('blog_id');
    return (    defined( $local ) 
            and defined( $blog_id ) 
            and $blog_id == $local) 
        ? $ctx->slurp : $ctx->else;
}

1;
