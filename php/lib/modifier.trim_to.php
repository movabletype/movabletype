<?php
function smarty_modifier_trim_to($text, $len) {
    $len = intval($len);
    require_once("MTUtil.php");
    if ($len < length_text($text)) {
        $text = substr_text($text, 0, $len);
    }
    return $text;
}
?>
