<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorentriescount($args, &$ctx) {
    $mt = MT::get_instance();
    $author = $ctx->stash('author');

    $sql = "
        select count(*)
          from mt_entry
         where entry_class = ?
           and entry_author_id = ?
           and entry_status = ?";
    $conn = $mt->db()->db();
    $handle = $conn->prepare($sql);

    $entry_class = 'entry';
    $entry_author_id = $author->id;
    $entry_release = 2; # RELEASE
    $bindVars = array($entry_class, $entry_author_id, $entry_release);

    $row = $conn->getRow($handle, $bindVars);

    return $ctx->count_format($row[0], $args);
}
?>
