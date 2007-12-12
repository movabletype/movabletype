<?php
function smarty_function_mtpingblogname($args, &$ctx) {
    $ping = $ctx->stash('ping');
    return $ping['tbping_blog_name'];
}
?>
