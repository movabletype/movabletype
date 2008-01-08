<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtassetdateadded($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';
    
    $args['ts'] = $asset['asset_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>

