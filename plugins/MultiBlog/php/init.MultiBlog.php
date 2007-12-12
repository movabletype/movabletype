<?php
# $Id$

global $mt;
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
        if (!multiblog_filter_blogs_from_args($ctx, $args))
            return '';
    } else {
        # Explicitly set blog_id attribute to local blog.
        # so MTInclude is never affected by multiblog context
        $args['blog_id'] = $ctx->stash('local_blog_id');            
        $args['blog_id'] or $args['blog_id'] = $ctx->mt->blog['blog_id'];
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
    
    # Filter blogs from multiblog tag attributes if any
    if (!multiblog_filter_blogs_from_args($ctx, $args)) {
        $result = 0;
    # Set multiblog tag context if applicable
    } elseif ($mode = $ctx->stash('multiblog_context')) {
        $args[$mode] = $ctx->stash('multiblog_blog_ids');
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
        # Filter blogs from multiblog tag attributes if any
        if (!multiblog_filter_blogs_from_args($ctx, $args)) {
            $repeat = false;
            $ctx->restore($localvars);
            return '';
        # Set multiblog tag context if applicable
        } elseif ($mode = $ctx->stash('multiblog_context')) {
            $args[$mode] = $ctx->stash('multiblog_blog_ids');
        }
    }
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

function multiblog_filter_blogs_from_args(&$ctx, &$args) { 

    # SANITY CHECK ON ARGUMENTS

    # Set and clean up working variables
    $incl = $args['include_blogs'];
    $incl or $incl = $args['blog_ids'];
    $incl or $incl = $args['blog_id'];
    $excl = $args['exclude_blogs'];
    # Remove spaces
    $incl = preg_replace('/\s+/', '', $incl);
    $excl = preg_replace('/\s+/', '', $excl);

    # If there are no multiblog arguments to filter, we don't need to be here
    if (! ($incl or $excl))
        return true;
    # Only one multiblog argument can be used
    $tagcount = 0;
    $possible_args = array( $args['include_blogs'],
                            $args['blog_ids'],
                            $args['blog_id'],
                            $args['exclude_blogs']);
    foreach ($possible_args as $arg)
        $arg != '' and $tagcount++;
    if ($tagcount > 1)
        return false;

    # exclude_blogs="all" is not allowed
    if ($excl and ($excl == 'all'))
        return false; 

    # blog_id attribute only accepts a single blog ID
    if ($args['blog_id'] and !preg_match('/^\d+$/', $args['blog_id']))
        return false;

    # Make sure include_blogs/exclude_blogs is valid
    if (($incl or $excl) != 'all' 
        and !preg_match('/^\d+(,\d+)*$/', $incl or $excl)) {
            return false;
    }

    # Prepare for filter_blogs
    $blogs = array();
    $attr = $incl ? 'include_blogs' : 'exclude_blogs';
    $val = $incl ? $incl : $excl;
    $blogs = preg_split('/,/', $val);

    # Filter the blogs using the MultiBlog access controls
    list($attr, $blogs) = multiblog_filter_blogs($ctx, $attr, $blogs);
    if (!($attr && count($blogs)))
        return false;

    # Rewrite the args to the modifed value
    if ($args['blog_ids'])
        unset($args['blog_ids']);  // Deprecated
    if ($args['blog_id']) {
        $args['blog_id'] = $blogs[0];
    } else {
        unset($args['include_blogs']);
        unset($args['exclude_blogs']);
        $args[$attr] = implode(',', $blogs);
    }
    return true;
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
    global $mt;
    if (!$multiblog_system_config)
        $multiblog_system_config = $mt->db->fetch_plugin_config('MultiBlog', 'system');

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
