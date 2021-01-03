<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtsetvartemplate($args, $content, &$ctx, &$repeat) {
    // parameters: name, value
    if (!isset($content)) {
        $name = $args['name'];
        $name or $name = $args['var'];
        if (!$name) return '';
        $value = $args['token_fn'];
        $vars =& $ctx->__stash['vars'];

        if (preg_match('/^(.+)([\[\{])(.+)[\]\}]$/', $name, $matches)) {
            $name = $matches[1];
            $br = $matches[2];
            $ref = $matches[3];
            if (preg_match('/^\$(.+)/', $ref, $ref_matches)) {
                $ref = $vars[$ref_matches[1]];
                if (!isset($ref))
                    $ref = chr(0);
            }
            if (array_key_exists($name, $vars)) {
                $new_value =& $vars[$name];
            }
            else {
                $new_value = array();
            }
            if ($br == '[') {
                $new_value = array_pad($new_value, $ref, NULL);
            }
            $new_value[$ref] = $value;
            $value =& $new_value;
        }


        if (is_array($vars)) {
            $vars[$name] = $value;
        } else {
            $vars = array($name => $value);
            $ctx->__stash['vars'] = $vars;
        }
    }
    return '';
}
?>
