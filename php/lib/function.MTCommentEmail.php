<?php
function smarty_function_MTCommentEmail($args, &$ctx) {
    $comment = $ctx->stash('comment');
    $email = $comment['comment_email'];
    $email = strip_tags($email);
    if (!preg_match('/@/', $email))
        return '';
    return((isset($args['spam_protect']) && $args['spam_protect']) ? spam_protect($email) : $email);
}
?>
