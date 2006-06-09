<?php
function smarty_block_MTBlogIfCCLicense($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !empty($blog['blog_cc_license']));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
