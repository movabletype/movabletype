<?php
function smarty_function_mtcommentip($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return $comment['comment_ip'];
}
?>
