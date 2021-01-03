<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtpasswordvalidationrule($args, &$ctx) {
    $app =  $ctx->mt;

    $constrains = $app->config('UserPasswordValidation');
    $min_length = $app->config('UserPasswordMinLength');

    $msg = $app->translate("minimum length of [_1]", $min_length);
    if (isset($constrains)) {
        if (array_search("upperlower", $constrains) !== false) {
            $msg .= $app->translate(', uppercase and lowercase letters');
        }
        if (array_search("letternumber", $constrains) !== false) {
            $msg .= $app->translate(', letters and numbers');
        }
        if (array_search("symbol", $constrains) !== false) {
            $msg .= $app->translate(', symbols (such as #!$%)');
        }
    }
    return $msg;
}
    
?>
