<?php
function smarty_modifier_zero_pad($text, $len) {
    return sprintf("%0".$len."s", $text);
}
?>
