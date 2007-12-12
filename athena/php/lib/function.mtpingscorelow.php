<?php
require_once('rating_lib.php');

function smarty_function_mtpingscorelow($args, &$ctx) {
    return hdlr_score_low($ctx, 'tbping', $args['namespace']);
}
?>

