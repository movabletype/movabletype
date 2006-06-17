<?php
function smarty_function_MTProductName($args, &$ctx) {
    $short_name = strpos(PRODUCT_NAME, "Enterprise") ?
        "Movable Type Enterprise" : "Movable Type";
    if ($args['version']) {
        return $ctx->mt->translate("$short_name [_1]", array(VERSION_ID));
    } else {
        return $ctx->mt->translate($short_name);
    }
}
?>
