<?php
function smarty_function_mtarchivedateend($args, &$ctx) {
    // status: complete
    $end = $ctx->stash('current_timestamp_end');
    $args['ts'] = $end;
    return $ctx->_hdlr_date($args, $ctx);
}
?>
