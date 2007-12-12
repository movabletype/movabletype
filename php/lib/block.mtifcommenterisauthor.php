<?php
function smarty_block_mtifcommenterisauthor($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $cmtr = $ctx->stash('commenter');
        if (!isset($cmtr)) {
            return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        }
        $is_author = $cmtr['author_type'] == 1 ? 1 : 0;
            return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $is_author);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
