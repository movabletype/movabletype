<?php
function smarty_function_mtcommentauthoridentity($args, &$ctx) {
    $cmt = $ctx->stash('comment');
    if ($cmt['comment_commenter_id']) {
        # load author related to this commenter.
        $auth = $ctx->mt->db->fetch_author($cmt['comment_commenter_id']);
        if (!$auth) return "?";
        if (isset($auth['author_url'])) {
            $link = $auth['author_url'];
        } else {
            return "";
        }
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config('PublishCommenterIcon')) {
            $root_url = $blog['blog_site_url'];
        } else {
            require_once "function.mtstaticwebpath.php";
            $root_url = smarty_function_mtstaticwebpath($args, $ctx);
            $root_url .= 'images/';
        }
        if (!preg_match('!/$!', $root_url))
            $root_url .= '/';
        return "<a class=\"commenter-profile\" href=\"$link\"><img alt=\"Author Profile Page\" src=\"$root_url/nav-commenters.gif\" width=\"22\" height=\"15\" /></a>";
    } else {
        return "";
    }
}
?>
