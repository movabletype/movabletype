<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mttagname($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_array($tag)) {
        $tag_name = $tag['tag_name'];
    } else {
        $tag_name = $tag;
    }
    if ($args['quote'] && preg_match('/ /', $tag_name)) {
        $tag_name = '"' . $tag_name . '"';
    } elseif ($args['normalize']) {
        require_once("MTUtil.php");
        $tag_name = tag_normalize($tag_name);
    }
    return $tag_name;
}
?>
