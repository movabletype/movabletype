<?php
require_once('function.mtblogentrycount.php');
function smarty_function_mtblogpagecount($args, &$ctx) {
    // status: complete
    // parameters: none
    $args['class'] = 'page';
    return smarty_function_mtblogentrycount($args, $ctx);
}
?>
