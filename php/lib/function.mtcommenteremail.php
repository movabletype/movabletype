<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtcommenteremail.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtcommenteremail($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    if (!isset($a)) return '';
    $email = $a->email;
    if (!preg_match('/@/', $email))
        return '';
    return $email;
}
?>
