<?php
function smarty_function_mtarchivetype($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    return $at;
}
?>
