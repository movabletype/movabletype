<?php
function smarty_block_MTSetVarBlock($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (isset($content)) {
        $name = $args['name'];
        $value = $content;
        $vars =& $ctx->__stash['vars'];
        if (is_array($vars)) {
            $vars[$name] = $value;
        } else {
            $vars = array($name => $value);
            $ctx->__stash['vars'] =& $vars;
        }
    }
    return '';
}
?>
