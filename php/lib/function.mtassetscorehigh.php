<?php
require_once('rating_lib.php');

function smarty_function_mtassetscorehigh($args, &$ctx) {
    return hdlr_score_high($ctx, 'asset', $args['namespace']);
}
?>

