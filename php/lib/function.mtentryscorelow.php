<?php
require_once('rating_lib.php');

function smarty_function_mtentryscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'entry', $args['namespace']);
}
?>

