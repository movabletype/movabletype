<?php
function smarty_function_MTBlogEntryCount($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog_id = $ctx->stash('blog_id');
    $count = $ctx->mt->db->blog_entry_count($blog_id);
    return $count;
}
?>
