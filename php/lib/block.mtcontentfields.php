<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontentfields($args, $res, &$ctx, &$repeat) {
    $localvars = array(array('content_field_data', '_content_fields_counter','_content_fields_counter_max', '_content_fields_unserialized', 'ContentFieldsHeader','ContentFieldsFooter'), common_loop_vars());

    if (!isset($res)) {
        $ctx->localize($localvars);

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $res, $ctx, $repeat);

        require_once('content_field_type_lib.php');

        $counter = 0;
        $ctx->stash('_content_fields_counter', $counter);

        $content_type = $ctx->stash('content_type');
        if (!is_object($content_type))
            return $ctx->error($ctx->mt->translate('No Content Type could be found.') );

        $content_fields = $content_type->fields;
        if (isset($content_fields)) {
            $content_fields = $ctx->mt->db()->unserialize($content_fields);
        }
        $ctx->stash('_content_fields_unserialized', $content_fields);

        $counter_max = is_array($content_fields) ? count($content_fields) : 0;
        $ctx->stash('_content_fields_counter_max', $counter_max);
    } else {
        $counter = $ctx->stash('_content_fields_counter');
        $counter_max = $ctx->stash('_content_fields_counter_max');
        $content_type = $ctx->stash('content_type');
        $content_fields = $ctx->stash('_content_fields_unserialized');
    }

    if ($counter < $counter_max) {
        $content_field = $content_fields[$counter];
        $count = $counter + 1;
        $ctx->stash('_content_fields_counter', $count);
        $ctx->stash('ContentFieldsHeader', $count == 1);
        $ctx->stash('ContentFieldsFooter', ($count == $counter_max));

        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == $counter_max);

        if (!empty($content_field)) {
            $ctx->stash('content_field_data', $content_field);

            $ctx->__stash['vars']['content_field_id'] = $content_field['id'];
            $ctx->__stash['vars']['content_field_unique_id'] = isset($content_field['unique_id']) ? $content_field['unique_id'] : null;
            $ctx->__stash['vars']['content_field_type'] = $content_field['type'];
            $ctx->__stash['vars']['content_field_order'] = $content_field['order'];
            $ctx->__stash['vars']['content_field_options'] = 
                isset($content_field['options']) ? $content_field['options'] : null;

            $content_field_type = ContentFieldTypeFactory::get_type($content_field['type']);
            $ctx->__stash['vars']['content_field_type_label'] = $content_field_type->get_label();
        }
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $res;
}
?>
