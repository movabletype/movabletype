<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtfeedbackscore($args, &$ctx) {
    $fb =& $ctx->stash('comment');
    $score = '';
    if (isset($fb)) {
        $score = $fb->comment_junk_score;
        $score or $score = 0;
    } else {
        $fb =& $ctx->stash('ping');
        if (isset($fb)) {
            $score = $fb->tbping_junk_score;
            $score or $score = 0;
        }
    }
    return $score;
}
?>
