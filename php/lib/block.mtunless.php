<?php
function smarty_block_mtunless($args, $content, &$ctx, &$repeat) {
    // TODO: Combine MTIf / MTUnless together so code isn't duplicated
    if (!isset($content)) {
        $result = 0;
        if (isset($args['var'])) {
            $val = $ctx->__stash['vars'][$args['var']];
        } elseif (isset($args['name'])) {
            $val = $ctx->__stash['vars'][$args['name']];
        }
        if (array_key_exists('eq', $args)) {
            $val2 = $args['eq'];
            $result = $val == $val2;
        } elseif (array_key_exists('ne', $args)) {
            $val2 = $args['ne'];
            $result = $val != $val2;
        } elseif (array_key_exists('gt', $args)) {
            $val2 = $args['gt'];
            $result = $val > $val2;
        } elseif (array_key_exists('lt', $args)) {
            $val2 = $args['lt'];
            $result = $val < $val2;
        } elseif (array_key_exists('ge', $args)) {
            $val2 = $args['ge'];
            $result = $val >= $val2;
        } elseif (array_key_exists('le', $args)) {
            $val2 = $args['le'];
            $result = $val <= $val2;
        } elseif (array_key_exists('like', $args)) {
            $patt = $args['like'];
            $patt = preg_replace("!/!", "\\/", $patt);
            $result = preg_match("/$patt/", $val);
        } else {
            $result = isset($val) && $val;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, !$result);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
