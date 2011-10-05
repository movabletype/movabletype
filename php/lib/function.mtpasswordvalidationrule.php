<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpasswordvalidationrule($args, &$ctx) {
    $app =  $ctx->mt;

    $constrains = $app->config('UserPasswordValidation');
    $min_length = $app->config('UserPasswordMinLength');

    $msg = $app->translate("minimum length of [_1]", $min_length);
    if (strpos($constrains,  "upperlower") !== false) {
        $msg .= $app->translate(', upper and lower letters');
    }
    if (strpos($constrains, "letternumber") !== false) {
        $msg .= $app->translate(', letters and numbers');
    }
    if (strpos($constrains, "symbol") !== false) {
        $msg .= $app->translate(', special symbols (e.g. #!$%)');
    }
    return $msg;
}
    
?>
