<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttagname($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        $tag_name = $tag->tag_name;
    } else {
        $tag_name = $tag;
    }
    if (!empty($args['quote']) && preg_match('/ /', $tag_name)) {
        $tag_name = '"' . $tag_name . '"';
    } elseif (!empty($args['normalize'])) {
        require_once("MTUtil.php");
        $tag_name = tag_normalize($tag_name);
    }
    return $tag_name;
}
?>
