<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtproductname($args, &$ctx) {
    $short_name = PRODUCT_NAME;
    if (!empty($args['version']) && empty($ctx->mt->config('HideVersion'))) {
        return implode(" ", array($short_name, VERSION_ID));
    } else {
        return $short_name;
    }
}
?>
