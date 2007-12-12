<?php
require_once('rating_lib.php');

function smarty_function_mtauthorrank($args, &$ctx) {
    return hdlr_rank($ctx, 'author', $args['namespace'], $args['max'],
        ""
    );
}
?>

