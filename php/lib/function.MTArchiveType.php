<?php
function smarty_function_MTArchiveType($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    return $at;
}
?>
