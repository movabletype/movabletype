<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

class smarty_compiler_mtphp extends Smarty_Internal_CompileBase {

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null) {
        if (!$compiler->smarty->mt->config('DynamicTemplateAllowPHP')) {
            $compiler->trigger_template_error('PHP is not allowed by DynamicTemplateAllowPHP configuration}', null, true);
        }
        return '<?php ';
    }
}

class smarty_compiler_mtphpclose extends Smarty_Internal_CompileBase {

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null) {
        return ';?>';
    }
}
