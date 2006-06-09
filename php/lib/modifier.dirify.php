<?php
function smarty_modifier_dirify($text, $attr = '1') {
    require_once("MTUtil.php");
    return dirify($text, $attr);
}
?>
