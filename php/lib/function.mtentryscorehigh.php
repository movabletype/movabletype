<?php
require_once('rating_lib.php');

function smarty_function_mtentryscorehigh($args, &$ctx) {
    return hdlr_score_high($ctx, 'entry', $args['namespace']);
}
?>

