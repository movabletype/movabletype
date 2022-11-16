<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

/* Movable Type template -> Smarty template
  
    <$MTVariable$> -> {Variable}
  
    <MTVariable> -> {Variable}
  
    <MTVariable this="that"> -> {Variable this="that"}
  
    <MTVariable dirify="1"> -> {Variable|dirify:"1"}
  
    <MTEntries>...</MTEntries> -> {Entries}...{/Entries}
  
    <MTIfNonEmpty var="MTVariable">
      ...
    <MTElse>...</MTElse>
    </MTIfNonEmpty>
 -> {IfNonEmpty var="MTVariable"}{if $conditional}
      ...
    {/if}{if !$conditional}...{/if}{if $conditional}
    {/if}{/IfNonEmpty}

Note that all MT 'variable' tags are translated to functions.
This is necessary since you can't preload all the data that a
MT template may require. This is equivalent to the MT::Template::Context
approach-- every 'Variable' tag invokes a handler function.

The "Else" tag was a tricky beast. Ironic since I added that
syntax to MT myself. Here's how I decided to implement it. Each
'conditional' tag is handled a little differently than regular
block tags. They have a requirement to set a 'conditional' template
variable to 1 or 0 depending on whether the condition is met or not.
The setting for 'conditional' must be preserved and restored using
the 'localize' and 'restore' routines. Regardless of the value of
$conditional, the block function must return $content either way.
This allows the inner 'if' statements to do their work. See above
for how the '$conditional' variable is used.
*/
function smarty_prefilter_mt_to_smarty($tpl_source, $ctx2) {
    // used to serialize attributes when creating tag stack for
    // function tags.
    $var_export = function_exists('var_export');

    $mt = MT::get_instance();
    $ctx =& $mt->context();
    $ldelim = $ctx->left_delimiter;
    $rdelim = $ctx->right_delimiter;
    $smart_source = '';
    $tokenstack = array();
    $tagstack = array();

    # special tag step for stripping any conditional 'static' code.
    $tpl_source = preg_replace('/<MT:?IfStatic[^>]*?>.*?<\/MT:?IfStatic>/is', '', $tpl_source);

    while(preg_match('/<MT:?Ignore\b[^>]*?>((?!<MT:?Ignore\b[^>]*?>).)*?<\/MT:?Ignore>/is', $tpl_source)){
        $tpl_source = preg_replace('/<MT:?Ignore\b[^>]*?>((?!<MT:?Ignore\b[^>]*?>).)*?<\/MT:?Ignore>/is', '', $tpl_source);
    }


    if ($parts = preg_split('!(<(?:\$?|/)MT(?:(?:<[^>]*?>|\'[^\']*?\'|"[^"]*?"|.)+?)(?:\$?|/)>)!is', $tpl_source, -1,
                       PREG_SPLIT_DELIM_CAPTURE)) {
        foreach ($parts as $part) {
            if (!preg_match('!<(\$?|/)(MT:?(?:<[^>]*?>|\'[^\']*?\'|"[^"]*?"|.)+?)(\$?|/)>!is', $part, $matches)) {
                $smart_source .= $part;
                continue;
            }

            list($wholetag, $open, $tag, $close) = $matches;

            $attrargs = '';
            $modargs = '';

            list($mttag, $args) = array_pad(preg_split('!\s+!s', $tag, 2), 2, '');
            $mttag or $mttag = $tag;
            // ignore namespace delimiter, for now
            $mttag = preg_replace('/:/', '', strtolower($mttag));
            $attrs = array();

            if (preg_match_all('!(?:((?:\w|:)+)\s*=\s*(["\'])((?:<[^>]*?>|\'[^\']*?\'|"[^"]*?"|.)*?)?\2((?:[,:](["\'])((?:<[^>]*?>|.)*?)?\5)*)?|(\w+))!s', $args,
                               $arglist, PREG_SET_ORDER)) {

                for ($a = 0; $a < count($arglist); $a++) {
                    if (isset($arglist[$a][7])) {
                        $attr = 'name';
                        $attrs[$attr] = $arglist[$a][7];
                        $quote = '"';
                    } else {
                        $attr = $arglist[$a][1];
                        $attr = strtolower(preg_replace('/:/', '___', $attr));
                        $attrs[$attr] = $arglist[$a][3];
                        $quote = $arglist[$a][2];
                    }
                    if (preg_match('/^\$([A-Za-z_](\w|\.)*)$/', $attrs[$attr], $matches)) {
                        if (preg_match('/^(config|request)\.(.+)$/i', $matches[1], $m)) {
                            if (strtolower($m[1]) == 'config' && !preg_match('/(password|secret)/i', $m[2]) ) {
                                $attrs[$attr] = $mt->config(strtolower($m[2]));
                            }
                            elseif (strtolower($m[1]) == 'request') {
                                $attrs[$attr] = '$smarty.request.' . $m[2];
                            }
                        } else {
                            $attrs[$attr] = '$vars.' . $matches[1];
                        }
                        $quote = '';
                    }
                    if (!empty($ctx->global_attr[$attr])) {
                        if( (preg_match('!^MTVar!i', $mttag ) || preg_match('!^MTGetVar!i', $mttag ) )
                            && (
                                (isset($attrs['name']) && preg_match('/\[.*\]/i', $attrs['name'] ))
                                || (isset($attrs['index']) || isset($attrs['key']) ))
                            && $attr == 'setvar'){
                            $attrargs .= ' ' . $attr . '=' . $quote . $attrs[$attr] . $quote;
                        } else {
                            $modargs .= '|';
                            if ($ctx->global_attr[$attr] != '1') {
                                $modargs .= $ctx->global_attr[$attr];
                            } else {
                                $modargs .= $attr;
                            }
                            $modargs .= ':' . $quote . $attrs[$attr] . $quote;
                            if (isset($arglist[$a][4])) {
                               $modargs .= _parse_modifier($arglist[$a][4]);
                            }
                        }
                    } else {
                        // reconstruct attribute in case we modified
                        // the attribute to handle variable references
                        if($attrs[$attr] == '\\')
                            $attrs[$attr] = addslashes($attrs[$attr]);
                        $attrargs .= ' ' . $attr . '=' . $quote . $attrs[$attr] . $quote;
                        if (isset($arglist[$a][4])) {
                            $attrargs .= _parse_modifier($arglist[$a][4]);
                        }
                    }
                }
            }
            if (isset($ctx->sanitized[$mttag])) {
                if (!isset($attrs['sanitize'])) {
                    $modargs = '|sanitize:"1"' . $modargs;
                }
            }
            if (isset($ctx->nofollowed[$mttag])) {
                if (!isset($attrs['nofollowfy'])) {
                    $modargs .= "|nofollowfy:\"$mttag\"";
                }
            }

            if (preg_match('!^MTIf!i', $mttag) ||
                preg_match('!^MTHas!i', $mttag) ||
                (preg_match('![a-z]If[A-Z]!i', $mttag) &&
                !preg_match('![a-z]Modified[A-Z]!i', $mttag) &&
                !preg_match('![a-z]Notify[A-Z]!i', $mttag) &&
                !preg_match('![a-z]Identifier!i', $mttag)) ||
                isset($ctx->conditionals[$mttag])) {
                $conditional = 1;
            } elseif (($mttag == 'mtentries') ||
                ($mttag == 'mtcomments') ||
                ($mttag == 'mtpages') ||
                ($mttag == 'mtassets') ||
                ($mttag == 'mtentryassets') ||
                ($mttag == 'mtpageassets') ||
                ($mttag == 'mtcommentreplies') ||
                ($mttag == 'mtcontents')) {
                $conditional = 1;
            } else {
                $conditional = 0;
            }

            // force the elements in $vars to always to act like a function
            if ($open == '$') {
                $open = '';
            }

            if ((($open == '/' && $conditional) ||
                 ($mttag == 'mtelse' || $mttag == 'mtelseif')) &&
                $close != '/') {
                $smart_source .= $ldelim.'/if'.$rdelim;

            }

            $tokname = null;
            if (isset($ctx->needs_tokens[$mttag])) {
                if ($open != '/') {
                    $tokname = uniqid(rand());
                    $attrargs .= ' token_fn="smarty_fun_'.$tokname.'"';
                    array_push($tokenstack, $tokname);
                } else {
                    $tokname = array_pop($tokenstack);
                    $smart_source .= $ldelim.'/defun'.$rdelim;
                }
            }

            $open_mod_args = false; $close_mod_args = ''; $uniqid = '';
            $fn_tag = 0;
            if (_block_handler_exists($ctx2, $mttag)) {
                if ($open == '/') {
                    $tag = array_pop($tagstack);
                    if (preg_match('/^(.+?)(\|.+)$/', $tag, $matches)) {
                        $tag = $matches[1];
                        $close_mod_args = $matches[2];
                    }
                    if (($tag == 'mtelse' || $tag == 'mtelseif') && ($tag != $mttag)) {
                        $smart_source .= $ldelim . '/' . $tag . $rdelim;
                        if ($mttag == $tagstack[count($tagstack)-1]) {
                            $tag = array_pop($tagstack);
                        } elseif (preg_match('/^('. $mttag . ')(\|.+)$/', $tagstack[count($tagstack)-1], $matches)) {
                            $tag = array_pop($tagstack);
                            $tag = $matches[1];
                            $close_mod_args = $matches[2];
                        }
                    }
                    if ($tag != $mttag) {
                        die("error in template: $tag found but $mttag was expected\n");
                    }
                } else {
                    if ($mttag == 'mtelse' || $mttag == 'mtelseif') {
                        if ($tagstack[count($tagstack)-1] == 'mtelse' || $tagstack[count($tagstack)-1] == 'mtelseif') {
                            $smart_source .= $ldelim . '/' . $tagstack[count($tagstack)-1] . $rdelim;
                            array_pop($tagstack);
                        }
                    }
                    $tagstack[] = $mttag . $modargs;
                    if ($modargs != '') {
                        $modargs = '';
                        $open_mod_args = true;
                    }
                }
            } else {
                if ($close == '/') $close = '';
                $fn_tag = 1;
            }

            if ($open_mod_args) {
                $smart_source .= $ldelim . 'capture' . $rdelim;
            }

            if ($fn_tag) {
                $smart_source .= $ldelim . 'push_ctx_stack mttag="' . $mttag . '" ' . $attrargs . $rdelim;
            }

            $smart_source .= $ldelim.$open.
                                  $mttag.
                                  $modargs.
                                  $attrargs.
                                  $rdelim;
            if ($fn_tag) {
                $smart_source .= $ldelim . 'pop_ctx_stack' . $rdelim;
            }

            if ($close_mod_args) {
                $smart_source .= $ldelim . '/capture' . $rdelim . $ldelim . '$smarty.capture.default' . $close_mod_args . $rdelim;
            }

            if (isset($tokname)) {
                if ($open != '/') {
                    $smart_source .= $ldelim.'defun name="'.$tokname.'"'.$rdelim;
                }
            }

            if ($mttag == 'mtelse') {
                if ($open != '/') {
                    if (count($attrs)) {
                        # else-if
                        $smart_source .= $ldelim.'if $elseif_conditional'.$rdelim;
                    } else {
                        # else
                        $smart_source .= $ldelim.'if !$conditional'.$rdelim;
                    }
                } else {
                    $smart_source .= $ldelim.'if $conditional'.$rdelim;
                }
            } elseif ($mttag == 'mtelseif') {
                if ($open != '/') {
                    if (count($attrs)) {
                        # else-if
                        $smart_source .= $ldelim.'if $elseif_conditional'.$rdelim;
                    } else {
                        # else
                        $smart_source .= $ldelim.'if !$conditional'.$rdelim;
                    }
                }
            } elseif ($open != '/' && $conditional && $close != '/') {
                $smart_source .= $ldelim.'if $conditional'.$rdelim;
            } elseif ($close == '/') {
                $smart_source .= $ldelim.'/'.$mttag.$rdelim;
            }

            // extra newline is eaten by PHP but will cause any actual
            // newline from user to be preserved:
            if($open != '/' && ( $fn_tag || $conditional ) ){
                $smart_source .= "\n";
            }
        }
    } else {
        $smart_source = $tpl_source;
    }

    $php_open = $ldelim.'mtphp'.$rdelim;
    $php_close = $ldelim.'/mtphp'.$rdelim;

    // allow normal php markers to work-- change them to
    // smarty php blocks...
    $smart_source = preg_replace('/<\?php(\s*.*?)\?>/s',
        $php_open.'\1;'. $php_close, $smart_source);

    // salvage old smarty php tags
    $smart_source = preg_replace(
        ["#{$ldelim}\\s*php\\s*{$rdelim}#", "#{$ldelim}\\s*/\\s*php\\s*{$rdelim}#"],
        [$php_open, $php_close],
        $smart_source
    );

#    echo $smart_source;
    return $smart_source;
}

function _parse_modifier($str) {
    if (!preg_match('/,/', $str)) {
        return $str;
    }
    $mt = MT::get_instance();
    $result = '';
    if (preg_match_all('/(?:[,:]((["\'])((?:<[^>]*?>|.)*?)?\2)+)/', $str, $matches, PREG_SET_ORDER)) {
        for ($a = 0; $a < count($matches); $a++) {
            $val = $matches[$a][1];
            if (strlen($val)) {
                if (preg_match('/^([\'"])\$([A-Za-z_](\w|\.)*)\1$/', $val, $second_matches)) {
                    $quote = $second_matches[1];
                    if (preg_match('/^(config|request)\.(.+)$/i', $second_matches[2], $m)) {
                        if (strtolower($m[1]) == 'config' && !preg_match('/(password|secret)/i', $m[2]) ) {
                            $val = $quote . $mt->config(strtolower($m[2])) . $quote;
                        }
                        elseif (strtolower($m[1]) == 'request') {
                            $val = '$smarty.request.' . $m[2];
                        }
                    } else {
                        $val = '$vars.' . $second_matches[2];
                    }
                }
                elseif (preg_match('/^([\'"])(.*(?<!\\\\)\1.*)\1$/', $val, $second_matches)) {
                    $quote = $second_matches[1];
                    $val = preg_replace("/(?<!\\\\)$quote/", "\\$quote", $second_matches[2]);
                    $val = $quote . $val . $quote;
                }
                $result .= ':' . $val;
            }
        }
        return $result;
    } else {
        return $str;
    }
}

function _block_handler_exists(&$smarty, $name) {
    if (isset($smarty->smarty->registered_plugins[Smarty::PLUGIN_BLOCK][$name])) return true;
    $_plugin_filename = 'block.' . $name . '.php';
    foreach ($smarty->smarty->plugins_dir as $value) { 
        $filepath = $value .$_plugin_filename; 
        if (file_exists($filepath)) { 
            return true; 
        } 
    } 
    return false;
}
?>
