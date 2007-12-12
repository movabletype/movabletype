<?php
function smarty_function_mtarchivefile($args, &$ctx) {
    $at = $ctx->stash('archive_type');
    $at or $at = $ctx->stash('current_archive_type');
    if (!$at or $at == 'Individual') {
        $e = $ctx->stash('entry');
        if (!$e) {
            $entries = $ctx->stash('entries');
            $e = $entries[0];
        }
        if (!$e) return $ctx->error("Could not determine entry");
        $f = $e['entry_basename'];
    } else {
        $f = $ctx->mt->config('IndexBasename');
    }
    if (isset($args['extension']) && !$args['extension']) {
    } else {
        $blog = $ctx->stash('blog');
        if ($ext = $blog['blog_file_extension']) {
            $f .= '.' . $ext;
        }
    }
    if ($args['separator']) {
        if ($args['separator'] == '-')
            $f = preg_replace('/_/', '-', $f);
    }
    return $f;
}
?>
