<?php
function smarty_function_MTProductName($args, &$ctx) {
    $code = $ctx->mt->product_code;
    if ($code == 'MTE') {
        $short_name = "Movable Type Enterprise";
    } else {
        $short_name = "Movable Type";
    }
    if ($args['version']) {
        return $ctx->mt->translate("$short_name [_1]", $ctx->mt->version_id);
    } else {
        return $ctx->mt->translate($short_name);
    }
}
?>
