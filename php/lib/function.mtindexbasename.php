<?php
function smarty_function_mtindexbasename($args, &$ctx) {
    $name = $ctx->mt->config('IndexBasename');
    if (!isset($args['extension'])) return $name;
    $blog = $ctx->stash('blog');
    $ext = $blog['blog_file_extension'];
    if ($ext) $ext = '.' . $ext;
    return $name . $ext;
}
?>
