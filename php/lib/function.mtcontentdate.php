<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentdate($args, &$ctx) {
    $content = $ctx->stash('content');
    if (!isset($content)) return '';

    $ctx->localize(array('entry'));
    $ctx->stash('entry', $content);
    $content_date = $ctx->tag('EntryDate',$args);
    $ctx->restore(array('entry'));
    return $content_date;

}
?>
