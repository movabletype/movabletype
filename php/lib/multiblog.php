<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

$mt = MT::get_instance();
$ctx = &$mt->context();

define('MULTIBLOG_ENABLED', 1);
define('MULTIBLOG_ACCESS_DENIED', 1);
define('MULTIBLOG_ACCESS_ALLOWED', 2);

#$ctx->add_conditional_tag('mtmultiblogiflocalblog');

# Special handler for MTInclude
function multiblog_MTInclude(&$args, &$_smarty_tpl) {
    $ctx = $_smarty_tpl->smarty;

    if (isset($args['blog_id'])) {
    # Load multiblog access control list
        $acl = multiblog_load_acl($ctx);
        if ( !empty($acl) && !empty($acl['allow']) )
            $args['allows'] = $acl['allow'];
        elseif ( !empty($acl) && !empty($acl['deny']) )
            $args['denies'] = $acl['deny'];
    } else {
        # Explicitly set blog_id attribute to local blog.
        # so MTInclude is never affected by multiblog context
        if ($ctx->stash('multiblog_context')) {
            if (
                empty($args['local']) &&
                empty($args['global']) &&
                empty($args['parent'])
            ) {
                $args['blog_id'] = $ctx->stash('blog_id');
            }
            else if (! empty($args['local'])) {
                $args['blog_id'] = $ctx->stash('local_blog_id');
                $args['blog_id'] or $args['blog_id'] = $ctx->mt->blog->id;
            }
        }
        else {
            $args['blog_id'] = $ctx->stash('local_blog_id');
            $args['blog_id'] or $args['blog_id'] = $ctx->mt->blog->id;
        }
    }
}

# MultiBlog plugin wrapper for function tags (i.e. variable tags)
function multiblog_function_wrapper($tag, &$args, &$_smarty_tpl) {
    $ctx = $_smarty_tpl->smarty;

    $localvars = array('local_blog_id');
    $ctx->localize($localvars);

    # Load multiblog access control list
    $incl = !empty($args['include_sites'])
         || !empty($args['include_blogs'])
         || !empty($args['include_websites'])
         || !empty($args['blog_id'])
         || !empty($args['blog_ids'])
         || (!empty($tag) && $tag == 'mtblogs')
         || (!empty($tag) && $tag == 'mtwebsites');
    $excl = !empty($args['exclude_blogs'])
         || !empty($args['exclude_websites']);
    if ( $incl || $excl ) {
        $acl = multiblog_load_acl($ctx);
        if ( !empty($acl) && !empty($acl['allow']) )
            $args['allows'] = $acl['allow'];
        elseif ( !empty($acl) && !empty($acl['deny']) )
            $args['denies'] = $acl['deny'];
    }

    # Set multiblog tag context if applicable
    if ($ctx->stash('multiblog_context')) {
        $include_blogs = $ctx->stash('multiblog_include_blog_ids');
        if (isset($include_blogs))
            $args['include_blogs'] = $include_blogs;

        $exclude_blogs = $ctx->stash('multiblog_exclude_blog_ids');
        if (isset($exclude_blogs))
            $args['exclude_blogs'] = $exclude_blogs;

        $include_with_website = $ctx->stash('multiblog_include_with_website');
        if (isset($include_with_website))
            $args['include_with_website'] = $include_with_website;
    }

    # Restore localized variables
    $ctx->restore($localvars);
}

# MultiBlog plugin wrapper for block tags (i.e. container/conditional)
function multiblog_block_wrapper(&$args, $content, &$_smarty_tpl, &$repeat) {
    $ctx = $_smarty_tpl->smarty;
    $tag = $ctx->this_tag();

    if (!isset($content)) {
        $ctx->set_override_context( true );

        if (
            ($tag === 'mtblogs' || $tag === 'mtwebsites')
            && !empty($args['ignore_archive_context'])
        ) {
            $ctx->stash('entries', null);
            $ctx->stash('current_timestamp', null);
            $ctx->stash('current_timestamp_end', null);
            $ctx->stash('category', null);
            $ctx->stash('archive_category', null);
        }

        # Set multiblog tag context if applicable
        if ($ctx->stash('multiblog_context')) {
            $incl = $ctx->stash('multiblog_include_blog_ids');
            if (isset($incl))
                $args['include_blogs'] = $incl;

            $excl = $ctx->stash('multiblog_exclude_blog_ids');
            if (isset($excl))
                $args['exclude_blogs'] = $excl;

            $include_with_website = $ctx->stash('multiblog_include_with_website');
            if (isset($include_with_website))
                $args['include_with_website'] = $include_with_website;
        }

        # Load multiblog access control list
        $incl = !empty($args['include_sites'])
             || !empty($args['include_blogs'])
             || !empty($args['include_websites'])
             || !empty($args['blog_id'])
             || !empty($args['blog_ids'])
             || $tag == 'mtblogs'
             || $tag == 'mtwebsites';
        $excl = !empty($args['exclude_sites'])
             || !empty($args['exclude_blogs'])
             || !empty($args['exclude_websites']);
        if ( $incl || $excl ) {
            $acl = multiblog_load_acl($ctx);
            if ( !empty($acl) && !empty($acl['allow']) )
                $args['allows'] = $acl['allow'];
            elseif ( !empty($acl) && !empty($acl['deny']) )
                $args['denies'] = $acl['deny'];
        }

        # Fix for MTMultiBlogIfLocalBlog which should never return
        # true with MTTags block because tags are cross-blog
        if ($ctx->this_tag() == 'mttags')
            $ctx->stash('local_blog_id', 0);
    }
}

function multiblog_load_acl($ctx) {
    # Set local blog
    $this_blog = $ctx->stash('blog_id');

    # Get the MultiBlog system config for default access and overrides
    $default_access_allowed = $ctx->mt->config('DefaultAccessAllowed');
    if (!isset($default_access_allowed))
        $default_access_allowed = 1;
    $cfg_access_overrides = $ctx->mt->config('AccessOverrides');
    $access_overrides = isset($cfg_access_overrides) ? json_decode( $cfg_access_overrides, true ) : array();

    $allow = array();
    $deny = array();
    if ($default_access_allowed) {
        foreach (array_keys($access_overrides) as $o) {
            if (($o != $this_blog) && (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_DENIED)))
                $deny[] = $o;
        }
    } else {
        foreach (array_keys($access_overrides) as $o) {
            if (($o == $this_blog) || (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_ALLOWED)))
                $allow[] = $o;
        }
        if (!isset($access_overrides[$this_blog]))
            $allow[] = $this_blog;
    }

    return array( 'allow' => $allow, 'deny' => $deny );
}

## Get a mode (include/exclude) and list of blogs
## Process list using system default access setting and
## any blog-level overrides.
## Returns empty list if no blogs can be used
function multiblog_filter_blogs(&$ctx, $is_include, $blogs) {

    # Set flag to indicate whether @blogs are to be included or excluded
    $is_include = $is_include == 'include_blogs' ? 1 : 0;

    # Set local blog
    $this_blog = $ctx->stash('blog_id');

    # Get the MultiBlog system config for default access and overrides
    $default_access_allowed = $ctx->mt->config('DefaultAccessAllowed');
    if (!isset($default_access_allowed))
        $default_access_allowed = 1;
    $cfg_access_overrides = $ctx->mt->config('AccessOverrides');
    $access_overrides = isset($cfg_access_overrides) ? json_decode( $cfg_access_overrides, true ) : array();

    # System setting allows access by default
    if ($default_access_allowed) {
        # include_blogs="all"
        if ($is_include && ($blogs[0] == "all")) {
            # Check for any deny overrides. 
            # If found, switch to exclude_blogs="..."
            $deny = array();
            foreach (array_keys($access_overrides) as $o) {
                if (($o != $this_blog) && (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_DENIED)))
                    $deny[] = $o;
            }
            return count($deny) ? array('exclude_blogs', $deny)
                         : array('include_blogs', array('all'));
        } elseif ( ( $blogs[0] == 'site' )
            || ( $blogs[0] == 'children' )
            || ( $blogs[0] == 'siblings' )
        ) {
            $mt = MT::get_instance();
            $ctx = $mt->context();
            $blog = $ctx->stash('blog');
            $allow = array();
            if ( !empty($blog) ) {
                $website = $blog->class == 'blog' ? $blog->website() : $blog;
                $blogs = $website->blogs();
                if ( empty( $blogs ) )
                    $blogs = array();
                foreach($blogs as $b) {
                    if ($b->id == $this_blog || (!isset($access_overrides[$b->id])) || ($access_overrides[$b->id] == MULTIBLOG_ACCESS_ALLOWED))
                    array_push($allow, $b->id);
                }
            }
            return count($allow) ? array('include_blogs', $allow) : null;
        }
        # include_blogs="1,2,3,4"
        elseif ($is_include && count($blogs)) {
            # Remove any included blogs that are specifically deny override
            # Return undef is all specified blogs are deny override
            $allow = array();
            foreach ($blogs as $b)
                if ($b == $this_blog || (!isset($access_overrides[$b])) || ($access_overrides[$b] == MULTIBLOG_ACCESS_ALLOWED))
                    $allow[] = $b;
            return count($allow) ? array('include_blogs', $allow) : null;
        }
        # exclude_blogs="1,2,3,4"
        else {
             # Add any deny overrides blogs to the list and de-dupe
             foreach (array_keys($access_overrides) as $o)
                if (($o != $this_blog) && (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_DENIED)))
                    $blogs[] = $o;
             $seen = array();
             foreach ($blogs as $b)
                $seen[$b] = 1;
             $blogs = array_keys($seen);
             return array('exclude_blogs', $blogs);
        }
    }
    # System setting does not allow access by default
    else {
        # include_blogs="all"
        if ($is_include && ($blogs[0] == "all")) {
            # Enumerate blogs from allow override
            # Hopefully this is significantly smaller than @all_blogs
            $allow = array();
            foreach (array_keys($access_overrides) as $o)
                if (($o == $this_blog)
                || (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_ALLOWED)))
                    $allow[] = $o;
            if (!isset($access_overrides[$this_blog]))
                $allow[] = $this_blog;
            return count($allow) ? array('include_blogs', $allow) : null;
        } elseif ( ( $blogs[0] == 'site' )
            || ( $blogs[0] == 'children' )
            || ( $blogs[0] == 'siblings' )
        ) {
            $mt = MT::get_instance();
            $ctx = $mt->context();
            $blog = $ctx->stash('blog');
            $allow = array();
            if (!empty($blog) && $blog->class == 'blog') {
                require_once('class.mt_blog.php');
                $blog_class = new Blog();
                $blogs = $blog_class->Find("blog_parent_id = " . $blog->parent_id);
                foreach($blogs as $b) {
                    if ($b->id == $this_blog
                    || (isset($access_overrides[$b->id]) && ($access_overrides[$b->id] == MULTIBLOG_ACCESS_ALLOWED)))
                        array_push($allow, $b->id);
                }
            }
            return count($allow) ? array('include_blogs', $allow) : null;
        }
        # include_blogs="1,2,3,4"
        elseif ($is_include && count($blogs)) {
            # Filter @blogs returning only those with allow override
            $allow = array();
            foreach ($blogs as $b)
                if ($b == $this_blog
                || (isset($access_overrides[$b]) && ($access_overrides[$b] == MULTIBLOG_ACCESS_ALLOWED)))
                    $allow[] = $b;

            return count($allow) ? array('include_blogs', $allow) : null;
        }
        # exclude_blogs="1,2,3,4"
        else {
            # Get allow override blogs and then omit 
            # the specified excluded blogs.
            $allow = array();
            foreach (array_keys($access_overrides) as $o)
                if (($o == $this_blog)
                || (isset($access_overrides[$o]) && ($access_overrides[$o] == MULTIBLOG_ACCESS_ALLOWED)))
                    $allow[] = $o;
            if (!isset($access_overrides[$this_blog]))
                $allow[] = $this_blog;
            $seen = array();
            foreach ($blogs as $b)
                $seen[$b] = 1;
            $blogs = array();
            foreach ($allow as $a)
                if (!isset($seen[$a])) $blogs[] = $a;
            return count($blogs) ? array('include_blogs', $blogs) : null;
        }
    }
}
?>
