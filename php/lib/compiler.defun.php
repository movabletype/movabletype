<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

/* create code for a function call */ 
class smarty_compiler_fun extends Smarty_Internal_CompileBase { 

    public $required_attributes = array('name');
    public $optional_attributes = array('_any');


    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null){
        // check and get attributes
        $attrs = $this->getAttributes($compiler, $args);
        $_func_name = _dequote($attrs['name']); 
        $_func = 'smarty_fun_'.$_func_name; 
        unset($attrs['name']); 
        $_params = var_export($attrs,true);

        return "$_func(\$_smarty_tpl, $_params);"; 
    }
} 

/* create code for a function declaration */ 
class smarty_compiler_defun extends Smarty_Internal_CompileBase { 

    public $required_attributes = array('name');
    public $optional_attributes = array('_any');

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null) { 
        $attrs = $this->getAttributes($compiler, $args);
        array_push($compiler->_tag_stack, array('defun', $attrs, $args)); 

        $func_name = _dequote($attrs['name']); 
        $func = 'smarty_fun_'.$func_name; 
        $str = '<?php ';
        $str .= "\nif (!function_exists('$func')) {";
        $str .= "\nfunction $func(\$_smarty_tpl, \$params) {";
        $str .= "\n\$_fun_tpl_vars = \$_smarty_tpl->smarty->tpl_vars; \$_smarty_tpl->assign(\$params);";
        $str .= "\n?>\n";
        return $str;
    } 
}

/* create code for closing a function definition and calling said function */ 
class smarty_compiler_defunclose extends Smarty_Internal_CompileBase { 

    public $optional_attributes = array('_any');

    public function compile($args, Smarty_Internal_TemplateCompilerBase $compiler, $parameter = null ) { 
        $attrs = $this->getAttributes($compiler, $args);
        list($name, $attrs, $open_tag_args) = array_pop($compiler->_tag_stack); 
        if ($name!='defun') $compiler->_syntax_error("unexpected {/defun}"); 
        $result = "<?php \n";
        $result .=  "\$_smarty_tpl->smarty->tpl_vars = \$_fun_tpl_vars; }} ";
        if ( !isset($attrs['fun']) || '0' !== _dequote($attrs['fun']) ){
            $compiler_fun = new smarty_compiler_fun();
            $result .= $compiler_fun->compile($open_tag_args, $compiler, array());
        }
        $result .= "?>\n";
        return $result;
    }
} 

/**
 * Remove starting and ending quotes from the string
 *
 * @param string $string
 * @return string
 */
function _dequote($string) {
    if ((substr($string, 0, 1) == "'" || substr($string, 0, 1) == '"') &&
        substr($string, -1) == substr($string, 0, 1))
        return substr($string, 1, -1);
    else
        return $string;
}

?>
