<?php
require_once('rating_lib.php');

function smarty_function_mtcommentrank($args, &$ctx) {
    return hdlr_rank($ctx, 'comment', $args['namespace'], $args['max'],
        "AND (comment_visible = 1)\n"
    );
}
?>

