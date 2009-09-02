<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mttagname.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mttagname($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        $tag_name = $tag->tag_name;
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
