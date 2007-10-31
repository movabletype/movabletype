<?php
function smarty_modifier_filters($text,$filters) {
    // status: complete
    $f = preg_split('/\s*,\s*/', $filters);
    global $mt;
    $ctx =& $mt->context();
    if (is_array($f) && count($f) > 0) {
        foreach ($f as $filter) {
            if ($filter == '__default__') {
                $filter = 'convert_breaks';
            }
            if ($ctx->load_modifier($filter)) {
                $mod = 'smarty_modifier_'.$filter;
                $text = $mod($text);
            }
        }
    }
    return $text;
}
?>
