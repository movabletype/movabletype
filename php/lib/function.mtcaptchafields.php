<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('captcha_lib.php');
function smarty_function_mtcaptchafields($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $key = $blog->blog_captcha_provider;
    if (!isset($key)) {
        return '';
    }

    $provider = CaptchaFactory::get_provider($key);
    if (isset($provider)) {
        $fields = $provider->form_fields($blog->blog_id);
        $fields = preg_replace('/[\r\n]/', '', $fields);
        $fields = preg_replace("/[\\']/", '\\"', $fields);
        return $fields;
    } else {
        return '';
    }
}
?>

