<?php
require_once("captcha_lib.php");

class reCaptcha extends BaseCaptchaProvider {
    function get_key() {
        return 'sixapart_rc';
    }
    function get_name() {
        return 'reCaptcha';
    }
    function get_classname() {
        return 'reCaptcha';
    }
    function form_fields() {
        global $mt;
        $config = $mt->db->fetch_plugin_config('reCaptcha');
        if ($config) {
            $publickey = $config['recaptcha_publickey'];
        }

        $fields = "
<script type=\"text/javascript\"
   src=\"http://api.recaptcha.net/challenge?k=$publickey\">
</script>

<noscript>
   <iframe src=\"http://api.recaptcha.net/noscript?k=$publickey\"
       height=\"300\" width=\"500\" frameborder=\"0\"></iframe><br>
   <textarea name=\"recaptcha_challenge_field\" rows=\"3\" cols=\"40\">
   </textarea>
   <input type=\"hidden\" name=\"recaptcha_response_field\" 
       value=\"manual_challenge\">
</noscript>
";
        return $fields;
    }
}

$provider = new reCaptcha();
$_captcha_providers[$provider->get_key()] = $provider;

?>
