<?php
global $_captcha_providers;
$provider = new MTUtilCaptcha();
$_captcha_providers[$provider->get_key()] = $provider;

class BaseCaptchaProvider {
    // Abstract Method (needs override)
    function get_key() { }
    function get_name() { }
    function get_classname() { }
    function form_fields($blog_id) { }
}

class MTUtilCaptcha extends BaseCaptchaProvider {
    function get_key() {
        return 'mt_default';
    }
    function get_name() {
        return 'Movable Type default';
    }
    function get_classname() {
        return 'MTUtilCaptcha';
    }
    function form_fields($blog_id) {
        global $mt;
        $token = '';
        if (floatval(PHP_VERSION) >= 4.3) {
            $token = @sha1(rand(0, 65535));
        } else {
            if (extension_loaded('mtoken')) {
                $token = bin2hex(mtoken(Mtoken_SHA1, $token_src));
            }
        }
        if (strlen($token) == 0) {
            return '';
        }
        $cgipath = $mt->config('CGIPath');
        $commentscript = $mt->config('CommentScript');
        $caption = $mt->translate('Captcha');
        $description = $mt->translate('Type the characters you see in the picture above.');
        $form = "
<div class=\"label\"><label for=\"captcha_code\">$caption:</label></div>
<div class=\"field\">
<input type=\"hidden\" name=\"token\" value=\"$token\" />
<img src=\"$cgipath$commentscript/captcha/$blog_id/$token\" width=\"150\" height=\"35\" /><br />
<input name=\"captcha_code\" id=\"captcha-code\" value=\"\" autocomplete=\"off\" />
<p>$description</p>
</div>";
        return $form;
    }
}
?>
