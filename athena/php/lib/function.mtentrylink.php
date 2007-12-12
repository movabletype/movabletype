<?php
function smarty_function_mtentrylink($args, &$ctx) {
    $args['no_anchor'] = 1;
    $link = $ctx->tag('EntryPermalink', $args);
    if ($args['with_index'] && preg_match('/\/(#.*)$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config('IndexBasename');
        $ext = $blog['blog_file_extension'];
        if ($ext) $ext = '.' . $ext; 
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
