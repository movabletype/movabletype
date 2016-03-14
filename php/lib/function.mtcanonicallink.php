<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
function smarty_function_mtcanonicallink($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    require_once('function.mtcanonicalurl.php');
    $url = smarty_function_mtcanonicalurl($args, $_smarty_tpl);
    if (empty($url)) {
        return '';
    }

    return '<link rel="canonical" href="' . encode_html($url) . '" />';
}
