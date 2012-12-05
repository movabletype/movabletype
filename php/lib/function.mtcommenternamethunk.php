<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommenternamethunk($args, &$ctx) {
    return $ctx->error(
        $ctx->mt->translate("The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.",
            array( 'MTCommenterNameThunk', 'MTUserSessionState' )
    ));
}
?>
