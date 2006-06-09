<?php
function smarty_function_MTCommentAuthorIdentity($args, &$ctx) {
    $cmt = $ctx->stash('comment');
    if ($cmt['comment_commenter_id']) {
        # load author related to this commenter.
        $auth = $ctx->mt->db->fetch_author($cmt['comment_commenter_id']);
        if (!$auth) return "?";
        $link = $ctx->mt->config['IdentityURL'];
        $link = preg_replace('@/$@', '', $link);
        $link .= "/" . $auth['author_name'];
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config['PublishCommenterIcon']) {
            $root_url = $blog['blog_site_url'];
        } else {
            require_once "function.MTStaticWebPath.php";
            $root_url = smarty_function_MTStaticWebPath($args, $ctx);
            $root_url .= 'images/';
        }
        if (!preg_match('!/$!', $root_url))
            $root_url .= '/';
        return "<a class=\"commenter-profile\" href=\"$link\"><img alt='[TypeKey Profile Page]' src='$root_url"."nav-commenters.gif' /></a>";
    } else {
        return "";
    }
}
?>
