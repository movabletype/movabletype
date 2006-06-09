<?php
function smarty_function_MTArchiveCount($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        return $count;
    } else {
        $entries = $ctx->stash('entries');
        return count($entries);
    }
}
?>
