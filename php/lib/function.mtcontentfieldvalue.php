<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentfieldvalue($args, &$ctx) {
    $content_type = $ctx->stash('content_type');
    if (!is_object($content_type))
        return $ctx->error($ctx->mt->translate("No Content Type could be found.") );

    $content = $ctx->stash('content');
    if (!isset($content))
        return $ctx->error($ctx->mt->translate(
            "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentFieldValue" ));

    $field_data = $ctx->stash('content_field_data');
    if (!$field_data)
        return $ctx->error($ctx->mt->translate("No Content Field could be found."));

    $field_type = $ctx->stash('content_field_type');
    if (!$field_type) {
        require_once('content_field_type_lib.php');
        $field_type = ContentFieldTypeFactory::get_type($field_data['type']);
        if (!$field_type) {
            return $ctx->error($ctx->mt->translate("No Content Field Type could be found."));
        }
    }

    $value = isset($ctx->__stash['vars']['__value__']) ? $ctx->__stash['vars']['__value__'] : null;
    return $field_type->get_field_value($value, $ctx, $args);
}
?>
