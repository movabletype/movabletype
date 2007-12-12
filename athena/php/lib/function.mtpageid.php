<?php
require_once('function.mtentryid.php');
function smarty_function_mtpageid($args, &$ctx) {
    return smarty_function_mtentryid($args, $ctx);
}
?>
