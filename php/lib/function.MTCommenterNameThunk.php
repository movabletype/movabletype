<?php
function smarty_function_MTCommenterNameThunk($args, &$ctx) {
    $cfg =& $ctx->mt->config;
    $blog = $ctx->stash('blog');
    $archive_url = $ctx->tag('BlogArchiveURL');
    if (preg_match('|://([^/]*)|', $archive_url, $matches)) {
        $blog_domain = $matches[1];
    }
    require_once "function.MTCGIPath.php";
    $cgi_path = smarty_function_MTCGIPath($args, $ctx);
    $mt_domain = $cgi_path;
    if (preg_match('|://([^/]*)|', $mt_domain, $matches)) {
        $mt_domain = $matches[1];
    }
    if ($blog_domain != $mt_domain) {
        $cmt_script = $cfg['CommentScript'];
        return "<script type='text/javascript' src='$cgi_path$cmt_script?__mode=cmtr_name_js'></script>";
    } else {
        return "<script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>";
    }
}
?>
