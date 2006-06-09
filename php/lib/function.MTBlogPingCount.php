<?php
function smarty_function_MTBlogPingCount($args, &$ctx) {
    $blog_id = $ctx->stash('blog_id');
    return $ctx->mt->db->blog_ping_count($blog_id);
}
?>
