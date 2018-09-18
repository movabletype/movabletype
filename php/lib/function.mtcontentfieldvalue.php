<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtcontentfieldvalue($args, &$ctx) {
    $content_type = $ctx->stash('content_type');
    if (!is_object($content_type)) return '';

    $content = $ctx->stash('content');
    if (!isset($content)) return '';

    $field_data = $ctx->stash('content_field_data');
    if (!$field_data) return '';

    $field_type = $ctx->stash('content_field_type');
    if (!$field_type) {
        require_once('content_field_type_lib.php');
        $field_type = ContentFieldTypeFactory::get_type($field_data['type']);
        if (!$field_type) return '';
    }

    $value = $ctx->__stash['vars']['__value__'];
    return $field_type->get_field_value($value, $ctx, $args);
}
?>
