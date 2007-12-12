<?php
function smarty_modifier_words($text, $words) {
    require_once("MTUtil.php");
    return first_n_text($text, $words);
}
?>
