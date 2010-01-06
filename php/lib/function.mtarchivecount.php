<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtarchivecount($args, &$ctx) {
    $at = '';
    $archiver = null;
    if ($at = $ctx->stash('current_archive_type')) {
        require_once("archive_lib.php");
        global $_archivers;
        $archiver = $_archivers[$at];
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
            $entries =& $ctx->mt->db->fetch_entries($eargs);
            $count = count($entries);
        }
    }
    return $ctx->count_format($count, $args);
}
