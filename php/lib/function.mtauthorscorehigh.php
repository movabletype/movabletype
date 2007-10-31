<?php
require_once('rating_lib.php');

function smarty_function_mtauthorscorehigh($args, &$ctx) {
    return hdlr_score_high($ctx, 'author', $args['namespace']);
}
?>

