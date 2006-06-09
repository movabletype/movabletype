<?php
function smarty_function_MTCommentEntryID($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $id = $comment['comment_entry_id'];
    if (isset($args['pad']) && $args['pad']) {
        $id = sprintf("%06d", $id);
    }
    return $id;
}
?>
