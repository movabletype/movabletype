<?php
function smarty_function_MTDefaultLanguage($args, &$ctx) {
    return $ctx->mt->config['DefaultLanguage'];
}
?>
