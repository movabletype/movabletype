<?php
function smarty_function_mtcommentname($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment['comment_author'];
}
?>
