<?php
function smarty_block_mtifnonzero($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: tag
    if (!isset($content)) {
        $ctx->localize(array('conditional', 'else_content'));
        $tag = $args['tag'];
        $tag = preg_replace('/^mt/', '', $tag);
        $output = $ctx->tag($tag, $args);
        $ctx->stash('conditional', ($output != '0' && $output != ''));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('conditional', 'else_content'));
    }
    return $content;
}
?>
