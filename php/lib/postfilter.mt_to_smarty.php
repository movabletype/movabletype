<?php

function smarty_postfilter_mt_to_smarty($tpl_source, $ctx) {
    $new_tpl_source = preg_replace('/(\$_smarty_tpl->tpl_vars\[\'vars\'\])->value/', '$_smarty_tpl->smarty->tpl_vars[\'vars\']', $tpl_source);
    return $new_tpl_source;
}
