<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategorylabel($args, &$ctx) {
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

    return $cat->category_label;
}
?>
