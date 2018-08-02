<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtsitecontentcount($args, &$ctx)
{
    require_once('multiblog.php');
    multiblog_function_wrapper('mtsitecontentcount', $args, $ctx);

    $args['blog_id'] = $ctx->stash('blog_id');
    if (isset($args['content_type'])) {
        $content_types = $ctx->mt->db()->fetch_content_types($args);
        if (!$content_types) {
            return $ctx->error($ctx->mt->translate("No Content Type could be found."));
        }
    }
    $count = $ctx->mt->db()->content_count($args);
    return $ctx->count_format($count, $args);
}
