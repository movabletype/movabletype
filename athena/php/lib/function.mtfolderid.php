<?php
require_once('function.mtcategoryid.php');
function smarty_function_mtfolderid($args, &$ctx) {
    return smarty_function_mtcategoryid($args, $ctx);
}
?>
