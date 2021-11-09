<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtblogs($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_blogs', '_blogs_counter', 'blog', 'blog_id'), common_loop_vars());

    if (!isset($content)) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $tag = $ctx->this_tag();

        # If MTMultiBlog was called with no arguments, we check the 
        # blog-level settings for the default includes/excludes.
        if ( !( !empty($args['blog_ids'])
                or !empty($args['include_sites'])
                or !empty($args['exclude_sites'])
                or !empty($args['include_blogs'])
                or !empty($args['exclude_blogs'])
                or !empty($args['include_websites'])
                or !empty($args['exclude_websites'])
                or !empty($args['site_ids'])  )) {
            $blog = $ctx->stash('blog');
            $is_include = isset( $blog->default_mt_sites_action )
                ? $blog->default_mt_sites_actio : 1;
            $blogs = $blog->default_mtsites_blogs || '';

            if ($blogs && isset($is_include)) {
                $args[$is_include ? 'include_blogs' : 'exclude_blogs'] = $blogs;
            } 
            # No blog-level config set
            # Set mode to context as this will mimic no MTMultiBlog tag
            else {
                if ($tag === 'mtmultiblog') {
                    $args['mode'] = 'context';  # Override 'loop' mode
                }
            }
        }
    }

    # Set default mode for backwards compatibility
    $mode = !empty($args['mode']) ? $args['mode'] : 'loop';

    # Run MultiBlog in specified mode
    if ($mode == 'loop') {
        $content = multiblog_loop($args, $content, $ctx, $repeat);
    } elseif ($mode == 'context') {
        $content = multiblog_context($args, $content, $ctx, $repeat);
    }

    return $content;
    return '0';
}

# Multiblog's "context" mode:
# The container's contents are evaluated once with a multi-blog context
function multiblog_context($args, $content, &$ctx, &$repeat) {
    $prefix = _context_prefix($ctx->this_tag());
    $localvars = array($prefix . 'context', $prefix . 'blog_ids', 'local_blog_id');

    if (!isset($content)) {
        $ctx->localize($localvars);
        # Assuming multiblog context, set it.
        $stash_to_args = array(
            $prefix . 'include_blog_ids' => array(
                'include_sites', 'include_blogs', 'blog_ids', 'include_websites',
            ),
            $prefix . 'exclude_blog_ids' => array(
                'exclude_sites', 'exclude_blogs',
            ),
        );
        foreach ($stash_to_args as $stash_key => $args_keys) {
            foreach ($args_keys as $k) {
                if (isset($args[$k])) {
                    $ctx->stash($prefix . 'context', true);
                    $ctx->stash($stash_key, $args[$k]);
                }
            }
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
    $prefix = _context_prefix($ctx->this_tag());
    $localvars = array('entries', 'current_timestamp', 'current_timestamp_end', 'category', 'archive_category', '_blogs', '_blogs_counter', 'blog', 'blog_id', $prefix . 'context', $prefix . 'blog_ids', 'local_blog_id');
    if (!isset($content)) {
        $ctx->localize($localvars);

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $content, $ctx, $repeat);

        if ( (  isset($args['include_sites'])   && $args['include_sites'] === 'all' )
            || (isset($args['include_blogs'])   && $args['include_blogs'] === 'all' )
            || (isset($args['include_website']) && $args['include_website'] === 'all' )
            || (isset($args['blog_ids'])        && $args['blog_ids'] === 'all' )
            || (isset($args['site_ids'])        && $args['site_ids'] === 'all' ) )
        {
            $args['class'] = '*';
        }

        if (!empty($args['ignore_archive_context'])) {
            $ctx->stash('contents', null);
            $ctx->stash('entries', null);
            $ctx->stash('current_timestamp', null);
            $ctx->stash('current_timestamp_end', null);
            $ctx->stash('category', null);
            $ctx->stash('archive_category', null);
        }

        # Load multiblog access control list
        $acl = multiblog_load_acl($ctx);
        if ( !empty($acl) && !empty($acl['allow']) )
            $args['allows'] = $acl['allow'];
        elseif ( !empty($acl) && !empty($acl['deny']) )
            $args['denies'] = $acl['deny'];

        if (!(
            isset($args['include_sites']) ||
            isset($args['exclude_sites']) ||
            isset($args['include_blogs']) ||
            isset($args['exclude_blogs']) ||
            isset($args['include_websites']) ||
            isset($args['exclude_websites']) ||
            isset($args['blog_ids']) ||
            isset($args['site_ids']) ||
            isset($args['blog_id']) ||
            isset($args['site_id']) # in smarty_block_mtblogparentwebsite
        )) {
            $args['include_blogs'] = 'all';
        }
 
        if (!isset($args['class']) && $ctx->this_tag() == 'mtmultiblog') {
            $args['class'] = '*';
        }

        $blogs = $ctx->mt->db()->fetch_blogs($args);
        $ctx->stash('_blogs', $blogs);
        $counter = 0;
    } else {
        $blogs = $ctx->stash('_blogs');
        $counter = $ctx->stash('_blogs_counter');
    }
    if (is_array($blogs) && $counter < count($blogs)) {
        $blog = $blogs[$counter];
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog->blog_id);
        $ctx->stash('_blogs_counter', $counter + 1);
        $ctx->stash($prefix . 'context', 'include_blogs');
        $ctx->stash($prefix . 'blog_ids', $blog->blog_id);
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($blogs));
        $repeat = true;
    } else {
        # Restore localized variables once we're 
        # finished with all blogs in scope
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}

function _context_prefix($tag) {
    if ($tag === 'mtsites') {
        return 'sites_';
    } elseif ($tag === 'mtchildsites') {
        return 'childsites_';
    } else {
        return 'multiblog_';
    }
}
?>
