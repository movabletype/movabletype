<?php
function smarty_function_MTCommenterName($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    return isset($a) ? $a['author_name'] : '';
}
?>
