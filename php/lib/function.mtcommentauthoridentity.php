<?php
function smarty_function_mtcommentauthoridentity($args, &$ctx) {
    $cmt = $ctx->stash('comment');
    $cmntr = $ctx->stash('commenter');
    if (!$cmntr) {
        if ($cmt['comment_commenter_id']) {
            # load author related to this commenter.
            $cmntr = $ctx->mt->db->fetch_author($cmt['comment_commenter_id']);
            if (!$cmntr) return "?";
        }
    }
    if (!$cmntr) return "";
    if (isset($cmntr['author_url'])) {
        $link = $cmntr['author_url'];
    } else {
        return "";
    }
    require_once "function.mtstaticwebpath.php";
    $static_path = smarty_function_mtstaticwebpath($args, $ctx);
    require_once "commenter_auth_lib.php";
    $logo = _auth_icon_url($static_path, $cmntr);
    if (!$logo) {
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config('PublishCommenterIcon')) {
            $root_url = $blog['blog_site_url'];
        } else {
            $root_url = $static_path . 'images/';
        }
        if (!preg_match('/\/$/', $root_url)) {
            $root_url .= '/';
        }
        $logo = $root_url . "nav-commenters.gif";
    }
    return "<a class=\"commenter-profile\" href=\"$link\"><img alt=\"Author Profile Page\" src=\"$logo\" width=\"16\" height=\"16\" /></a>";
}
?>
