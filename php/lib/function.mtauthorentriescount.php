<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorentriescount($args, &$ctx) {
    $mt = MT::get_instance();
    $author = $ctx->stash('author');

    $conn = $mt->db()->db();
    $sql = sprintf("
        select count(*)
          from mt_entry
          where entry_class = %s
          and entry_author_id = %s
          and entry_status = %s",
       $conn->param('entry_class'), $conn->param('entry_author_id'), $conn->param('entry_status')
   );

    $entry_class = 'entry';
    $entry_author_id = $author->id;
    $entry_release = 2; # RELEASE
    $bindVars = array('entry_class' => $entry_class, 'entry_author_id' => $entry_author_id, 'entry_status' => $entry_release);
    $handle = $conn->prepare($sql);

    $row = $conn->getRow($handle, $bindVars);

    // Where mysql driver would return ['count(*)' => 3, 0 => 3],
    // mssqlserver driver returns ['' => 3]
    $count = array_shift($row);

    return $ctx->count_format($count, $args);
}
?>
