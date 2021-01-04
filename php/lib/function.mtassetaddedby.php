<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtassetaddedby($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    require_once('class.mt_author.php');
    $author = new Author();
    $author->Load("author_id = " . $asset->created_by);
    if ($author->nickname != '')
        return $author->nickname;

    return $author->name;
}
?>
