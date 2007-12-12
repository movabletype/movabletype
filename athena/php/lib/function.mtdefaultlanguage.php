<?php
function smarty_function_mtdefaultlanguage($args, &$ctx) {
    return $ctx->mt->config('DefaultLanguage');
}
?>
