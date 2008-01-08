<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtbuildtemplateid($args, &$ctx) {
    return $ctx->stash('build_template_id');
}
?>
