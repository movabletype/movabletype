<?php
require_once('rating_lib.php');

function smarty_function_mtcommentscorehigh($args, &$ctx) {
    return hdlr_score_high($ctx, 'comment', $args['namespace']);
}
?>

