<?php
function smarty_function_MTSignOnURL($args, &$ctx) {
    // status: complete
    // parameters: none
    return $ctx->mt->config['SignOnURL'];
}
?>
