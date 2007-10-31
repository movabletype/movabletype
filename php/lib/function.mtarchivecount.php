<?php
function smarty_function_mtarchivecount($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        return $count;
    } elseif ($entries = $ctx->stash('entries')) {
        return count($entries);
    } else {
        $eargs = array();
        $eargs['blog_id'] = $ctx->stash('blog_id');
        if ($at = $ctx->stash('current_archive_type')) {
            require_once("archive_lib.php");
            $ts = $ctx->stash('current_timestamp');
            $tse = $ctx->stash('current_timestamp_end');
            global $_archive_helpers;
            if (($ts && $tse) && isset($_archive_helpers[$at])) {
                # assign date range if we have both
                # start and end date
                $eargs['current_timestamp'] = $ts;
                $eargs['current_timestamp_end'] = $tse;
            }
            $entries =& $ctx->mt->db->fetch_entries($eargs);
            return count($entries);
        }
    }
    return 0;
}
?>