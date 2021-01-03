<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_function_mtarchivetitle($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    if (isset($args['type'])) {
        $at = $args['type'];
    } elseif (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    if ($at == 'Category' || $at == 'ContentType-Category') {
         $title = $ctx->tag('CategoryLabel', $args);
         if ( !empty( $title )) {
             $title = encode_html( strip_tags( $title ));
         } else {
             $title = '';
         }
         return $title;
    } else {
        $ar = ArchiverFactory::get_archiver($at);
        return $ar->get_title($args, $ctx);
    }
}
?>
