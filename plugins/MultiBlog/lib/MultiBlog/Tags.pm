# Movable Type (r) Open Source (C) 2006-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog::Tags;

use strict;
use warnings;

sub MultiBlog {
    my $plugin = MT::Plugin::MultiBlog->instance;
    my ( $ctx, $args, $cond ) = @_;

    return $ctx->error($plugin->translate('MTMultiBlog tags cannot be nested.'))
        if $ctx->stash('multiblog_context');

    # Set default mode for backwards compatibility
    $args->{mode} ||= 'loop';

    # If MTMultiBlog was called with no arguments, we check the 
    # blog-level settings for the default includes/excludes.
    unless (   $args->{blog_ids} 
            || $args->{include_blogs} 
            || $args->{exclude_blogs} ) {
        my $id = $ctx->stash('blog_id');
        my $is_include = $plugin->get_config_value( 
                'default_mtmultiblog_action', "blog:$id" );
        my $blogs = $plugin->get_config_value( 
                'default_mtmulitblog_blogs', "blog:$id" );

        if ($blogs && defined($is_include)) {
            $args->{$is_include ? 'include_blogs' : 'exclude_blogs'} = $blogs;
        } 
        # No blog-level config set
        # Set mode to context as this will mimic no MTMultiBlog tag
        else {
            $args->{'mode'} = 'context';  # Override 'loop' mode
        }
    }

    # Filter MultiBlog args through access controls
    if ( ! MultiBlog::filter_blogs_from_args($plugin, $ctx, $args) ) {
        return $ctx->errstr ? $ctx->error($ctx->errstr) : '';
    }

    # Save current blog ID
    local $ctx->{__stash}{local_blog_id} = $ctx->stash('blog_id');
    
    # Run MultiBlog in specified mode
    my $res;
    if ( $args->{mode} eq 'loop') {
        $res = loop($plugin, @_);
    } elsif ( $args->{mode} eq 'context') {
        $res = context($plugin, @_);
    } else {
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
    $ctx->stash('multiblog_context', '');
    $ctx->stash('multiblog_blog_ids', '');
    return defined($res) ? $res : $ctx->error($ctx->errstr);
}

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

sub MultiBlogIfLocalBlog {
    my $plugin = MT::Plugin::MultiBlog->instance;
    my $ctx = shift;
    my $local = $ctx->stash('local_blog_id');
    my $blog_id = $ctx->stash('blog_id');
    defined( $local ) 
        and defined( $blog_id ) 
        and $blog_id == $local;
}

## Supporting functions for 'MultiBlog' tag:

# Multiblog's "context" mode:
# The container's contents are evaluated once with a multi-blog context
sub context {
    my $plugin = shift;
    my ( $ctx, $args, $cond ) = @_;

    # Assuming multiblog context, set it.
    if ($args->{include_blogs} || $args->{exclude_blogs}) {
        my $mode = $args->{include_blogs} ? 'include_blogs' 
                                          : 'exclude_blogs';
        $ctx->stash('multiblog_context', $mode);
        $ctx->stash('multiblog_blog_ids', join ( ',', $args->{$mode} ));
    } 

    # Evaluate container contents and return output
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $out = $builder->build( $ctx, $tokens, $cond);
    return defined($out) ? $out : $ctx->error($ctx->stash('builder')->errstr);

}

# Multiblog's "loop" mode:
# The container's contents are evaluated once per specified blog
sub loop {
    my $plugin = shift;
    my ( $ctx, $args, $cond ) = @_;
    my (%terms, %args);

    # Set the context for blog loading
    $ctx->set_blog_load_context($args, \%terms, \%args, 'id')
        or return $ctx->error($ctx->errstr);

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
    my $iter    = MT::Blog->load_iter(\%terms, \%args);
    my $res     = '';
    while (my $blog = $iter->()) {
        local $ctx->{__stash}{blog} = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        $ctx->stash('multiblog_context', 'include_blogs');
        $ctx->stash('multiblog_blog_ids', $blog->id);
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    $res;
}

1;
