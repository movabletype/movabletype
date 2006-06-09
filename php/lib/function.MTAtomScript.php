<?php
function smarty_function_MTAtomScript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config['AtomScript'];
}
?>
