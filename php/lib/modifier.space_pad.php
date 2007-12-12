<?php
function smarty_modifier_space_pad($text, $len) {
    return sprintf("%".$len."s", $text);
}
?>
