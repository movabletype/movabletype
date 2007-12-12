<?php
require_once('rating_lib.php');

function smarty_function_mtauthorscore($args, &$ctx) {
    return hdlr_score($ctx, 'author', $args['namespace'], $args['default']);
}
?>
