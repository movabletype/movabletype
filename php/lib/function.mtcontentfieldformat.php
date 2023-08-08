<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentfieldformat($args, &$ctx) {
    $content_type = $ctx->stash('content_type');
    if (!is_object($content_type))
        return $ctx->error($ctx->mt->translate("No Content Type could be found.") );

    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentFieldFormat" ));

    $field_data = $ctx->stash('content_field_data');
    if (!$field_data)
        return $ctx->error($ctx->mt->translate("No Content Field could be found."));


    $convert_breaks = $content->blob_convert_breaks;
    if (preg_match("/^SERG/", $convert_breaks)) {
        $convert_breaks = $ctx->mt->db()->unserialize($convert_breaks);
    }

    $format = $convert_breaks[$field_data['id']];
    return $format ? $format : '';
}
?>
