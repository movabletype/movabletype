<?php
function smarty_function_mtentrymodifieddate($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $args['ts'] = $entry['entry_modified_on'];
    $args['ts'] or $args['ts'] = $entry['entry_created_on'];
    return $ctx->_hdlr_date($args, $ctx);
}
?>
