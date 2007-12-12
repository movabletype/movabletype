<?php
require_once('function.mtsubcatsrecurse.php');
function smarty_function_mtsubfolderrecurse($args, &$ctx) {
    $args['class'] = 'folder';
    return smarty_function_mtsubcatsrecurse($args, $ctx);
}
?>
