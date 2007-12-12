<?php
function smarty_modifier_wrap_text($text, $words) {
    return wordwrap($text, $words - 1, "\n", true);
}
?>
