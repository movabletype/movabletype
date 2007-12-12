<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtdefaultlanguage($args, &$ctx) {
    return $ctx->mt->config('DefaultLanguage');
}
?>
