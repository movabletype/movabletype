<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtassetaddedby.php 106007 2009-07-01 11:33:43Z ytakayama $

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

