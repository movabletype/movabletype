<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtsignonurl($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('SignOnURL');
}
?>
