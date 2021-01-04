<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_function_mtarchivelabel($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    if (isset($args['type'])) {
        $at = $args['type'];
    } elseif (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    $ar = ArchiverFactory::get_archiver($at);
    if (isset($ar)) {
        return $ar->get_label($args);
    } else {
        $mt = MT::get_instance();
        return $mt->translate($at);
    }
}
?>
