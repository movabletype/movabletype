<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentrycategory($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (empty($entry))
        return '';

    $cat = $entry->category();
    if ($cat) {
        return $cat->category_label;
    }

    return '';
}
?>
