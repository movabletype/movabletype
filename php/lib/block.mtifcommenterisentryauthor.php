<?php
function smarty_block_mtifcommenterisentryauthor($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $cmtr = $ctx->stash('commenter');
        $entry = $ctx->stash('entry');
        if (!isset($cmtr) || !isset($entry)) {
            return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        }
        $is_entryauthor =
            $cmtr['author_type'] == 1
          ? $cmtr['author_id'] == $entry['entry_author_id'] ? 1 : 0
          : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $is_entryauthor);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
