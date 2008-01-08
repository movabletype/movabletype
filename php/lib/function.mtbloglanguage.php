<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtbloglanguage($args, &$ctx) {
    $real_lang = array('cz' => 'cs', 'dk' => 'da', 'jp' => 'ja', 'si' => 'sl');
    $blog = $ctx->stash('blog');
    $lang_tag = $blog['blog_language'];
    if ($real_lang[$lang_tag]) {
        $lang_tag = $real_lang[$lang_tag];
    }
    if ($args['locale']) {
        $lang_tag = preg_replace('/^([A-Za-z][A-Za-z])([-_]([A-Za-z][A-Za-z]))?$/e', '\'$1\' . "_" . (\'$3\' ? strtoupper(\'$3\') : strtoupper(\'$1\'))', $lang_tag);
    } elseif ($args['ietf']) {
        # http://www.ietf.org/rfc/rfc3066.txt
        $lang_tag = preg_replace('/_/', '-', $lang_tag);
    }
    return $lang_tag;
}
?>
