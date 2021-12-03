<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('archive_lib.php');
function smarty_function_mtarchivelink($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $at = isset($args['type']) ? $args['type'] : null;
    $at or $at = isset($args['archive_type']) ? $args['archive_type'] : null;
    $at or $at = $ctx->stash('current_archive_type');
    $ts = $ctx->stash('current_timestamp');
    if ($at == 'Monthly') {
         $ts = substr($ts, 0, 6) . '01000000';
    } elseif ($at == 'Daily') {
         $ts = substr($ts, 0, 8) . '000000';
    } elseif ($at == 'Weekly') {
         require_once("MTUtil.php");
         list($ws, $we) = start_end_week($ts);
         $ts = $ws;
    } elseif ($at == 'Yearly') {
         $ts = substr($ts, 0, 4) . '0101000000';
    } elseif ($at == 'Individual' || $at == 'Page') {
        !empty($args['archive_type']) or $args['archive_type'] = $at;
        return $ctx->tag('EntryPermalink', $args);
    } elseif ($at == 'ContentType') {
        !empty($args['archive_type']) or $args['archive_type'] = $at;
        return $ctx->tag('ContentPermalink', $args);
    } elseif ($at == 'Category' || $at == 'ContentType-Category') {
        if ( $at == 'ContentType-Category' && !$ctx->stash('category_set') ) {
            return $ctx->error($ctx->mt->translate('No Category Set could be found.'));
        }
        return $ctx->tag('CategoryArchiveLink', $args);
    }
    $args['blog_id'] = $blog->blog_id;

    $ar = ArchiverFactory::get_archiver($at);
    $link_sql = $ar->get_archive_link_sql($ts, $at, $args);
    $link = $ctx->mt->db()->archive_link($ts, $at, $link_sql, $args);

    if (!empty($args['with_index']) && preg_match('/\/(#.*)*$/', $link)) {
        $blog = $ctx->stash('blog');
        $index = $ctx->mt->config('IndexBasename');
        $ext = $blog->blog_file_extension;
        if ($ext) $ext = '.' . $ext;
        $index .= $ext;
        $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
    }
    return $link;
}
?>
