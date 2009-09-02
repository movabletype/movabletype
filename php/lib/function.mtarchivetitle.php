<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtarchivetitle.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("archive_lib.php");
function smarty_function_mtarchivetitle($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    if (isset($args['type'])) {
        $at = $args['type'];
    } elseif (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    if ($at == 'Category') {
        return $ctx->tag('CategoryLabel', $args);
    } else {
        $ar = ArchiverFactory::get_archiver($at);
        return $ar->get_title($args, $ctx);
    }
}
?>
