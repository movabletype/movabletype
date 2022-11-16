<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategorybasename($args, &$ctx) {
    require_once("MTUtil.php");

    $cat = get_category_context($ctx, 'category', true);
    if( !$cat ) {
        if( isset($args['default']) )
            return $args['default'];

        if($ctx->stash('entry')){
            return '';
        } else {
            $tag = $ctx->this_tag();
            return $ctx->error("$tag must be used in a category context");
        }

    }

    $basename = $cat->category_basename;
    if ($sep = isset($args['separator']) ? $args['separator'] : null) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
