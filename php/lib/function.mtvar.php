<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtvar($args, &$ctx) {
    // status: complete
    // parameters: name
    if ( array_key_exists('value', $args)
      && !array_key_exists('op', $args) ) {
        require_once("function.mtsetvar.php");
        return smarty_function_mtsetvar($args, $ctx);
    }
    require_once("MTUtil.php");
    $vars =& $ctx->__stash['vars'];
    $value = '';
    $name = $args['name'];
    $name or $name = $args['var'];
    if (preg_match('/^(config|request)\.(.+)$/i', $name, $m)) {
        if (strtolower($m[1]) == 'config') {
            if (!preg_match('/password|secret/i', $m[2])) {
                $mt = MT::get_instance();
                return $mt->config(strtolower($m[2]));
            }
        }
        elseif (strtolower($m[1]) == 'request') {
            return $_REQUEST[$m[2]];
        }
    }
    if (!$name) return '';

    if (preg_match('/^(\w+)\((.+)\)$/', $name, $matches)) {
        $func = $matches[1];
        $name = $matches[2];
    } else {
        if (array_key_exists('function', $args))
            $func = $args['function'];
    }

    # pick off any {...} or [...] from the name.
    if (preg_match('/^(.+)([\[\{])(.+)[\]\}]$/', $name, $matches)) {
        $name = $matches[1];
        $br = $matches[2];
        $ref = $matches[3];
        if (preg_match('/^\$(.+)/', $ref, $ref_matches)) {
            $ref = $vars[$ref_matches[1]];
            if (!isset($ref))
                $ref = chr(0);
        }
        $br == '[' ? $index = $ref : $key = $ref;
    } else {
        if (array_key_exists('index', $args))
            $index = $args['index'];
        else if (array_key_exists('key', $args))
            $key = $args['key'];
    }

    if (preg_match('/^\$/', $name)) {
        $name = $vars[$name];
        if (!isset($name))
            return $ctx->error($ctx->mt->translate(
                "You used an [_1] tag without a valid name attribute.", "<MT$tag>" ));
    }

    if (isset($vars[$name]))
        $value = $vars[$name];

    $return_val = $value;
    if (isset($name)) {
        if (is_hash($value)) {
            if ( isset($key) ) {
                if ( isset($func) ) {
                    if ( 'delete' == strtolower($func) ) {
                        $return_val = $value[$key];
                        unset($value[$key]);
                        $vars[$name] = $value;
                    } else {
                        return $ctx->error(
                            $ctx->mt->translate("'[_1]' is not a valid function for a hash.", $func)
                        );
                    }
                } else {
                    if ($key != chr(0)) {
                        $return_val = isset($value[$key]) ? $value[$key] : null;
                    } else {
                        unset($value);
                    }
                }
            }
            elseif ( isset($func) ) {
                if ( 'count' == strtolower($func) ) {
                    $return_val = count(array_keys($value));
                }
                else {
                    return $ctx->error(
                        $ctx->mt->translate("'[_1]' is not a valid function for a hash.", $func)
                    );
                }
            }
            else {
                if (array_key_exists('to_json', $args) && $args['to_json']) {
                    if (function_exists('json_encode')) {
                        $return_val = json_encode($value);
                    } else {
                        $return_val = '';
                    }
                }
            }
        }
        elseif (is_array($value)) {
            if ( isset($index) ) {
                if (is_numeric($index)) {
                    $return_val = isset($value[$index]) ? $value[$index] : null;
                } else {
                    unset($value); # fall through to any 'default'
                }
            }
            elseif ( isset($func) ) {
                $func = strtolower($func);
                if ( 'pop' == $func ) {
                    $return_val = array_pop($value);
                    $vars[$name] = $value;
                }
                elseif ( 'shift' == $func ) {
                    $return_val = array_shift($value);
                    $vars[$name] = $value;
                }
                elseif ( 'count' == $func ) {
                    $return_val = count($value);
                }
                else {
                    return $ctx->error(
                        $ctx->mt->translate("'[_1]' is not a valid function for an array.", $func)
                    );
                }
            }
            elseif (array_key_exists('to_json', $args) && $args['to_json']) {
                if (function_exists('json_encode')) {
                    $return_val = json_encode($value);
                } else {
                    $return_val = '';
                }
            }
            else {
                $return_val = implode($value);
            }
        }
        if ( array_key_exists('op', $args) ) {
            $op = $args['op'];
            $rvalue = isset($args['value']) ? $args['value'] : null;
            if ( $op && isset($value) && !is_array($value) ) {
                $return_val = _math_operation($op, $value, $rvalue);
                if (!isset($return_val)) {
                    return $ctx->error($ctx->mt->translate("[_1] [_2] [_3] is illegal.", array($value, $op, $rvalue)));
            }}
        }
        if ( !is_array($return_val) && preg_match('/^smarty_fun_[a-f0-9]+$/', $return_val ?? '') ) {
            if (function_exists($return_val)) {
                ob_start();
                $return_val($ctx, array());
                $return_val = ob_get_contents();
                ob_end_clean();
            } else {
                $return_val = '';
            }
        }
    }

    if ($return_val === '') {
        if (isset($args['default'])) {
            $return_val = $args['default'];
        }
    }
    if (isset($args['escape'])) {
        $esc = strtolower($args['escape']);
        if ($esc == 'js') {
            $return_val = encode_js($return_val);
        } elseif ($esc == 'html') {
            $return_val = encode_html_entities($return_val, ENT_QUOTES);
        } elseif ($esc == 'url') {
            $return_val = urlencode($return_val);
            $return_val = preg_replace('/\+/', '%20', $return_val);
        }
    }
    return $return_val;
}
?>
