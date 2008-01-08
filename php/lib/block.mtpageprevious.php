<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('block.mtentryprevious.php');
function smarty_block_mtpageprevious($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'page';
    return smarty_block_mtentryprevious($args, $content, $ctx, $repeat);
}
?>
