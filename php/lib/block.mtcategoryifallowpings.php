<?php
function smarty_block_mtcategoryifallowpings($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entry = $ctx->stash('category');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $entry['category_allow_pings'] > 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>