<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

interface CaptchaProvider {
    public function get_name();
    public function get_classname();
    public function form_fields($blog_id);
}

class MTUtilCaptcha implements CaptchaProvider {
    public function get_name() {
        return 'Movable Type default';
    }

    public function get_classname() {
        return 'MTUtilCaptcha';
    }

    public function form_fields($blog_id) {
        $mt = MT::get_instance();
        $token = '';
        $token = sha1(rand(0, 65535));
        if (strlen($token) == 0) {
            return '';
        }
        $cgipath = $mt->config('CGIPath');
        $commentscript = $mt->config('CommentScript');
        $caption = $mt->translate('Captcha');
        $description = $mt->translate('Type the characters shown in the picture above.');
        $form = "
<div class=\"label\"><label for=\"captcha_code\">$caption:</label></div>
<div class=\"field\">
<input type=\"hidden\" name=\"token\" value=\"$token\" />
<img src=\"$cgipath$commentscript/captcha/$blog_id/$token\" width=\"150\" height=\"35\" loading=\"lazy\" decoding=\"async\" /><br />
<input type=\"text\" name=\"captcha_code\" id=\"captcha-code\" class=\"text\" value=\"\" autocomplete=\"off\" />
<p>$description</p>
</div>";
        return $form;
    }
}

class CaptchaFactory {
    private static $_captcha_providers = array(
        'mt_default' => 'MTUtilCaptcha',
    );
    private static $_providers = array();

    private function __construct() { }

    public static function get_provider($provider) {
        if ( empty($provider) || 'none' == strtolower($provider) )
            return null;
        if (!isset(CaptchaFactory::$_captcha_providers[$provider])) {
            require_once('class.exception.php');
            throw new MTException('Undefined captcha provider. (' . $provider . ')');
        }

        $class = CaptchaFactory::$_captcha_providers[$provider];
        $instance = new $class;
        if (!empty($instance) and $instance instanceof CaptchaProvider)
            CaptchaFactory::$_providers[$provider] = $instance;


        return CaptchaFactory::$_providers[$provider]; 
    }

    public static function add_provider($provider, $class) {
        if (empty($provider) or empty($class))
            return null;

        CaptchaFactory::$_captcha_providers[$provider] = $class;
        return true;
    }
}

?>
