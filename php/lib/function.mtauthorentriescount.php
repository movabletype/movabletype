<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtauthorentriescount($args, &$ctx) {
    $mt = MT::get_instance();
    $author = $ctx->stash('author');

    $mtdb = $mt->db();
    $conn = $mtdb->db();

    $entry_class = 'entry';
    $entry_author_id = $author->id;
    $entry_release = 2; # RELEASE

    $sql = sprintf("
        select count(*)
          from mt_entry
          where entry_class = %s
          and entry_author_id = %s
          and entry_status = %s",
          $mtdb->ph('entry_class', $bindVars, $entry_class),
          $mtdb->ph('entry_author_id', $bindVars, $entry_author_id),
          $mtdb->ph('entry_status', $bindVars, $entry_release)
   );

    $handle = $conn->prepare($sql);

    $row = $conn->getRow($handle, $bindVars);

    // Where mysql driver would return ['count(*)' => 3, 0 => 3],
    // mssqlserver driver returns ['' => 3]
    $count = array_shift($row);

    return $ctx->count_format($count, $args);
}
?>
