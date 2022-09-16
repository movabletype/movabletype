<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

class smarty_compiler_push_ctx_stack extends Smarty_Internal_CompileBase {

    public $optional_attributes = array('_any');

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null){
        // check and get attributes
        $attrs = $this->getAttributes($compiler, $args);
        $mttag = $attrs['mttag'];
        unset($attrs['mttag']); 
        $_params = var_export($attrs,true);

        return "<?php \$_smarty_tpl->smarty->_cache['_tag_stack'][] = array($mttag, $_params);?>";
    }
}

class smarty_compiler_pop_ctx_stack extends Smarty_Internal_CompileBase {

    public $optional_attributes = array('_any');

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null) {
        $attrs = $this->getAttributes($compiler, $args);
        return '<?php array_pop($_smarty_tpl->smarty->_cache[\'_tag_stack\']);?>';
    }
}
