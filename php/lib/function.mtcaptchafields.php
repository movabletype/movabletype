<?php
require_once('captcha_lib.php');
function smarty_function_mtcaptchafields($args, &$ctx) {
    // status: complete
    // parameters: none
    global $_captcha_providers;
    $blog = $ctx->stash('blog');
    $key = $blog['blog_captcha_provider'];
    if (!isset($key)) {
        return '';
    }
    $provider = $_captcha_providers[$key];
    if (isset($provider)) {
        $fields = $provider->form_fields($blog['blog_id']);
        $fields = preg_replace('/[\r\n]/', '', $fields);
        $fields = preg_replace("/[\\']/", '\\"', $fields);
        return $fields;
    } else {
        return '';
    }
}
?>

