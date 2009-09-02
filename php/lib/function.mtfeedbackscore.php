<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtfeedbackscore.php 106007 2009-07-01 11:33:43Z ytakayama $

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
