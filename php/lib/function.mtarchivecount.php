<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtarchivecount($args, &$ctx) {
    $at = '';
    $archiver = null;
    if ($at = $ctx->stash('current_archive_type')) {
        require_once("archive_lib.php");
        $archiver = ArchiverFactory::get_archiver($at);
    }
    $count = 0;
    if ((!isset($archiver) && $ctx->stash('inside_mt_categories')) ||
        ($ctx->stash('inside_mt_categories') && !$archiver->is_date_based())) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        # $count is set
    } elseif ($entries = $ctx->stash('entries')) {
        $count = count($entries);
    } else {
        $eargs = array();
        $eargs['blog_id'] = $ctx->stash('blog_id');
        if ($at) {
            $ts = $ctx->stash('current_timestamp');
            $tse = $ctx->stash('current_timestamp_end');
            if (isset($archiver)) {
                if ($ts && $tse) {
                    # assign date range if we have both
                    # start and end date
                    $eargs['current_timestamp'] = $ts;
                    $eargs['current_timestamp_end'] = $tse;
                }
                $archiver->setup_args($ctx, $eargs);
            }
            $eargs['lastn'] = -1;
            $entries = $ctx->mt->db()->fetch_entries($eargs);
            $count = count($entries);
        }
    }
    return $ctx->count_format($count, $args);
}
?>
