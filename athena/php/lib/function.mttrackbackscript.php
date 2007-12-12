<?php
function smarty_function_mttrackbackscript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config('TrackbackScript');
}
?>
