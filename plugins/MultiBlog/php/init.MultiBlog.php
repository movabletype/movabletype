<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

$mt = MT::get_instance();
$ctx = &$mt->context();

# Check to see if MultiBlog is disabled...
$switch = $mt->config('PluginSwitch');
if (isset($switch) && isset($switch['MultiBlog/multiblog.pl'])) {
    if (!$switch['MultiBlog/multiblog.pl']) {
        define('MULTIBLOG_ENABLED', 0);
        return;
    }
}

define('MULTIBLOG_ENABLED', 1);
define('MULTIBLOG_ACCESS_DENIED', 1);
define('MULTIBLOG_ACCESS_ALLOWED', 2);

# override handler for the following tags.  the overridden version
# will, in turn call the MT native handlers...
global $multiblog_orig_handlers;
$multiblog_orig_handlers = array();
$multiblog_orig_handlers['mtblogpingcount']
    = $ctx->add_tag('blogpingcount', 'multiblog_MTBlogPingCount');
$multiblog_orig_handlers['mtblogcommentcount']
    = $ctx->add_tag('blogcommentcount', 'multiblog_MTBlogCommentCount');
$multiblog_orig_handlers['mtblogcategorycount']
    = $ctx->add_tag('blogcategorycount', 'multiblog_MTBlogCategoryCount');
$multiblog_orig_handlers['mtblogentrycount']
    = $ctx->add_tag('blogentrycount', 'multiblog_MTBlogEntryCount');
$multiblog_orig_handlers['mtauthors']
    = $ctx->add_container_tag('authors', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtentries']
    = $ctx->add_container_tag('entries', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtcomments']
    = $ctx->add_container_tag('comments', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtcategories']
    = $ctx->add_container_tag('categories', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtpages']
    = $ctx->add_container_tag('pages', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtfolders']
    = $ctx->add_container_tag('folders', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtpings']
    = $ctx->add_container_tag('pings', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtblogs']
    = $ctx->add_container_tag('blogs', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mttags']
    = $ctx->add_container_tag('tags', 'multiblog_block_wrapper');
$multiblog_orig_handlers['mtinclude']
    = $ctx->add_tag('include', 'multiblog_MTInclude');
$multiblog_orig_handlers['mttagsearchlink']
    = $ctx->add_tag('tagsearchlink', 'multiblog_MTTagSearchLink');

$ctx->add_conditional_tag('mtmultiblogiflocalblog');

function multiblog_MTBlogCategoryCount($args, &$ctx) {
    return multiblog_function_wrapper('mtblogcategorycount', $args, $ctx);
}
function multiblog_MTBlogCommentCount($args, &$ctx) {
    return multiblog_function_wrapper('mtblogcommentcount', $args, $ctx);
}
function multiblog_MTBlogPingCount($args, &$ctx) {
    return multiblog_function_wrapper('mtblogpingcount', $args, $ctx);
}
function multiblog_MTBlogEntryCount($args, &$ctx) {
    return multiblog_function_wrapper('mtblogentrycount', $args, $ctx);
}
function multiblog_MTTagSearchLink($args, &$ctx) {
    return multiblog_function_wrapper('mttagsearchlink', $args, $ctx);
}
# Special handler for MTInclude
function multiblog_MTInclude($args, &$ctx) {
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
        $args['blog_id'] = $ctx->stash('local_blog_id');            
        $args['blog_id'] or $args['blog_id'] = $ctx->mt->blog->id;
    }
    global $multiblog_orig_handlers;
    $fn = $multiblog_orig_handlers['mtinclude'];
    $result = $fn($args, $ctx);
    return $result;
}

# MultiBlog plugin wrapper for function tags (i.e. variable tags)
function multiblog_function_wrapper($tag, $args, &$ctx) {
    $localvars = array('local_blog_id');
    $ctx->localize($localvars);
    
    # Load multiblog access control list
    $acl = multiblog_load_acl($ctx);
    if ( !empty($acl) && !empty($acl['allow']) )
        $args['allows'] = $acl['allow'];
    elseif ( !empty($acl) && !empty($acl['deny']) )
        $args['denies'] = $acl['deny'];

    # Set multiblog tag context if applicable
    if ($ctx->stash('multiblog_context')) {
        $incl = $ctx->stash('multiblog_include_blog_ids');
        if (isset($incl))
            $args['include_blogs'] = $incl;
        
        $excl = $ctx->stash('multiblog_exclude_blog_ids');
        if (isset($excl))
            $args['exclude_blogs'] = $excl;
    }

    # Call original tag handler with new multiblog args
    global $multiblog_orig_handlers;
    $fn = $multiblog_orig_handlers[$tag];
    $result = $fn($args, $ctx);

    # Restore localized variables
    $ctx->restore($localvars);
    return $result;
}

# MultiBlog plugin wrapper for block tags (i.e. container/conditional)
function multiblog_block_wrapper($args, $content, &$ctx, &$repeat) {
    $tag = $ctx->this_tag();
    $localvars = array('local_blog_id');
    if (!isset($content)) {
        $ctx->localize($localvars);

        # Set multiblog tag context if applicable
        if ($ctx->stash('multiblog_context')) {
            $incl = $ctx->stash('multiblog_include_blog_ids');
            if (isset($incl))
                $args['include_blogs'] = $incl;

            $excl = $ctx->stash('multiblog_exclude_blog_ids');
            if (isset($excl))
                $args['exclude_blogs'] = $excl;
        }
    }

    # Load multiblog access control list
    $acl = multiblog_load_acl($ctx);
    if ( !empty($acl) && !empty($acl['allow']) )
        $args['allows'] = $acl['allow'];
    elseif ( !empty($acl) && !empty($acl['deny']) )
        $args['denies'] = $acl['deny'];

    # Fix for MTMultiBlogIfLocalBlog which should never return
    # true with MTTags block because tags are cross-blog
    if ($ctx->this_tag() == 'mttags')
        $ctx->stash('local_blog_id', 0);

    # Call original tag handler with new multiblog args
    global $multiblog_orig_handlers;
    $fn = $multiblog_orig_handlers[$tag];
    $result = $fn($args, $content, $ctx, $repeat);

    # Restore localized variables if last loop
    if (!$repeat)
        $ctx->restore($localvars);
    return $result;
}

function multiblog_load_acl($ctx) {
    # Set local blog
    $mt = MT::get_instance();
    $this_blog = $ctx->stash('blog_id');


    # Get the MultiBlog system config for default access and overrides
    $multiblog_system_config = $mt->db()->fetch_plugin_config('MultiBlog', 'system');

    $default_access_allowed = 1;
    if (isset($multiblog_system_config['default_access_allowed']))
        $default_access_allowed = $multiblog_system_config['default_access_allowed'];

    $access_overrides = $multiblog_system_config['access_overrides'];
    if (empty($access_overrides))
        $access_overrides = array();

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

    global $multiblog_system_config;
    $mt = MT::get_instance();
    if (!$multiblog_system_config)
        $multiblog_system_config = $mt->db()->fetch_plugin_config('MultiBlog', 'system');

    # Get the MultiBlog system config for default access and overrides
    if (isset($multiblog_system_config['default_access_allowed']))
        $default_access_allowed = $multiblog_system_config['default_access_allowed'];
    else
        $default_access_allowed = 1;
    $access_overrides = 
        $multiblog_system_config['access_overrides'];
    if (!$access_overrides) $access_overrides = array();

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
            if ( !empty($blog) ) {
                $website = $blog->class == 'blog' ? $blog->website() : $blog;
                $blogs = $website->blogs();
                if ( empty( $blogs ) )
                    $blogs = array();
                $allow = array();
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
            if (!empty($blog) && $blog->class == 'blog') {
                require_once('class.mt_blog.php');
                $blog_class = new Blog();
                $blogs = $blog_class->Find("blog_parent_id = " . $blog->parent_id);
                $allow = array();
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
