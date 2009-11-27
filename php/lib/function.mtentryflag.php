<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentryflag($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $flag = 'entry_' . $args['flag'];
    if (isset($entry->$flag)) {
        $v = $entry->$flag;
    }
    if ($flag == 'allow_pings') {
       return isset($v) ? $v : 0; 
    } else {
       return isset($v) ? $v : 1;
    }
}
?>
