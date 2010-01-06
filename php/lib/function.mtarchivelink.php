<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtarchivelink($args, &$ctx) {
    $blog = $ctx->stash('blog');
    $at = $args['type'];
    $at or $at = $args['archive_type'];
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
    } elseif ($at == 'Individual') {
        $args['archive_type'] or $args['archive_type'] = $at;
        return $ctx->tag('EntryPermalink', $args);
    } elseif ($at == 'Category') {
        return $ctx->tag('CategoryArchiveLink', $args);
    }
    $args['blog_id'] = $blog['blog_id'];
    global $_archivers;
    if(!isset($_archivers[$at])) {
        return '';
    }
    $link_sql = $_archivers[$at]->get_archive_link_sql($ctx, $ts, $at, $args);
    $link = $ctx->mt->db->archive_link($ts, $at, $link_sql, $args);
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
