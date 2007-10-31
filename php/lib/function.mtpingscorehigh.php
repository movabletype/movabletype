<?php
require_once('rating_lib.php');

function smarty_function_mtpingscorehigh($args, &$ctx) {
    return hdlr_score_high($ctx, 'tbping', $args['namespace']);
}
?>

