<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
    if ( $ctx->stash('inside_mt_categories') &&
         !( isset($archiver) && $archiver->is_date_based() ) ) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        # $count is set
        return $count;
    }
    $contents = array();
    if ((isset($at) && preg_match('/^ContentType/', $at)) || $ctx->stash('content_type')) {
        $c = $ctx->stash('contents');
        if(!isset($c) && $ctx->stash('content')) {
            $c = $ctx->stash('content') ;
        }
    } else {
        $c = $ctx->stash('entries');
        if(!isset($c) && $ctx->stash('entry')) {
            $c = $ctx->stash('entry') ;
        }
    }
    if(is_array($c)){
        $contents = $c;
    }
    elseif ($c) {
        $contents = array( $c );
    }
    return $ctx->count_format( count($contents), $args);
}
?>
