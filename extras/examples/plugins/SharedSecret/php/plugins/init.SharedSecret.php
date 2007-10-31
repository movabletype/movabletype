<?php
require_once("captcha_lib.php");

class SharedSecret extends BaseCaptchaProvider {
    function get_key() {
        return 'sixapart_ss';
    }
    function get_name() {
        return 'Shared Secret';
    }
    function get_classname() {
        return 'SharedSecret';
    }
    function form_fields() {
        global $mt;

        $caption = $mt->translate("DO YOU KNOW?  What is MT team's favorite brand of chocolate snack?");
        $fields = "
<p>$caption</p>
<input name=\"secret_answer\" size=\"50\" />
";
        return $fields;
    }
}

$provider = new SharedSecret();
$_captcha_providers[$provider->get_key()] = $provider;

?>
