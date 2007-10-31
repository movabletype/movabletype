<?php
function smarty_function_mtcommenteremail($args, &$ctx) {
    $a =& $ctx->stash('commenter');
    if (!isset($a)) return '';
    $email = $a['session_email'];
    if (!preg_match('/@/', $email))
        return '';
    return $email;
}
?>
