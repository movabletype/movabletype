<?php
function smarty_block_mtfolderfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $categories =& $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 
            ($counter == count($categories) || $ctx->stash('subFolderFoot'))
        );
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
