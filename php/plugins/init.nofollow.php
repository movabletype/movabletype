<?php
# $Id$
# Released under the Artistic License

global $mt;
$ctx = &$mt->context();

# override handler for the following tags.  the overridden version
# will, in turn call the MT native handlers...
$ctx->register_function('MTCommentBody', 'mtcommentbody_nofollowfy');
$ctx->register_function('MTCommentAuthorLink', 'mtcommentauthorlink_nofollowfy');
$ctx->register_block('MTPings', 'mtpings_nofollowfy');

# disable MT-forced sanitization for these tags. we'll handle it ourselves...
unset($ctx->sanitized['MTCommentAuthorLink']);
unset($ctx->sanitized['MTCommentBody']);
$ctx->add_global_filter('nofollowfy', 'nofollowfy');

function nofollow_config($ctx) {
    $config = $ctx->stash('nofollow_config');
    if ($config)
        return $config;
    $blog_id = $ctx->stash('blog_id');
    $config = $ctx->mt->db->fetch_plugin_config('Nofollow', 'blog:' . $blog_id);
    if (!$config)
        $config = $ctx->mt->db->fetch_plugin_config('Nofollow');
    if (!$config)
        $config = array('follow_auth_links' => 0);
    $ctx->stash('nofollow_config', $config);
    return $config;
}

function sanitize_nofollowfy($str, $arg = 1) {
    if (!isset($arg)) $arg = '1';
    if ($arg) {
        require_once("modifier.sanitize.php");
        $str = smarty_modifier_sanitize($str, $arg);
    }
    return nofollowfy($str);
}

function nofollowfy($str, $arg = 1) {
    # manipulate hyperlinks in $str...
    if (!isset($str)) return $str;
    if (!$arg) return $str;
    return preg_replace_callback('#<a\s([^>]*\s*href\s*=[^>]*)>#i', 'nofollowfy_cb', $str);
}

function nofollowfy_cb($matches) {
    $str = $matches[1];
    preg_match_all('/[^=[:space:]]*\s*=\s*"[^"]*"|[^=[:space:]]*\s*=\s*\'[^\']*\'|[^=[:space:]]*\s*=[^[:space:]]*/', $str, $attr);
    $rel_arr = preg_grep('/^rel\s*=/i', $attr[0]);
    $attr = array_diff($attr[0], $rel_arr);
    if (count($rel_arr) > 0)
        $rel = array_pop($rel_arr);
    if ($rel) {
        $rel = preg_replace('/ ?\bnofollow\b ?/', ' ', $rel);
        $rel = preg_replace('/^(rel\s*=\s*[\'"]?) ?/i', '\1nofollow ', $rel);
    } else {
        $rel = 'rel="nofollow"';
    }
    return '<a ' . join(' ', $attr) . ' ' . $rel . '>';
}

function mtcommentbody_nofollowfy($args, &$ctx) {
    require_once("function.MTCommentBody.php");
    $comment = $ctx->stash('comment');
    $body = smarty_function_MTCommentBody($args, $ctx);
    if ($comment['comment_commenter_id']) {
        // is an authenticated comment
        $auth = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
        $config = nofollow_config($ctx);
        if ($auth && $config['follow_auth_links'])
            return $body;
    }
    return sanitize_nofollowfy($body, $args['sanitize']);
}
function mtcommentauthorlink_nofollowfy($args, &$ctx) {
    require_once("function.MTCommentAuthorLink.php");
    if (!isset($args['no_redirect'])) $args['no_redirect'] = 1;
    $link = smarty_function_MTCommentAuthorLink($args, $ctx);
    $comment = $ctx->stash('comment');
    if ($comment['comment_commenter_id']) {
        // is an authenticated comment
        $auth = $ctx->mt->db->fetch_author($comment['comment_commenter_id']);
        $config = nofollow_config($ctx);
        if ($auth && $config['follow_auth_links'])
            return $link;
    }
    return sanitize_nofollowfy($link, $args['sanitize']);
}
function mtpings_nofollowfy($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) require_once("block.MTPings.php");
    return nofollowfy(smarty_block_MTPings($args, $content, $ctx, $repeat), $args['sanitize']);
}
?>
