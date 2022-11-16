<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcategorysetname($args, &$ctx) {
    $category_set = $ctx->stash('category_set');
    if (!$category_set) {
        return $ctx->error("No Category Set could be found.");
    }
    return $category_set->name;
}

