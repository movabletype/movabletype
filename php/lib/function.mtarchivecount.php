<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
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
    if ( ( ( 'Category' == $at ) ) ||
         ( !isset($archiver) && $ctx->stash('inside_mt_categories') ) ||
         ( $ctx->stash('inside_mt_categories') && !$archiver->is_date_based() ) ) {
        return $ctx->tag('MTCategoryCount', $args);
    } elseif ($count = $ctx->stash('archive_count')) {
        # $count is set
        return $count;
    }
    $entries = array();
    $e = $ctx->stash('entries');
    if(!isset($e) && $ctx->stash('entry')) {
        $e = $ctx->stash('entry') ;
    }
    if(is_array($e)){
        $entries = $e;
    }
    else {
        $entries = array( $e );
    }
    return $ctx->count_format( count($entries), $args);
}
?>
