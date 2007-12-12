<?php
require_once('rating_lib.php');

function smarty_function_mtassetscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'asset', $args['namespace']);
}
?>

