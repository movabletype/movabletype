<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

include_once("Smarty.class.php");
class MTViewer extends Smarty {
    var $varstack = array();
    var $__stash;
    var $mt;
    var $last_ts = 0;
    var $id;

    var $path_sep;

    var $conditionals = array(
        'mtparentcategory' => 1,
        'mttoplevelparent' => 1,
        'mtunless' => 1,
        'mtfolderheader' => 1,
        'mtfolderfooter' => 1,
        'mtpagesheader' => 1,
        'mtpagesfooter' => 1,
        'mthassubfolders' => 1,
        'mthasparentfolders' => 1,
        'mthasparentfolder' => 1,
        'mtauthorhasentry' => 1,
        'mtauthorhaspage' => 1,
    );
    var $sanitized = array(
        'mtcommentauthor' => 1,
        'mtcommentemail' => 1,
        'mtcommenturl' => 1,
        'mtcommentbody' => 1,
        'mtpingtitle' => 1,
        'mtpingurl' => 1,
        'mtpingexcerpt' => 1,
        'mtpingblogname' => 1,
    );
    var $nofollowed = array(
        'mtcommentauthorlink' => 1,
        'mtcommenturl' => 1,
        'mtcommentbody' => 1,
        'mtpings' => 1,
    );
    var $global_attr = array(
        'filters' => 1,
        'trim_to' => 1,
        'trim' => 1,
        'ltrim' => 1,
        'rtrim' => 1,
        'decode_html' => 1,
        'decode_xml' => 1,
        'remove_html' => 1,
        'dirify' => 1,
        'sanitize' => 1,
        'encode_html' => 1,
        'encode_xml' => 1,
        'encode_js' => 1,
        'encode_php' => 1,
        'encode_url' => 1,
        'upper_case' => 1,
        'lower_case' => 1,
        'strip_linefeeds' => 1,
        'space_pad' => 1,
        'zero_pad' => 1,
        'sprintf' => 1,
        'wrap_text' => 1,
        'setvar' => 1,
         # native smarty modifiers
        'regex_replace' => 1,
        'capitalize' => 1,
        'count_characters' => 1,
        'cat' => 1,
        'count_paragraphs' => 1,
        'count_sentences' => 1,
        'count_words' => 1,
        'date_format' => 1,
        '_default' => 'default',
        'escape' => 1,
        'indent' => 1,
        'nl2br' => 1,
        'replace' => 1,
        'spacify' => 1,
        'string_format' => 1,
        'strip' => 1,
        'strip_tags' => 1,
        'truncate' => 1,
        'wordwrap' => 1,
    );
    var $needs_tokens = array(
        'mtsubcategories' => 1,
        'mttoplevelcategories' => 1,
        'mtsubfolers' => 1,
        'mttoplevelfolders' => 1,
        'mtcommentreplies' => 1,
        'mtsetvartemplate' => 1,
    );

    function MTViewer(&$mt) {
        // prevents an unknown index error within Smarty.class.php
        $this->id = md5(uniqid('MTViewer',true));
        $_COOKIE['SMARTY_DEBUG'] = 0;
        $GLOBALS['HTTP_COOKIE_VARS']['SMARTY_DEBUG'] = 0;
        $this->path_sep = (strtoupper(substr(PHP_OS, 0, 3)) == 'WIN') ? ';' : ':';
        $this->Smarty();
        $this->mt =& $mt;
        $this->__stash =& $this->_tpl_vars;
        $this->left_delimiter = "{{";
        $this->right_delimiter = "}}";
        $this->load_filter('pre', 'mt_to_smarty');
        $this->register_block('mtdynamic', array(&$this, 'smarty_block_dynamic'),
                              false);
        $this->register_block('mtelse', array(&$this, 'smarty_block_else'));
        $this->register_block('mtelseif', array(&$this, 'smarty_block_elseif'));

        # Unregister the 'core' regex_replace so we can replace it
        $this->register_modifier('regex_replace', array(&$this, 'regex_replace'));
    }

    function add_plugin_dir($plugin_dir) {
        ini_set('include_path', $plugin_dir . $this->path_sep . ini_get('include_path'));
        $this->plugins_dir[] = $plugin_dir;
    }

    function regex_replace($string, $search, $replace) {
        if (preg_match('!([a-zA-Z\s]+)$!s', $search, $match) && (preg_match('/[eg]/', $match[1]))) {
            if (strpos($match[1], "g") !== false)
                $global = 1;
            /* remove eval-modifier from $search */
            $search = substr($search, 0, -strlen($match[1])) . preg_replace('![eg\s]+!', '', $match[1]);
        }
        return preg_replace($search, $replace, $string, $global ? -1 : 1);
    }

    function add_token_tag($name) {
        $this->needs_tokens[$name] = 1;
    }

    function add_conditional_tag($name, $code = null, $cacheable = null, $cache_attrs = null) {
        $this->conditionals[$name] = 1;
        if (isset($code)) {
            $this->register_block($name, $code, $cacheable, $cache_attrs);
        }
    }

    function add_global_filter($name, $code = null) {
        $this->global_attr[$name] = 1;
        if (isset($code)) {
            $this->register_modifier($name, $code);
        }
    }

    function error($err, $error_type = E_USER_ERROR) {
        trigger_error($err, $error_type);
        return '';
    }

    function this_tag() {
        $ts = $this->_tag_stack[count($this->_tag_stack)-1];
        if ($ts) {
            return $ts[0];
        } else {
            return null;
        }
    }

    function stash($name,$value=null) {
        if(isset($this->__stash[$name]))
            $old_val = $this->__stash[$name];
        else
            $old_val = null;
        if(func_num_args() > 1)
            $this->__stash[$name] = $value;
        return $old_val;
    }

    function localize($vars) {
        foreach ($vars as $v) {
            if (!isset($this->varstack[$v])) $this->varstack[$v] = array();
            $this->varstack[$v][] = isset($this->__stash[$v]) ? $this->__stash[$v] : null;
        }
    }

    function restore($vars) {
        foreach ($vars as $v) {
            $this->__stash[$v] = (isset($this->varstack[$v]) && count($this->varstack[$v]) > 0) ? array_pop($this->varstack[$v]) : null;
        }
    }

    function last_ts($ts = 0) {
        if ($ts > 0) {
            $ts = preg_replace('/[ :-]/', '', $ts);
            if ($ts > $this->last_ts) {
                $this->last_ts = $ts;
            }
        }
        return $this->last_ts;
    }

    function smarty_block_dynamic($param, $content, &$smarty) {
        return $content;
    }

    function _hdlr_if($args, $content, &$ctx, &$repeat, $cond_tag = 1) {
        if (!isset($content)) {
            if (!isset($args['elseif'])) {
                $ctx->localize(array('conditional', 'else_content', 'elseif_content', 'elseif_conditional'));
                unset($ctx->_tpl_vars['conditional']);
                unset($ctx->_tpl_vars['else_content']);
                unset($ctx->_tpl_vars['elseif_content']);
                unset($ctx->_tpl_vars['elseif_conditional']);
            }
            if ($cond_tag == '1' or $cond_tag == '0')
                $ctx->_tpl_vars['conditional'] = $cond_tag;
            else
                $ctx->_tpl_vars['conditional'] = $ctx->_tpl_vars[$cond_tag];
        } else {
            if (!$ctx->_tpl_vars['conditional']) {
                if (isset($ctx->_tpl_vars['else_content'])) {
                    $content = $ctx->_tpl_vars['else_content'];
                } else {
                    $content = '';
                }
            }
            else {
                if (isset($ctx->_tpl_vars['elseif_content'])) {
                    $content = $ctx->_tpl_vars['elseif_content'];
                }
            }
            if (!isset($args['elseif'])) {
                $ctx->restore(array('conditional', 'else_content', 'elseif_content', 'elseif_conditional'));
            }
        }
        return $content;
    }

    function smarty_block_elseif($args, $content, &$ctx, &$repeat) {
        return $this->smarty_block_else($args, $content, $ctx, $repeat);
    }

    function smarty_block_else($args, $content, &$ctx, &$repeat) {
        if (isset($ctx->_tpl_vars['elseif_content'])
            or ($ctx->_tpl_vars['conditional'])) {
            $repeat = false;
            return '';
        }
        if ((count($args) > 0) && (!isset($args['name']) && !isset($args['var']) && !isset($args['tag']))) {
            $vars =& $ctx->__stash['vars'];
            if ( array_key_exists('__cond_tag__', $vars) ) {
                $tag = $vars['__cond_tag__'];
                unset($vars['__cond_tag__']);
                if ( isset($tag) && $tag )
                    $args['tag'] = $tag;
            }
            else if ( array_key_exists('__cond_name__', $vars) ) {
                $name = $vars['__cond_name__'];
                unset($vars['__cond_name__']);
                if ( isset($name) && $name )
                    $args['name'] = $name;
            }
            if ( array_key_exists('__cond_value__', $vars) ) {
                $value = $vars['__cond_value__'];
                unset($vars['__cond_value__']);
                if ( isset($value) && $value )
                    $args['value'] = $value;
            }
            $ctx->__stash['vars'] =& $vars;
        }
        if (count($args) >= 1) { # else-if case
            require_once("block.mtif.php");
            $args['elseif'] = 1;
            if (!isset($content)) {
                $out = smarty_block_mtif($args, $content, $ctx, $repeat);
                if ($ctx->_tpl_vars['conditional']) {
                    $ctx->_tpl_vars['elseif_conditional'] = 1;
                    unset($ctx->_tpl_vars['conditional']);
                }
            } else {
                // $out = smarty_block_mtif($args, $content, $ctx, $repeat);
                if ($ctx->_tpl_vars['elseif_conditional']) {
                    $ctx->_tpl_vars['elseif_content'] = $content;
                    $ctx->_tpl_vars['conditional'] = 1;
                }
            }
            return '';
        }
        if (!isset($content)) {
            if ($ctx->_tpl_vars['conditional'])
                $repeat = false;
        } else {
            $else_content = $ctx->_tpl_vars['else_content'];
            $else_content .= $content;
            $ctx->_tpl_vars['else_content'] = $else_content;
        }
        return '';
    }

    function _hdlr_date($args, &$ctx) {
        $ts = null;
        if (isset($args['ts'])) {
            $ts = $args['ts'];
        }
        $ts or $ts = $ctx->stash('current_timestamp');
        $ts = preg_replace('![^0-9]!', '', $ts);
        $blog = $ctx->stash('blog');
        if ($ts == '') {
            $t = time();
            if ($args['utc']) {
                $ts = gmtime($t);
            } else {
                $ts = offset_time_list($t, $blog);
            }
            $ts = sprintf("%04d%02d%02d%02d%02d%02d",
                $ts[5]+1900, $ts[4]+1, $ts[3], $ts[2], $ts[1], $ts[0]);
        }
        if (isset($args['utc'])) {
            if (!is_array($blog)) {
                $blog = $ctx->mt->db->fetch_blog($blog);
            }
            preg_match('/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/', $ts, $matches);
            list($all, $y, $mo, $d, $h, $m, $s) = $matches;
            $so = $blog['blog_server_offset'];
            $timelocal = mktime($h, $m, $s, $mo, $d, $y);
            $localtime = localtime($timelocal);
            if ($localtime[8])
                $so += 1;
            $partial_hour_offset = 60 * abs($so - intval($so));
            $four_digit_offset = sprintf('%s%02d%02d', $so < 0 ? '-' : '+',
                                         abs($so), $partial_hour_offset);
            $ts = gmdate('YmdHis', strtotime("$y-$mo-$d $h:$m:$s $four_digit_offset"));
        }
        if (isset($args['format_name'])) {
            if ($format = $args['format_name']) {
                $tz = 'Z';
                if (!$args['utc']) {
                    $blog = $ctx->stash('blog');
                    if (!is_array($blog)) {
                        $blog = $ctx->mt->db->fetch_blog($blog);
                    }
                    $so = $blog['blog_server_offset'];
                    $partial_hour_offset = 60 * abs($so - intval($so));
                    if ($format == 'rfc822') {
                        $tz = sprintf("%s%02d%02d", $so < 0 ? '-' : '+',
                                  abs($so), $partial_hour_offset);
                    }
                    elseif ($format == 'iso8601') {
                        $tz = sprintf("%s%02d:%02d", $so < 0 ? '-' : '+',
                                  abs($so), $partial_hour_offset);
                    }
                }
                if ($format == 'rfc822') {
                    $args['format'] = '%a, %d %b %Y %H:%M:%S ' . $tz;
                    $args['language'] = 'en';
                }
                elseif ($format == 'iso8601') {
                    $args['format'] = '%Y-%m-%dT%H:%M:%S'. $tz;
                }
            }
        }
        if (!isset($args['format'])) $args['format'] = null;
        require_once("MTUtil.php");
        return format_ts($args['format'], $ts, $blog, isset($args['language']) ? $args['language'] : null);
    }

    function tag($tag, $args = array()) {
        $tag = preg_replace('/^mt:?/i', '', strtolower($tag));
        if ((array_key_exists('mt' . $tag, $this->conditionals)) || (preg_match('/^if/i', $tag) || preg_match('/^has/', $tag) || preg_match('/[a-z](header|footer|previous|next)$/i', $tag))) {
            list($hdlr) = $this->handler_for($tag);
            if (!$hdlr) {
                $fntag = 'smarty_block_mt' . $tag;
                if (!function_exists($fntag))
                    @include_once("block.mt$tag.php");
                if (function_exists($fntag))
                    $hdlr = $fntag;
            }
            if ($hdlr) {
                $hdlr($args, NULL, $this, $repeat = true);
                if ($repeat) {
                    $content = 'true';
                    $this->_tag_stack[] = array("mt$tag", $args);
                    $content = $hdlr($args, $content, $this, $repeat = false);
                    array_pop($this->_tag_stack);
                    return isset($content) && ($content === 'true');
                } else {
                    return false;
                }
            }
        } else {
            list($hdlr) = $this->handler_for("mt" . $tag);
            if (!$hdlr) {
                $fntag = 'smarty_function_mt'.$tag;
                if (!function_exists($fntag))
                    @include_once("function.mt$tag.php");
                if (function_exists($fntag))
                    $hdlr = $fntag;
            }
            if ($hdlr) {
                $this->_tag_stack[] = array("mt$tag", $args);
                $content = $hdlr($args, $this);
                foreach ($args as $k => $v) {
                    if (array_key_exists($k, $this->global_attr)) {
                        $fnmod = 'smarty_modifier_' . $k;
                        if (!function_exists($fnmod))
                            $this->load_modifier($k);
                        if (function_exists($fnmod))
                            $content = $fnmod($content, $v);
                    }
                }
                array_pop($this->_tag_stack);
                return $content;
            }
        }
        return $this->error("Tag &lt;mt$tag&gt; does not exist.");
    }

    function load_modifier($name) {
        $params = array('plugins' => array(array('modifier', $name, null, null, false)));
        smarty_core_load_plugins($params, $this);
        return true;
    }

    function register_tag_handler($tag, $fn, $type) {
        if (substr($tag, 0, 2) != 'mt') {
            $tag = 'mt' . $tag;
        }
        if ($type == 'block')
            $this->register_block($tag, $fn);
        elseif ($type == 'function')
            $this->register_function($tag, $fn);
        $old_handler = $this->_handlers[$tag];
        $this->_handlers[$tag] = array( $fn, $type );
        if ($old_handler) {
            $fn = $old_handler[0];
        } else {
            if ($type == 'block')
                $fn = create_function('$args, $content, &$ctx, &$repeat', 'if (!isset($content)) @include_once "block.' . $tag . '.php"; if (function_exists("smarty_block_' . $tag . '")) { return smarty_block_' . $tag . '($args, $content, $ctx, $repeat); } $repeat = false; return "";');
            elseif ($type == 'function') {
                $fn = create_function('$args, &$ctx', '@include_once "function.' . $tag . '.php"; if (function_exists("smarty_function_' . $tag . '")) { return smarty_function_' . $tag . '($args, $ctx); } return "";');
            }
        }
        return $fn;
    }
    function add_container_tag($tag, $fn = null) {
        return $this->register_tag_handler($tag, $fn, 'block');
    }
    function add_tag($tag, $fn) {
        return $this->register_tag_handler($tag, $fn, 'function');
    }
    function handler_for($tag) {
        if (isset($this->_handlers[$tag]))
            return $this->_handlers[$tag];
        else
            return null;
    }

    function count_format($count, $args) {
        $phrase = '';
        if ($count == 0) {
            $phrase = array_key_exists('none', $args) ? $args['none'] :
                (array_key_exists('plural', $args) ? $args['plural'] : '');
        } elseif ($count == 1) {
            $phrase = array_key_exists('singular', $args) ? $args['singular'] : '';
        } elseif ($count > 1) {
            $phrase = array_key_exists('plural', $args) ? $args['plural'] : '';
        }
        if ($phrase == '')
            return $count;

        // \# of entries: #  --> # of entries: 10
        $phrase = preg_replace('/(?<!\\\\)#/', $count, $phrase);
        $phrase = preg_replace('/\\\\#/', '#', $phrase);

        return $phrase;
    }
}
