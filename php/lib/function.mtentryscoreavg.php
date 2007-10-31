<?php
require_once('rating_lib.php');

function smarty_function_mtentryscoreavg($args, &$ctx) {
    return hdlr_score_avg($ctx, 'entry', $args['namespace']);
}
?>

