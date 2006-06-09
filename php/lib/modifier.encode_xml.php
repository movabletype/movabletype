<?php
function smarty_modifier_encode_xml($text) {
    require_once("MTUtil.php");
    return encode_xml($text);
}
?>
