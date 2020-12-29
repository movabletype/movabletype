<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsetvarblock($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (isset($content)) {
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';

        $vars =& $ctx->__stash['vars'];

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
                    "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ));
        }

        $value = $content;
        $existing = $vars[$name];

        require_once("MTUtil.php");
        if (isset($key)) {
            if (!isset($existing))
                $existing = array($key => $value);
            elseif (is_hash($existing))
                $existing = $existing[$key];
            else
                return $ctx->error( $ctx->mt->translate("'[_1]' is not a hash.", $name) );
        }
        elseif (isset($index)) {
            if (!isset($existing))
                $existing[$index] = $value;
            elseif (is_array($existing)) {
                if ( is_numeric($index) )
                    $existing = $existing[$index];
                else
                    return $ctx->error( $ctx->mt->translate("Invalid index.") );
            }
            else
                return $ctx->error( $ctx->mt->translate("'[_1]' is not an array.", $name) );
        }

        if (array_key_exists('append', $args) && $args['append']) {
            $value = isset($existing) ? $existing . $value : $value;
        }
        elseif (array_key_exists('prepend', $args) && $args['prepend']) {
            $value = isset($existing) ?  $value . $existing : $value;
        }
        elseif ( isset($existing) && array_key_exists('op', $args) ) {
            $op = $args['op'];
            $value = _math_operation($op, $existing, $value);
            if (!isset($value))
                return $ctx->error();
        }

        $data = $vars[$name];
        if ( isset($key) ) {
            if ( ( isset($func) )
              && ( 'delete' == strtolower( $func ) ) ) {
                unset($data[$key]);
            }
            else {
                $data[$key] = $value;
            }
        }
        elseif ( isset($index) ) {
            $data[$index] = $value;
        }
        elseif ( isset($func) ) {
            if ( 'undef' == strtolower( $func ) ) {
                unset($data);
            }
            else {
                if (isset($data) && !is_array($data))
                    return $ctx->error( $ctx->mt->translate("'[_1]' is not an array.", $name) );
                if (!isset($data))
                    $data = array();
                if ( 'push' == strtolower( $func ) ) {
                    array_push($data, $value);
                }
                elseif ( 'unshift' == strtolower( $func ) ) {
                    array_unshift($data, $value);
                }
                else {
                    return $ctx->error(
                        $ctx->mt->translate("'[_1]' is not a valid function.", $func)
                    );
                }
            }
        }
        else {
            $data = $value;
        }
        $hash = $ctx->stash('__inside_set_hashvar');
        if (isset($hash)) {
            $hash[$name] = $data;
            $ctx->stash('__inside_set_hashvar', $hash);
        }
        else {
            if (is_array($vars)) {
                $vars[$name] = $data;
            } else {
                $vars = array($name => $data);
                $ctx->__stash['vars'] =& $vars;
            }
        }
    }
    return '';
}
?>
