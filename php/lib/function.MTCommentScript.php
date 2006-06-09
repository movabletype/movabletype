<?php
function smarty_function_MTCommentScript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config['CommentScript'];
}
?>
