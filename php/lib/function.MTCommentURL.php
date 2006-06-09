<?php
function smarty_function_MTCommentURL($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment['comment_url'];
}
?>
