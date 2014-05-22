# Movable Type (r) (C) 2006-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::Tags;

use strict;
use warnings;

=head2 MultiBlog

This container tag shows aggregated blogs, where the 'include_blog' attribute
specify the blogs that you want to aggregate, or 'all'. the following
example will loop over this block three times, once for every blog.

    <mt:MultiBlog include_blogs="1,5,8">
       <mt:Entries lastn="10">
          <p><mt:EntryTitle></p>
       </mt:Entries>
       <mt:Comments lastn="10">
          <p><mt:CommentBody></p>
       </mt:Entries>
    </mt:MultiBlog>

if no include_blogs param is included, it will try to get the blogs to 
be included from the blog's plugin configuration. if nothing is configured,
the tag is ignored.

alternative for include_blogs: exclude_blogs (meaning all but these blogs)

=cut

=head2 OtherBlog

This tag is an alias for the MultiBlog tag

=cut

sub MultiBlog {
    my $plugin = MT::Plugin::MultiBlog->instance;
    my ( $ctx, $args, $cond ) = @_;

    return $ctx->error(
        $plugin->translate('MTMultiBlog tags cannot be nested.') )
        if $ctx->stash('multiblog_context');

    # Set default mode for backwards compatibility
    $args->{mode} ||= 'loop';

    if ( $args->{blog_id} ) {
        $args->{blog_ids} = $args->{blog_id};
        delete $args->{blog_id};
    }

    # If MTMultiBlog was called with no arguments, we check the
    # blog-level settings for the default includes/excludes.
    unless ( $args->{blog_ids}
        || $args->{include_blogs}
        || $args->{exclude_blogs}
        || $args->{include_websites}
        || $args->{exclude_websites}
        || $args->{site_ids} )
    {
        my $id = $ctx->stash('blog_id');
        my $is_include
            = $plugin->get_config_value( 'default_mtmultiblog_action',
            "blog:$id" );
        my $blogs = $plugin->get_config_value( 'default_mtmulitblog_blogs',
            "blog:$id" );

        if ( $blogs && defined($is_include) ) {
            $args->{ $is_include ? 'include_blogs' : 'exclude_blogs' }
                = $blogs;
        }

        # No blog-level config set
        # Set mode to context as this will mimic no MTMultiBlog tag
        else {
            $args->{'mode'} = 'context';    # Override 'loop' mode
        }
    }

    # Filter MultiBlog args through access controls
    require MultiBlog;

    # Load multiblog access control list
    my %acl = MultiBlog::load_multiblog_acl( $plugin, $ctx );
    $args->{ $acl{mode} } = $acl{acl};

    # Run MultiBlog in specified mode
    my $res;
    if ( $args->{mode} eq 'loop' ) {
        $res = loop( $plugin, @_ );
    }
    elsif ( $args->{mode} eq 'context' ) {
        $res = context( $plugin, @_ );
    }
    else {

        # Throw error if mode is unknown
        $res = $ctx->error(
            $plugin->translate(
                'Unknown "mode" attribute value: [_1]. '
                    . 'Valid values are "loop" and "context".',
                $args->{mode}
            )
        );
    }

    # Remove multiblog_context and blog_ids
    $ctx->stash( 'multiblog_context',          '' );
    $ctx->stash( 'multiblog_include_blog_ids', '' );
    $ctx->stash( 'multiblog_exclude_blog_ids', '' );
    return defined($res) ? $res : $ctx->error( $ctx->errstr );
}

=head2 MultiBlogLocalBlog

This container tag let you refer to the local blog, inside MultiBlog block.
example:

    <mt:MultiBlog blog_ids="1" mode="context">
        <mt:MultiBlogLocalBlog>
            <mt:BlogName />
        </mt:MultiBlogLocalBlog>
    </mt:MultiBlog>

=cut

sub MultiBlogLocalBlog {
    my $plugin = MT::Plugin::MultiBlog->instance;
    my ( $ctx, $args, $cond ) = @_;

    require MT::Blog;
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

=head2 MultiBlogIfLocalBlog

A conditional tag that is true when the MultiBlog is presenting the current 
local blog

=cut

sub MultiBlogIfLocalBlog {
    my $plugin  = MT::Plugin::MultiBlog->instance;
    my $ctx     = shift;
    my $local   = $ctx->stash('local_blog_id');
    my $blog_id = $ctx->stash('blog_id');
    defined($local)
        and defined($blog_id)
        and $blog_id == $local;
}

## Supporting functions for 'MultiBlog' tag:

# Multiblog's "context" mode:
# The container's contents are evaluated once with a multi-blog context
sub context {
    my $plugin = shift;
    my ( $ctx, $args, $cond ) = @_;

    my $include_blogs = $args->{include_blogs} || $args->{blog_ids};

    # Assuming multiblog context, set it.
    if ( $include_blogs || $args->{exclude_blogs} ) {
        $ctx->stash( 'multiblog_context', 1 );
        $ctx->stash( 'multiblog_include_blog_ids',
            join( ',', $include_blogs ) )
            if $include_blogs;
        $ctx->stash(
            'multiblog_exclude_blog_ids',
            join( ',', $args->{exclude_blogs} )
        ) if $args->{exclude_blogs};
    }

    # Evaluate container contents and return output
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $out     = $builder->build( $ctx, $tokens, $cond );
    return
        defined($out) ? $out : $ctx->error( $ctx->stash('builder')->errstr );

}

# Multiblog's "loop" mode:
# The container's contents are evaluated once per specified blog
sub loop {
    my $plugin = shift;
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );

    # Set the context for blog loading
    $ctx->set_blog_load_context( $args, \%terms, \%args, 'id' )
        or return $ctx->error( $ctx->errstr );
    $args{'no_class'} = 1
        if ( $args->{include_blogs} && lc $args->{include_blogs} eq 'all' )
        || ( $args->{include_website}
        && lc $args->{include_website} eq 'all' )
        || ( $args->{blog_ids} && lc $args->{blog_ids} eq 'all' )
        || ( $args->{site_ids} && lc $args->{site_ids} eq 'all' );

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};

    require MT::Blog;
    $args{'sort'} = 'name';
    $args{direction} = 'ascend';

    my $iter = MT::Blog->load_iter( \%terms, \%args );
    my $res = '';
    while ( my $blog = $iter->() ) {
        local $ctx->{__stash}{blog}    = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        $ctx->stash( 'multiblog_context',  'include_blogs' );
        $ctx->stash( 'multiblog_blog_ids', $blog->id );
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

1;
