<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: compiler.defun.php 106007 2009-07-01 11:33:43Z ytakayama $

/* create code for a function call */ 
function smarty_compiler_fun($tag_args, &$compiler) { 
    $_attrs = $compiler->_parse_attrs($tag_args); 

    if (!isset($_attrs['name'])) $compiler->_syntax_error("fun: missing name parameter"); 
    $_func_name = $compiler->_dequote($_attrs['name']); 
    $_func = 'smarty_fun_'.$_func_name; 
    $_params = 'array('; 
    $_sep = ''; 
    unset($_attrs['name']); 
    foreach ($_attrs as $_key=>$_value) { 
        $_params .= "$_sep'$_key'=>$_value"; 
        $_sep = ','; 
    } 
    $_params .= ')'; 
    return "$_func(\$this, $_params);"; 
} 

$this->register_compiler_function('fun', 'smarty_compiler_fun'); 


/* create code for a function declaration */ 
function smarty_compiler_defun($tag_args, &$compiler) { 
    $attrs = $compiler->_parse_attrs($tag_args); 
    $func_key = '"' . md5('php-5') . '[[' . md5(uniqid('sucks')) . '";'; 
    array_push($compiler->_tag_stack, array('defun', $attrs, $tag_args, $func_key)); 
    if (!isset($attrs['name'])) $compiler->_syntax_error("defun: missing name parameter"); 

    $func_name = $compiler->_dequote($attrs['name']); 
    $func = 'smarty_fun_'.$func_name; 
    return $func_key . "if (!function_exists('$func')) { function $func(&\$this, \$params) { \$_fun_tpl_vars = \$this->_tpl_vars; \$this->assign(\$params);"; 
} 

/* create code for closing a function definition and calling said function */ 
function smarty_compiler_defun_close($tag_args, &$compiler) { 
    list($name, $attrs, $open_tag_args, $func_key) = array_pop($compiler->_tag_stack); 
    if ($name!='defun') $compiler->_syntax_error("unexpected {/defun}"); 
    return " \$this->_tpl_vars = \$_fun_tpl_vars; }} " . $func_key . smarty_compiler_fun($open_tag_args, $compiler); 
} 

$this->register_compiler_function('/defun', 'smarty_compiler_defun_close'); 


/* callback: replace all $this with $smarty */ 
function smarty_replace_fun($match) { 
    $tokens = token_get_all('<?php ' . $match[2]); 
    for ($i=0, $count=count($tokens); $i<$count; $i++) { 
        if (is_array($tokens[$i])) { 
            if ($tokens[$i][0] == T_VARIABLE && $tokens[$i][1] == '$this') { 
                $tokens[$i] = '$smarty'; 
            } else {
                $tokens[$i] = $tokens[$i][1]; 
            } 
        } 
    } 
    $result = implode('', $tokens); 
    $result = preg_replace('/^<\?php/', '', $result);
    return $result;
} 


/* postfilter to squeeze the code to make php5 happy */ 
function smarty_postfilter_defun($source, &$compiler) { 
    $search = '("' . md5('php-5') . '\[\[[0-9a-f]{32}";)'; 
    if ((double)phpversion()>=5.0) { 
        /* filter sourcecode. look for func_keys and replace all $this 
           in-between with $smarty */ 
        while (1) { 
            $new_source = preg_replace_callback('/' . $search . '(.*)\\1/Us', 'smarty_replace_fun', $source); 
            if (strcmp($new_source, $source)==0) break; 
            $source = $new_source; 
        } 
    } else { 
        /* remove func_keys */ 
        $source = preg_replace('/' . $search . '/', '', $source); 
    } 
    return $source; 
} 

$this->register_postfilter('smarty_postfilter_defun');
?>
