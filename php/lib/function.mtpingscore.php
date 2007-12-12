<?php
require_once('rating_lib.php');

function smarty_function_mtpingscore($args, &$ctx) {
    return hdlr_score($ctx, 'tbping', $args['namespace']);
}
?>
