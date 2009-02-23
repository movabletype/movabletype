<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
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

    $blog_id = $args['blog_id'];
    $blog_id or $blog_id = $ctx->stash('blog_id');
    if ($args['local'])
        $blog_id = $ctx->stash('local_blog_id');
    $blog = $ctx->mt->db->fetch_blog($blog_id);

    // When the module name starts by 'Widget', it converts to 'Widget' from 'Module'.
    if (isset($args['module']) && ($args['module'])) {
        $module = $args['module'];
        if (preg_match('/^Widget:/', $module)) {
            $args['widget'] = preg_replace('/^Widget: ?/', '', $module);
            unset($args['module']);
        }
    }

    // Fetch template meta data
    $load_type = null;
    $load_name = null;
    if (isset($args['module'])) {
        $load_type = 'custom';
        $load_name = $args['module'];
    } elseif (isset($args['widget'])) {
        $load_type = 'widget';
        $load_name = $args['widget'];
    } elseif (isset($args['identifier'])) {
        $load_type = 'identifier';
        $load_name = $args['identifier'];
    }

    $tmpl_meta = array();
    if (!empty($load_type)) {
        $is_global = isset($args['global']) && $args['global'] ? 1 : 0;
        $tmpl_meta = $ctx->mt->db->fetch_template_meta($load_type, $load_name, $blog_id, $is_global);
    }

    # Convert to phrase of PHP Include
    $ssi_enable = false;
    $include_file = '';
    if (!empty($load_type) &&
        isset($blog) && $blog['blog_include_system'] == 'php' &&
        ((isset($args['ssi']) && $args['ssi']) || (isset($tmpl_meta['include_with_ssi']) && $tmpl_meta['include_with_ssi']))) {

        $ssi_enable = true;

        // Generates include path using Key
        $base_path = '';
        if (isset($args['key'])) {
            $base_path = $args['key'];
        } elseif(isset($args['cache_key'])) {
            $base_path or $base_path = $args['cache_key'];
        }
        $include_path_array = _include_path($base_path);

        require_once('MTUtil.php');
        $filename = dirify($tmpl_meta['template_name']);
        $filename or $filename = 'template_' . $tmpl_meta['template_id'];
        $filename .= '.'.$blog['blog_file_extension'];

        $include_path = $blog['blog_site_path'];
        if (substr($include_path, strlen($include_path) - 1, 1) != DIRECTORY_SEPARATOR)
            $include_path .= DIRECTORY_SEPARATOR;
        foreach ($include_path_array as $p) {
            $include_path .= $p . DIRECTORY_SEPARATOR;
        }
        $include_file = $include_path . $filename;
    }

    # Try to read from cache
    $cache_enable = false;
    $cache_id = '';
    $cacje_key = '';
    $cache_ttl = 0;
    if (!empty($load_type) &&
        isset($blog) && $blog['blog_include_cache'] == 1 &&
        ((isset($tmpl_meta['cache_expire_type']) && ($tmpl_meta['cache_expire_type'] == '1' || $tmpl_meta['cache_expire_type'] == '2')) ||
         ((isset($args['cache']) && $args['cache'] == '1') || isset($args['key']) || isset($args['cache_key']) || isset($args['ttl']))))
    {
        global $mt;
        $cache_enable = true;
        $cache_key = isset($args['key'])
            ? $args['key']
            : isset($args['cache_key'])
                ? $args['cache_key']
                : 'blog::' . $blog_id . '::template_' . $load_type  . '::' . $load_name;

        if (isset($args['ttl']))
            $cache_ttl = $args['ttl'];
        elseif (isset($tmpl_meta['cache_expire_type']) && $tmpl_meta['cache_expire_type'] == '1')
            $cache_ttl = $tmpl_meta['cache_expire_interval'];
        else
            $cache_ttl = 60 * 60; # default 60 min.

        if (isset($tmpl_meta['cache_expire_type']) && $tmpl_meta['cache_expire_type'] == '2') {
            $expire_types = preg_split('/,/', $tmpl_meta['cache_expire_event'], -1, PREG_SPLIT_NO_EMPTY);
            if (!empty($expire_types)) {
                $latest = $ctx->mt->db->get_latest_touch($blog_id, $expire_types);
                if ($latest) {
                    if ($ssi_enable) {
                        $file_stat = stat($include_file);
                        if ($file_stat) {
                            $file_stamp = gmdate("Y-m-d H:i:s", $file_stat[9]);
                            if (strtotime($latest) > strtotime($file_stamp))
                                $cache_ttl = 1;
                        }
                    } else {
                      $cache_ttl = time() - strtotime($latest);
                    }
                }
            }
        }

        if ($cache_ttl == 0 || (time() - strtotime($tmpl_meta['template_modified_on']) < $cache_ttl)) {
            $cache_ttl = time() - strtotime($tmpl_meta['template_modified_on']);
        }

        $cache_driver = $mt->cache_driver($cache_ttl);
        $cached_val = $cache_driver->get($cache_key, $cache_ttl);
        if (!empty($cached_val)) {
            _clear_vars($ctx, $ext_args);
            if ($ssi_enable) {
                if (file_exists($include_file) && is_readable($include_file)) {
                  $content = file_get_contents($include_file);
                  if ($content)
                      return $content;
                }
            } else {
                return $cached_val;
            }
        }
    }

    if ($ssi_enable && !$cache_enable) {
        if (file_exists($include_file) && is_readable($include_file)) {
            $content = file_get_contents($include_file);
            if ($content)
                return $content;
        }
    }

    # Compile template
    static $_include_cache = array();
    $_var_compiled = '';

    if (!empty($load_type)) {
        $cache_id = $load_type . '::' . $blog_id . '::' . $load_name;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = $ctx->mt->db->get_template_text($ctx, $load_name, $blog_id, $load_type, $args['global']);
            if (!$ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template module '$module'");
            }
            $_include_cache[$cache_id] = $_var_compiled;
        }
    } elseif (isset($args['file']) && ($args['file'])) {
        $file = $args['file'];
        $cache_id = 'file::' . $blog_id . '::' . $file;
        if (isset($_include_cache[$cache_id])) {
            $_var_compiled = $_include_cache[$cache_id];
        } else {
            $tmpl = _get_template_from_file($ctx, $file, $blog_id);
            if (!$ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
                _clear_vars($ctx, $ext_args);
                return $ctx->error("Error compiling template file '$file'");
            }
            $_include_cache[$cache_id] = $_var_compiled;
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

    if ($cache_enable) {
        $cache_driver = $mt->cache_driver($cache_ttl);
        $cache_driver->set($cache_key, $_contents, $cache_ttl);
    }

    if ($ssi_enable) {
        $include_dir = dirname($include_file);
        if (!file_exists($include_dir) && !is_dir($include_dir)) {
            mkpath($include_dir, 0777);
        }
        if (is_writable($include_dir)) {
            if ($h_file = fopen($include_file, 'w')) {
                fwrite($h_file, $_contents);
                fclose($h_file);
            }
        }
    }

    return $_contents;
}

function _get_template_from_file ($ctx, $file, $blog_id) {
    $base_filename = basename($file);
    global $restricted_include_filenames;
    if (array_key_exists(strtolower($base_filename), $restricted_include_filenames)) {
        return '';
    }
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
            return false;
        }
    }

    return $tmpl;
}

function _clear_vars(&$ctx, $ext_vars) {
    # unset vars
    $vars =& $ctx->__stash['vars'];
    foreach ($ext_vars as $v) {
        unset($vars[$v]);
    }
    $ctx->__stash['vars'] =& $vars;
}

function _include_path($path) {
    $path_array = array();
    if (preg_match('/^\//', $path)) {
        $path_array = preg_split('/\//', $path, -1, PREG_SPLIT_NO_EMPTY);
    } else {
        $path_array = preg_split('/\//', $path, -1, PREG_SPLIT_NO_EMPTY);
        global $mt;
        array_unshift($path_array, $mt->config('IncludesDir'));
    }
    return $path_array;
}
?>
