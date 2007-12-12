<?php
function smarty_modifier_decode_html($text) {
    require_once("MTUtil.php");
    return decode_html($text);
}
?>
