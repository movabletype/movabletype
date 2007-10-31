<?php
require_once('rating_lib.php');

function smarty_function_mtpingrank($args, &$ctx) {
    return hdlr_rank($ctx, 'tbping', $args['namespace'], $args['max'],
        "AND (tbping_visible = 1)\n"
    );
}
?>

