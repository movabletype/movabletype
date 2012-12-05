<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
require_once('block.mtblogs.php');
function smarty_block_mtwebsites($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'website';
    if (isset($args['site_ids'])) {
        $args['blog_ids'] = $args['site_ids'];
        unset($args['site_ids']);
    }
    return smarty_block_mtblogs($args, $content, $ctx, $repeat);
}
?>
