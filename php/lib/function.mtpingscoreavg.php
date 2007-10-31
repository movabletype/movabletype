<?php
require_once('rating_lib.php');

function smarty_function_mtpingscoreavg($args, &$ctx) {
    return hdlr_score_avg($ctx, 'tbping', $args['namespace']);
}
?>

