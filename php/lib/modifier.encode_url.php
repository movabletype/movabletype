<?php
function smarty_modifier_encode_url($text) {
    $text = urlencode($text);
    $text = preg_replace('/\+/', '%20', $text);
    return $text;
}
?>
