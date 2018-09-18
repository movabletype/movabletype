<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentauthorid($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content)) return '';

    $id = $content->cd_author_id;
    if (!$id) return '';
    return $id;
}
?>
