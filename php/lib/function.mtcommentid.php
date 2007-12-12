<?php
function smarty_function_mtcommentid($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $id = $comment['comment_id'];
    if (isset($args['pad']) && $args['pad']) {
        $id = sprintf("%06d", $id);
    }
    return $id;
}
?>
