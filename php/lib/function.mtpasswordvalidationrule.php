<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtpasswordvalidationrule($args, &$ctx) {
    $app =  $ctx->mt;

    $constrains = $app->config('UserPasswordValidation');
    $min_length = $app->config('UserPasswordMinLength');

    $msg = $app->translate("minimum length of [_1]", $min_length);
    if (array_search("upperlower", $constrains) !== false) {
        $msg .= $app->translate(', uppercase and lowercase letters');
    }
    if (array_search("letternumber", $constrains) !== false) {
        $msg .= $app->translate(', letters and numbers');
    }
    if (array_search("symbol", $constrains) !== false) {
        $msg .= $app->translate(', symbols (such as #!$%)');
    }
    return $msg;
}
    
?>
