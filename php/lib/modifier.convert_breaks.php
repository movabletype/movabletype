<?php
function smarty_modifier_convert_breaks($text) {
    require_once("MTUtil.php");
    return html_text_transform($text);
}
?>
