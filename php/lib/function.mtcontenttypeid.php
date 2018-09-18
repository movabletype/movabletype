<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontenttypeid($args, &$ctx) {
    $content_type = $ctx->stash('content_type');
    if (!isset($content_type)) return '';
    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $content_type->id) : $content_type->id;
}
?>
