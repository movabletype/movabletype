<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtgooglesearchresult($args, &$ctx) {
    $result = $ctx->stash('google_result_item');
    $prop = $args['property'];
    if ($prop == ''){
        $prop = 'title';
    }

    global $mt;
    $lang = $mt->config('DefaultLanguage');
    if ($lang == 'ja') {
        $charset = $mt->config('PublishCharset');
        $s = mb_convert_encoding($result[$prop], $charset, 'utf-8');
    }else{
        $s = $result[$prop];
    }

    return $s;
}
?>
