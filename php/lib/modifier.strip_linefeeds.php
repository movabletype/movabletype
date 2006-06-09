<?php
function smarty_modifier_strip_linefeeds($text) {
    return preg_replace('/[\r\n]/', '', $text);
}
?>
