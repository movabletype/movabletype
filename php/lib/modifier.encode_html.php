<?php
function smarty_modifier_encode_html($text) {
    if (version_compare(phpversion(), '4.3.0', '>=')) {
        global $mt;
        $charset = $mt->config['PublishCharset'];
        return htmlentities($text, ENT_COMPAT, $charset);
    } else {
        return htmlentities($text, ENT_COMPAT);
    }
}
?>
