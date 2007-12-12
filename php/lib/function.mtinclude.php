<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $restricted_include_filenames;
$restricted_include_filenames = array('mt-config.cgi' => 1, 'passwd' => 1);

function smarty_function_mtinclude($args, &$ctx) {
    // status: partial
    // parameters: module, file
    // notes: file case needs work -- search through blog site archive path, etc...

    // push to ctx->vars
    $ext_args = array();
    while(list ($key, $val) = each($args)) {
        if (!preg_match('/(^file$|^module$|^widget$|^blog_id$|^identifier$|^type$)/', $key)) {
            require_once("function.mtsetvar.php");
            smarty_function_mtsetvar(array('name' => $key, 'value' => $val), $ctx);
            $ext_args[] = $key;
        }
    }

    static $_include_cache = array();
    $blog_id = $args['blog_id'];
    $blog_id or $blog_id = $ctx->stash('blog_id');
    $cache_id = '';
    if (isset($args['module']) && ($args['module'])) {
        $module = $args['module'];
        if (preg_match('/^Widget:/', $module)) {
            $args['widget'] = preg_replace('/^Widget: ?/', '', $module);
            unset($args['module']);
        }
    }
    if (isset($args['module']) && ($args['module'])) {
        $module = $args['module'];
        $cache_id = 'module::' . $blog_id . '::' . $module;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = $ctx->mt->db->get_template_text($ctx, $module, $blog_id, 'custom', $args['global']);
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache[$cache_id] = $_var_compiled;
            } else {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template module '$module'");
            }
        }
    } elseif (isset($args['widget']) && ($args['widget'])) {
        $module = $args['widget'];
        $cache_id = 'widget::' . $blog_id . '::' . $module;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = $ctx->mt->db->get_template_text($ctx, $module, $blog_id, 'widget', $args['global']);
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache[$cache_id] = $_var_compiled;
            } else {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template module '$module'");
            }
        }
    } elseif (isset($args['identifier']) && ($args['identifier'])) {
        $module = $args['identifier'];
        $cache_id = 'identifier::' . $blog_id . '::' . $module;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = $ctx->mt->db->get_template_text($ctx, $module, $blog_id, '', $args['global']);
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache[$cache_id] = $_var_compiled;
            } else {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template module '$module'");
            }
        }
    } elseif (isset($args['file']) && ($args['file'])) {
        $file = $args['file'];
        $base_filename = basename($file);
        global $restricted_include_filenames;
        if (array_key_exists(strtolower($base_filename), $restricted_include_filenames)) {
            _clear_vars($ctx, $ext_args);
            return "";
        }
        $cache_id = 'file::' . $blog_id . '::' . $file;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            if (is_file($file) && is_readable($file)) {
                $contents = @file($file);
                $tmpl = implode('', $contents);
            } else {
                $blog = $ctx->stash('blog');
                if ($blog['blog_id'] != $blog_id) {
                    $blog = $ctx->mt->db->fetch_blog($blog_id);
                }
                $path = $blog['blog_site_path'];
                if (!preg_match('!/$!', $path))
                    $path .= '/';
                $path .= $file;
                if (is_file($path) && is_readable($path)) {
                    $contents = @file($path);
                    $tmpl = implode('', $contents);
                } else {
                    _clear_vars($ctx, $ext_args);
                    return $ctx->error("Could not open file '$file'");
                }
            }
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache[$cache_id] = $_var_compiled;
            } else {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template file '$file'");
            }
        }
    } elseif (isset($args['type']) && ($args['type'])) {
        $type = $args['type'];
        $cache_id = 'type::' . $blog_id . '::' . $type;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = $ctx->mt->db->load_special_template($ctx, null, $type, $blog_id);
            if ($tmpl) {
                if ($ctx->_compile_source('evaluated template', $tmpl['template_text'], $_var_compiled)) {
                    $_include_cache[$cache_id] = $_var_compiled;
                } else {
                    if ($type != 'dynamic_error') {
                        _clear_vars($ctx, $ext_args);
                        return $ctx->error("Error compiling template module '$module'");
                     } else {
                        _clear_vars($ctx, $ext_args);
                         return null;
                     }
                }
            } else {
                _clear_vars($ctx, $ext_args);
                return null;
            }
        }
    }

    ob_start();
    $ctx->_eval('?>' . $_var_compiled);
    $_contents = ob_get_contents();
    ob_end_clean();

    _clear_vars($ctx, $ext_args);

    return $_contents;
}

function _clear_vars(&$ctx, $ext_vars) {
    # unset vars
    $vars =& $ctx->__stash['vars'];
    foreach ($ext_vars as $v) {
        unset($vars[$v]);
    }
    $ctx->__stash['vars'] =& $vars;
}
?>
