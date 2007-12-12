<?php
function smarty_function_mtcommentscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('CommentScript');
}
?>
