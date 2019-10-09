<?php

function smarty_modifier_smart_quotes($text, $attr = NULL, $cxt = NULL)
{
    require_once "smartypants.php";
    return SmartQuotes($text, $attr, $cxt);
}

?>
