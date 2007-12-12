<?php
require_once('rating_lib.php');

function smarty_function_mtcommentscore($args, &$ctx) {
    return hdlr_score($ctx, 'comment', $args['namespace'], $args['default']);
}
?>
