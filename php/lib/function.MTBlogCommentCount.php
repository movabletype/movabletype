<?php
function smarty_function_MTBlogCommentCount($args, &$ctx) {
    $blog_id = $ctx->stash('blog_id');
    return $ctx->mt->db->blog_comment_count($blog_id);
}
?>
