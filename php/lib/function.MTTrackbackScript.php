<?php
function smarty_function_MTTrackbackScript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config['TrackbackScript'];
}
?>
