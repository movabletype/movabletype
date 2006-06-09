<?php
function smarty_function_MTCommentIP($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment['comment_ip'];
}
?>
