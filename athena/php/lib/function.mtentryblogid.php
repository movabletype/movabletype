<?php
function smarty_function_mtentryblogid($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $entry['entry_blog_id']) : $entry['entry_blog_id'];
}
?>
