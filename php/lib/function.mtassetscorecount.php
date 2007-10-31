<?php
require_once('rating_lib.php');

function smarty_function_mtassetscorecount($args, &$ctx) {
    return hdlr_score_count($ctx, 'asset', $args['namespace']);
}
?>

