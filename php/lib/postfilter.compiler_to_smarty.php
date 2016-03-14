<?php

function smarty_postfilter_compiler_to_smarty($source, $ctx) { 
    // $new_source = preg_replace('/\$_smarty_tpl([^-])/', '$_smarty_tpl->smarty$1', $source);
    $new_source = preg_replace('/\$_smarty_tpl->tpl_vars/', '$_smarty_tpl->smarty->tpl_vars', $source);
    
    return $new_source;
    // return $source;
}