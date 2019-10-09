<?php

function smarty_modifier_smart_quotes($text, $attr = NULL, $cxt = NULL)
{
    require_once "smartypants.php";
    $smart_quotes = SmartQuotes($text, $attr, $cxt);

    $result = str_replace(array(
        '&#92;',
        '&#34;',
        '&#39;',
        '&#46;',
        '&#45;',
        '&#96;'
    ), array(
        '\\',
        '\"',
        "\'",
        '\.',
        '\-',
        '\`'
    ), $smart_quotes);
    return $result;
}

?>
