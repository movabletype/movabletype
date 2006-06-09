<?php
function smarty_function_MTBlogCCLicenseImage($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $cc = $blog['blog_cc_license'];
    if (empty($cc)) return '';
    if (preg_match('/(\S+) (\S+) (\S+)/', $cc, $matches))
        return $matches[3];  # the third element is the image
    return 'http://creativecommons.org/images/public/' .
        ($cc == 'pd' ? 'norights' : 'somerights');
}
?>
