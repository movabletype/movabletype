<?php
function smarty_function_mtgetvar($args, &$ctx) {
    require_once("function.mtvar.php");
    return smarty_function_mtvar($args, $ctx);
}
?>
