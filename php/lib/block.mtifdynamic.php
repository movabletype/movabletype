<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtifdynamic($args, $content, &$ctx, &$repeat) {
    return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 1);
}
?>
