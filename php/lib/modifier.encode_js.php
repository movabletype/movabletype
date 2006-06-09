<?php
function smarty_modifier_encode_js($text) {
    require_once("MTUtil.php");
    return encode_js($text);
}
?>
