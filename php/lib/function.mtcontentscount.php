<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentscount($args, &$ctx)
{
    $contents = $ctx->stash('contents');
    $count = 0;
    if (isset($contents)) {
        $count = count($contents);
    } else {
        $where = "cd_blog_id  = " . $ctx->stash('blog_id');
        $where .= " AND cd_status  = 2";
        if ($args['content_type']) {
            $content_types = $ctx->mt->db()->fetch_content_types($args);
            if ($content_types) {
                foreach ($content_types as $content_type) {
                    $where .= " AND cd_content_type_id = " . $content_type->id;
                }
            } else {
                return $ctx->error($ctx->mt->translate("No Content Type could be found."));
            }
        }
        require_once('class.mt_content_data.php');
        $ct = new ContentData();
        $count = $ct->count(['where' => $where]);
    }
    return $ctx->count_format($count, $args);
}
