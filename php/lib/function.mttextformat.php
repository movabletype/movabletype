<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mttextformat($args, &$ctx) {
    $field_data = $ctx->stash('content_field_data');
    if ($field_data) {
        if ($field_data['type'] !== 'multi_line_text') {
            return $ctx->error($ctx->mt->translate("You used an '[_1]' tag outside of the context of a 'Multi Line Text' field.", "mtTextFormat" ) );
        }

        $content = $ctx->stash('content');
        if (!isset($content))
            return $ctx->error($ctx->mt->translate(
                "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtTextFormat" ));

        $convert_breaks = $content->blob_convert_breaks;
        if (preg_match("/^SERG/", $convert_breaks)) {
            $convert_breaks = $ctx->mt->db()->unserialize($convert_breaks);
        }

        return $convert_breaks[$field_data['id']];
    }

    $entry = $ctx->stash('entry');
    if (!$entry) {
        return $ctx->error($ctx->mt->translate("You used an '[_1]' tag outside of the context of the correct content; ", "mtTextFormat" ));
    }

    $convert_breaks = $entry->convert_breaks;
    if (!isset($convert_breaks)) {
        $blog = $ctx->stash('blog');
        if (!empty($blog)) {
            $convert_breaks = $blog->convert_paras;
        }
    }
    if (!isset($convert_breaks) || $convert_breaks == 1) {
        $convert_breaks = '__default__';
    }
    return $convert_breaks;
}
?>
