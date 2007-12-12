<?php
require_once('rating_lib.php');

function smarty_function_mtcommentscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'comment', $args['namespace']);
}
?>

