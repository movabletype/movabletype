<?php
function smarty_function_mtblogfileextension($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $ext = $blog['blog_file_extension'];
    if ($ext != '') $ext = '.' . $ext;
    return $ext;
}
?>
