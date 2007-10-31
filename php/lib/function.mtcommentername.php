<?php
function smarty_function_mtcommentername($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    return isset($a) ? $a['author_name'] : '';
}
?>
