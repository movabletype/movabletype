<?php
require_once('rating_lib.php');

function smarty_function_mtauthorscorecount($args, &$ctx) {
    return hdlr_score_count($ctx, 'author', $args['namespace']);
}
?>

