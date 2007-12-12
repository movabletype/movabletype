<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtloop($args, $content, &$ctx, &$repeat) {
    $localvars = array('__loop_keys', '__loop_values');

    if (!isset($content)) {
        $ctx->localize($localvars);
        $vars =& $ctx->__stash['vars'];
        $value = '';
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';
        if (isset($vars[$name]))
            $value = $vars[$name];
        if ( !is_array($value)
          && preg_match('/^smarty_fun_[a-f0-9]+$/', $value) ) {
            if (function_exists($value)) {
                ob_start();
                $value($ctx, array());
                $value = ob_get_contents();
                ob_end_clean();
            } else {
                $value = '';
            }
        }
        if ( !is_array($value) || (0 == count($value)) ) {
            $repeat = false;
            return '';
        }
        $sort = $args['sort_by'];
        $keys = array_keys($value);
        if ($sort) {
            $sort = strtolower($sort);
            if (preg_match('/\bkey\b/', $sort)) {
                usort($keys, create_function(
                    '$a,$b',
                    'return strcmp($a, $b);'
                ));
            } elseif (preg_match('/\bvalue\b/', $sort)) {
                if (preg_match('/\bnumeric\b/', $sort)) {
                    $sorter = create_function(
                        '$a,$b',
                        'return $value[$a] === $value[$b] ? 0 : ($value[$a] > $value[$b] ? 1 : -1);');
                } else {
                    $sorter = create_function(
                        '$a,$b',
                        'return strcmp($value[$a], $value[$b]);');
                }
                usort($keys, $sorter);
            }
            if (preg_match('/\breverse\b/', $sort)) {
                $keys = array_reverse($keys);
            }
        }
        $counter = 1;
        $ctx->stash('__loop_values', $value);
    }
    else {
        $counter = $ctx->__stash['vars']['__counter__'] + 1;
        $keys = $ctx->stash('__loop_keys');
        $value = $ctx->stash('__loop_values');
        if (!isset($keys) || $keys == 0) {
            $ctx->restore($localvars);
            $repeat = false;
            return $content;
        }
    }
    $key = array_shift($keys);
    $this_value = $value[$key];
    $ctx->stash('__loop_keys', $keys);

    $ctx->__stash['vars']['__counter__'] = $counter;
    $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 1;
    $ctx->__stash['vars']['__even__'] = ($counter % 2) == 0;
    $ctx->__stash['vars']['__first__'] = $counter == 1;
    $ctx->__stash['vars']['__last__'] = count($value) == 0;
    $ctx->__stash['vars']['__key__'] = $key;
    $ctx->__stash['vars']['__value__'] = $this_value;
    if ( is_array($this_value) && (0 < count($this_value)) ) {
        require_once("MTUtil.php");
        if ( is_hash($this_value) ) {
            foreach (array_keys($this_value) as $inner_key) {
                $ctx->__stash['vars'][strtolower($inner_key)] = $this_value[$inner_key];
            }
        }
    }
    if (array_key_exists('glue', $args)) {
        if (1 < $counter)
            $content = $content . $args['glue'];
    }
    if ( 0 === count($keys) )
        $ctx->stash('__loop_keys', 0);

    $repeat = true;
    return $content;
}
?>
