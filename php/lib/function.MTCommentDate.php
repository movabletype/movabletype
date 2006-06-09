<?php
function smarty_function_MTCommentDate($args, &$ctx) {
    $c = $ctx->stash('comment');
    $args['ts'] = $c['comment_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>
