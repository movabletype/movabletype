<?php
require_once('function.mtcategorycount.php');
function smarty_function_mtfoldercount($args, &$ctx) {
    return smarty_function_mtcategorycount($args, $ctx);
}
?>
