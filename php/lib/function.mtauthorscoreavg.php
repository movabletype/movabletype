<?php
require_once('rating_lib.php');

function smarty_function_mtauthorscoreavg($args, &$ctx) {
    return hdlr_score_avg($ctx, 'author', $args['namespace']);
}
?>

