<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

if (MULTIBLOG_ENABLED) {
function smarty_block_mtmultiblog($args, $content, &$ctx, &$repeat) {

    # Set default mode for backwards compatibility
    $mode = $args['mode'];
    $mode or $mode = 'loop';

    if (!isset($content)) {

        # Check for nested MTMultiBlog tags
        if ($ctx->stash('multiblog_context')) {
            $repeat = false;
            return '';
        }

        # If MTMultiBlog was called with no arguments, we check the 
        # blog-level settings for the default includes/excludes.
        if ( !( $args['blog_ids']
                or $args['include_blogs'] 
                or $args['exclude_blogs'] )) {
            $id = $ctx->stash('blog_id');
            global $multiblog_blog_config;
            if (!$multiblog_blog_config)
                $multiblog_blog_config = array();
            if (!isset($multiblog_blog_config[$id]))
                $multiblog_blog_config[$id] = $ctx->mt->db->fetch_plugin_data("MultiBlog", "configuration:blog:$id");
            if (!isset($multiblog_blog_config[$id]))
                $multiblog_blog_config[$id] = array();
            $is_include = $multiblog_blog_config[$id]['default_mtmultiblog_action'];
            if ($multiblog_blog_config[$id]['default_mtmulitblog_blogs'])
                $blogs = $multiblog_blog_config[$id]['default_mtmulitblog_blogs'];

            if ($blogs && isset($is_include)) {
                $args[$is_include ? 'include_blogs' : 'exclude_blogs'] = $blogs;
            } 
            # No blog-level config set
            # Set mode to context as this will mimic no MTMultiBlog tag
            else {
                $mode = 'context';  # Override 'loop' mode
            }
        }

        # Filter MultiBlog args through access controls
        if ( ! multiblog_filter_blogs_from_args($ctx, $args) ) {
            if ($mode == 'loop') {
                $repeat = false;
                return '';
            }            
        } else {
            if (($mode != 'loop') && ($mode != 'context')) {
                # Throw error if mode is unknown
                $repeat = false;
                return '';
            }
        }
    }

    # Run MultiBlog in specified mode
    if ($mode == 'loop') {
        $content = multiblog_loop($args, $content, $ctx, $repeat);
    } elseif ($mode == 'context') {
        $content = multiblog_context($args, $content, $ctx, $repeat);
    }

    return $content;
}

# Multiblog's "context" mode:
# The container's contents are evaluated once with a multi-blog context
function multiblog_context($args, $content, &$ctx, &$repeat) {
    $localvars = array('multiblog_context', 'multiblog_blog_ids');

    if (!isset($content)) {
        $ctx->localize($localvars);
        # Assuming multiblog context, set it.
        if ($args['include_blogs'] or $args['exclude_blogs']) {
            $mode = $args['include_blogs'] ? 'include_blogs' 
                                           : 'exclude_blogs';
            $ctx->stash('multiblog_context', $mode);
            $ctx->stash('multiblog_blog_ids', $args[$mode]);
        } 
        $ctx->stash('local_blog_id', $ctx->stash('blog_id'));
    } else {
        # Restore localized variables once we have content
        # since we only go through this loop twice
        $ctx->restore($localvars);
    }
    return $content;
}

# Multiblog's "loop" mode:
# The container's contents are evaluated once per specified blog
function multiblog_loop($args, $content, &$ctx, &$repeat) {
    $localvars = array('entries', 'current_timestamp', 'current_timestamp_end', 'category', 'archive_category', '_blogs', '_blogs_counter', 'blog', 'blog_id', 'multiblog_context', 'multiblog_blog_ids');
    if (!isset($content)) {
        $ctx->localize($localvars);
        if ($args['ignore_archive_context']) {
            $ctx->stash('entries', null);
            $ctx->stash('current_timestamp', null);
            $ctx->stash('current_timestamp_end', null);
            $ctx->stash('category', null);
            $ctx->stash('archive_category', null);
        }
        $blogs = $ctx->mt->db->fetch_blogs($args);
        $ctx->stash('_blogs', $blogs);
        $counter = 0;
    } else {
        $blogs = $ctx->stash('_blogs');
        $counter = $ctx->stash('_blogs_counter');
    }
    if ($counter < count($blogs)) {
        $blog = $blogs[$counter];
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog['blog_id']);
        $ctx->stash('_blogs_counter', $counter + 1);
        $ctx->stash('multiblog_context', 'include_blogs');
        $ctx->stash('multiblog_blog_ids', $blog['blog_id']);
        $repeat = true;
    } else {
        # Restore localized variables once we're 
        # finished with all blogs in scope
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
}
?>
