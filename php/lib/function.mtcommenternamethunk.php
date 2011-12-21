<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcommenternamethunk($args, &$ctx) {
    return $ctx->error(
        $ctx->mt->translate("This '[_1]' tag has been deprecated. Please use '[_2]' instead.",
            array( 'MTCommenterNameThunk', 'MTUserSessionState' )
    ));
}
?>
