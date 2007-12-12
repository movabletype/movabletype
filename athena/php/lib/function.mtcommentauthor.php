<?php
function smarty_function_mtcommentauthor($args, &$ctx) {
    $c = $ctx->stash('comment');
    if (!$c) {
        return $ctx->error("No comment available");
    }
    $a = isset($c['comment_author']) ? $c['comment_author'] : '';
    if (isset($args['default'])) {
        $a or $a = $args['default'];
    }
    $a or $a = '';
    return strip_tags($a);
}
?>
