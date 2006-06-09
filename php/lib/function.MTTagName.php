<?php
function smarty_function_MTTagName($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_array($tag)) {
        return $tag['tag_name'];
    } else {
        return $tag;
    }
}
?>
