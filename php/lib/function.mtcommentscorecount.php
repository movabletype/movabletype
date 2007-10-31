<?php
require_once('rating_lib.php');

function smarty_function_mtcommentscorecount($args, &$ctx) {
    return hdlr_score_count($ctx, 'comment', $args['namespace']);
}
?>

