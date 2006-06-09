<?php
function smarty_function_MTAdminScript($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config['AdminScript'];
}
?>
