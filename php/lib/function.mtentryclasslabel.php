<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtentryclasslabel($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $class = $entry->entry_class;
    if (!isset($class)) {
        return '';
    }
    return $ctx->mt->translate($class);
    // translate('page'), translate('entry')
    // translate('Page'), translate('Entry')
} 
?>
