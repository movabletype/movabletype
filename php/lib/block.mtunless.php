<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtunless($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $result = 0;
        if (isset($args['var'])) {
            $val = $ctx->__stash['vars'][$args['var']];
        } elseif (isset($args['name'])) {
            $val = $ctx->__stash['vars'][$args['name']] ?? null;
        } elseif (isset($args['tag'])) {
            $tag = $args['tag'];
            $tag = preg_replace('/^mt:?/i', '', $tag);
            $largs = $args; // local arguments without 'tag' element
            unset($largs['tag']);
            $val = $ctx->tag($tag, $largs);
        }
        if (isset($val) && !is_array($val)
          && preg_match('/^smarty_fun_[a-f0-9]+$/', $val)) {
            if (function_exists($val)) {
                ob_start();
                $val($ctx, array());
                $val = ob_get_contents();
                ob_end_clean();
            } else {
                $val = '';
            }
        }
        if (array_key_exists('eq', $args)) {
            $val2 = $args['eq'];
            $result = $val == $val2 ? 1 : 0;
        } elseif (array_key_exists('ne', $args)) {
            $val2 = $args['ne'];
            $result = $val != $val2 ? 1 : 0;
        } elseif (array_key_exists('gt', $args)) {
            $val2 = $args['gt'];
            $result = $val > $val2 ? 1 : 0;
        } elseif (array_key_exists('lt', $args)) {
            $val2 = $args['lt'];
            $result = $val < $val2 ? 1 : 0;
        } elseif (array_key_exists('ge', $args)) {
            $val2 = $args['ge'];
            $result = $val >= $val2 ? 1 : 0;
        } elseif (array_key_exists('le', $args)) {
            $val2 = $args['le'];
            $result = $val <= $val2 ? 1 : 0;
        } elseif (array_key_exists('like', $args)) {
            $patt = $args['like'];
            $opt = "";
            if (preg_match("/^\/.+\/([si]+)?$/", $patt, $matches)) {
                $patt = preg_replace("/^\/|\/([si]+)?$/", "", $patt);
                if ($matches[1])
                    $opt = $matches[1];
            } else {
                $patt = preg_replace("!/!", "\\/", $patt);
            }
            $result = preg_match("/$patt/$opt", $val) ? 1 : 0;
        } elseif (array_key_exists('test', $args)) {
            $expr = 'return (' . $args['test'] . ') ? 1 : 0;';
            // export vars into local variable namespace, then eval expr
            extract($ctx->__stash['vars']);
            $result = eval($expr);
            if ($result === FALSE) {
                die("error in expression [" . $args['test'] . "]");
            }
        } else {
            $result = isset($val) && $val ? 1 : 0;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !$result);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
