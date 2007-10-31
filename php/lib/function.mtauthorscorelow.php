<?php
require_once('rating_lib.php');

function smarty_function_mtauthorscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'author', $args['namespace']);
}
?>

