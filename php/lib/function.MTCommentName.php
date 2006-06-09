<?php
function smarty_function_MTCommentName($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment['comment_author'];
}
?>
