<?php
function smarty_function_mtproductname($args, &$ctx) {
    $short_name = PRODUCT_NAME;
    if ($args['version']) {
        return $ctx->mt->translate("[_1] [_2]", $short_name, array(VERSION_ID));
    } else {
        return $short_name;
    }
}
?>

