<?php
function smarty_modifier_sanitize($text, $spec) {
    if ($spec == '1') {
        global $mt;
        $ctx =& $mt->context();
        $blog = $ctx->stash('blog');
        $spec = $blog['blog_sanitize_spec'];
        $spec or $spec = $mt->config['GlobalSanitizeSpec'];
    }
    require_once("sanitize_lib.php");
    return sanitize($text, $spec);
}
?>
