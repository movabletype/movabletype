<?php
require_once('rating_lib.php');

function smarty_function_mtentryscorecount($args, &$ctx) {
    return hdlr_score_count($ctx, 'entry', $args['namespace']);
}
?>

