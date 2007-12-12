<?php
require_once('rating_lib.php');

function smarty_function_mtentryscore($args, &$ctx) {
    return hdlr_score($ctx, 'entry', $args['namespace']);
}
?>
