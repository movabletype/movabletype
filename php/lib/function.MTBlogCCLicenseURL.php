<?php
function smarty_function_MTBlogCCLicenseURL($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $cc = $blog['blog_cc_license'];
    if (empty($cc)) return '';
    require_once("cc_lib.php");
    return cc_url($cc);
}
?>
