<?php
function smarty_function_MTInclude($args, &$ctx) {
    // status: partial
    // parameters: module, file
    // notes: file case needs work -- search through blog site archive path, etc...
    static $_include_cache = array();
    if (isset($args['module']) && ($args['module'])) {
        $module = $args['module'];
        if (isset($_include_cache['module:'.$module])) {
            $_var_compiled = $_include_cache['module:'.$module];
        } else {
            $tmpl = $ctx->mt->db->get_template_text($ctx, $module);
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache['module:'.$module] = $_var_compiled;
            } else {
                return $ctx->error("Error compiling template module '$module'");
            }
        }
    } elseif (isset($args['file']) && ($args['file'])) {
        $file = $args['file'];
        if (isset($_include_cache['file:'.$file])) {
            $_var_compiled = $_include_cache['file:'.$file];
        } else {
            if (is_file($file) && is_readable($file)) {
                $contents = @file($file);
                $tmpl = implode('', $contents);
            } else {
                $blog = $ctx->stash('blog');
                $path = $blog['blog_site_path'];
                if (!preg_match('!/$!', $path))
                    $path .= '/';
                $path .= $file;
                if (is_file($path) && is_readable($path)) {
                    $contents = @file($path);
                    $tmpl = implode('', $contents);
                } else {
                    return $ctx->error("Could not open file '$file'");
                }
            }
            if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                $_include_cache['file:'.$file] = $_var_compiled;
            } else {
                return $ctx->error("Error compiling template file '$file'");
            }
        }
    } elseif (isset($args['type']) && ($args['type'])) {
        $type = $args['type'];
        if (isset($_include_cache['type:'.$type])) {
            $_var_compiled = $_include_cache['type:'.$type];
        } else {
            $tmpl = $ctx->mt->db->load_special_template($ctx, null, $type);
            if ($tmpl) {
                if ($ctx->_compile_source('evaluated template', $tmpl['template_text'], $_var_compiled)) {
                    $_include_cache['type:'.$type] = $_var_compiled;
                } else {
                    if ($type != 'dynamic_error') {
                        return $ctx->error("Error compiling template module '$module'");
                     } else {
                         return null;
                     }
                }
            } else {
                return null;
            }
        }
    }

    ob_start();
    $ctx->_eval('?>' . $_var_compiled);
    $_contents = ob_get_contents();
    ob_end_clean();

    return $_contents;
}
?>
