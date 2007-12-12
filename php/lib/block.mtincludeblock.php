<?php
function smarty_block_mtincludeblock($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
    } else {
        require_once("function.mtinclude.php");
        $vars =& $ctx->__stash['vars'];
        if (!$vars) {
            $vars = array();
            $ctx->__stash['vars'] =& $vars;
        }
        $name = $args['var'];
        $name or $name = 'contents';
        $oldval = $vars[$name];
        $vars[$name] = $content;
        $content = smarty_function_mtinclude($args, $ctx);
        $vars[$name] = $oldval;
    }
    return $content;
}
?>
