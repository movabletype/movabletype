<?php
require_once('rating_lib.php');

function smarty_function_mtassetscore($args, &$ctx) {
    return hdlr_score($ctx, 'asset', $args['namespace']);
}
?>
