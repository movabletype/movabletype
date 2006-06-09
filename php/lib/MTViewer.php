<?php
# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

include_once("Smarty.class.php");
class MTViewer extends Smarty {
    var $varstack = array();
    var $__stash;
    var $mt;
    var $last_ts = 0;
    var $id;

    var $conditionals = array(
        'MTEntryPrevious' => 1,
        'MTEntryNext' => 1,
        'MTDateHeader' => 1,
        'MTDateFooter' => 1,
        'MTEntriesHeader' => 1,
        'MTEntriesFooter' => 1,
        'MTCalendarWeekHeader' => 1,
        'MTCalendarWeekFooter' => 1,
        'MTParentCategory' => 1,
        'MTSubCatIsFirst' => 1,
        'MTSubCatIsLast' => 1,
        'MTHasSubCategories' => 1,
        'MTHasNoSubCategories' => 1,
        'MTHasParentCategory' => 1,
        'MTHasNoParentCategory' => 1,
        'MTTopLevelParent' => 1,
    );
    var $sanitized = array(
        'MTCommentAuthor' => 1,
        'MTCommentEmail' => 1,
        'MTCommentURL' => 1,
        'MTCommentBody' => 1,
        'MTPingTitle' => 1,
        'MTPingURL' => 1,
        'MTPingExcerpt' => 1,
        'MTPingBlogName' => 1,
    );
    var $global_attr = array(
        'filters' => 1,
        'decode_xml' => 1,
        'remove_html' => 1,
        'dirify' => 1,
        'sanitize' => 1,
        'encode_xml' => 1,
        'encode_js' => 1,
        'encode_php' => 1,
        'encode_html' => 1,
        'decode_html' => 1,
        'encode_url' => 1,
        'upper_case' => 1,
        'lower_case' => 1,
        'space_pad' => 1,
        'zero_pad' => 1,
        'sprintf' => 1,
        'trim_to' => 1,
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
        'MTSubCategories' => 1,
        'MTTopLevelCategories' => 1,
    );

    function MTViewer(&$mt) {
        // prevents an unknown index error within Smarty.class.php
        $this->id = md5(uniqid('MTViewer',true));
        $_COOKIE['SMARTY_DEBUG'] = 0;
        $GLOBALS['HTTP_COOKIE_VARS']['SMARTY_DEBUG'] = 0;
        $this->Smarty();
        $this->mt =& $mt;
        $this->__stash =& $this->_tpl_vars;
        $this->left_delimiter = "{{";
        $this->right_delimiter = "}}";
        $this->load_filter('pre', 'mt_to_smarty');
        $this->register_block('MTDynamic', array(&$this, 'smarty_block_dynamic'),
                              false);
        $this->register_block('MTElse', array(&$this, 'smarty_block_else'));
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
        if(isset($value))
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
            $ctx->localize(array('conditional','else_content'));
            if ($cond_tag == '1' or $cond_tag == '0') {
                $ctx->stash('conditional', $cond_tag);
            } else {
                $ctx->stash('conditional', $ctx->stash($cond_tag));
            }
            $ctx->stash('else_content', null);
        } else {
            if (!$ctx->stash('conditional')) {
                $content = $ctx->stash('else_content');
            }
            $ctx->restore(array('conditional','else_content'));
        }
        return $content;
    }

    function smarty_block_else($args, $content, &$ctx, &$repeat) {
        if (!isset($content)) {
            $ctx->stash('else_content', '');
            if ($ctx->stash('conditional')) {
                $repeat = false;
            }
        } else {
            $else_content = $ctx->stash('else_content');
            $else_content .= $content;
            $ctx->stash('else_content', $else_content);
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
            $partial_hour_offset = 60 * abs($so - intval($so));
            $four_digit_offset = sprintf('%s%02d%02d', $so < 0 ? '-' : '+',
                                         abs($so), $partial_hour_offset);
            $ts = gmdate('YmdHis', strtotime("$y-$mo-$d $h:$m:$s $four_digit_offset"));
        }
        if (isset($args['format_name'])) {
            $format = $args['format_name'];
            if ($format == 'rfc822') {
                $blog = $ctx->stash('blog');
                if (!is_array($blog)) {
                    $blog = $ctx->mt->db->fetch_blog($blog);
                }
                $so = $blog['blog_server_offset'];
                $partial_hour_offset = 60 * abs($so - intval($so));
                $tz = sprintf("%s%02d%02d", $so < 0 ? '-' : '+',
                              abs($so), $partial_hour_offset);
                $args['format'] = '%a, %d %b %Y %H:%M:%S ' . $tz;
                $args['language'] = 'en';
            }
        }
        if (!isset($args['format'])) $args['format'] = null;
        require_once("MTUtil.php");
        return format_ts($args['format'], $ts, $blog, isset($args['language']) ? $args['language'] : null);
    }

    function tag($tag, $args = array()) {
        $tag = preg_replace('/^MT/', '', $tag);
        if ((array_key_exists('MT' . $tag, $this->conditionals)) || (preg_match('/^If/', $tag) || preg_match('/[a-z]If[A-Z]/', $tag))) {
            @require_once("block.MT$tag.php");
            $fntag = 'smarty_block_MT' . $tag;
            if (function_exists($fntag)) {
                $fntag($args, NULL, $this, $repeat = true);
                if ($repeat) {
                    $content = 'true';
                    $this->_tag_stack[] = array("MT$tag", $args);
                    $content = $fntag($args, $content, $this, $repeat = false);
                    array_pop($this->_tag_stack);
                    return isset($content) && ($content === 'true');
                } else {
                    return false;
                }
            }
        } else {
            @require_once("function.MT$tag.php");
            $fntag = 'smarty_function_MT'.$tag;
            if (function_exists($fntag)) {
                $this->_tag_stack[] = array("MT$tag", $args);
                $content = $fntag($args, $this);
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
        return $this->error("Tag &lt;MT$tag&gt; does not exist.");
    }

    function load_modifier($name) {
        $params = array('plugins' => array(array('modifier', $name, null, null, false)));
        smarty_core_load_plugins($params, $this);
        return true;
    }
}
?>