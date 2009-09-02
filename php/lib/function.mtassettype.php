<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtassettype.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtassettype($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $mt = MT::get_instance();
    return $mt->translate($asset->asset_class);
}
/*
 * translate('image')
 * translate('Image')
 * translate('file')
 * translate('File')
 * translate('audio')
 * translate('Audio')
 * translate('video')
 * translate('Video')
 */
