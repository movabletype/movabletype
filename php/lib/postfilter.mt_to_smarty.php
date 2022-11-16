<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_postfilter_mt_to_smarty($tpl_source, $ctx) {
    $new_tpl_source = preg_replace('/(\$_smarty_tpl->tpl_vars\[\'vars\'\])->value/', '$_smarty_tpl->smarty->tpl_vars[\'vars\']', $tpl_source);

    // Check the existance of variable before accessing '->value' so that undef warnings are prevented.
    // Note that the core usage of tpl_vars keys are only 'conditional' and 'elseif_conditional'.
    // The following is to save none-core plugins just in case.
    $new_tpl_source = preg_replace(
        '/(\$_smarty_tpl->tpl_vars\[\'[a-zA-Z0-9_]+\'\])->value/', 
        '(!empty($1) ? $1->value : "")', 
        $new_tpl_source);

    return $new_tpl_source;
}
