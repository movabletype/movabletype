<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

include_once("Smarty.class.php");
class MTViewer extends Smarty {
    var $varstack = array();
    var $stash_var_stack = array();
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
        'mtwebsitehasblog' => 1,
        'mtarchivelistfooter' => 1,
        'mtarchivelistheader' => 1,
        'mtassetisfirstinrow' => 1,
        'mtassetislastinrow' => 1,
        'mtassetsfooter' => 1,
        'mtassetsheader' => 1,
        'mtcalendarweekfooter' => 1,
        'mtcalendarweekheader' => 1,
        'mtcommentsfooter' => 1,
        'mtcommentsheader' => 1,
        'mtdatefooter' => 1,
        'mtdateheader' => 1,
        'mtentriesfooter' => 1,
        'mtentriesheader' => 1,
        'mthasnoparentcategory' => 1,
        'mthasnosubcategories' => 1,
        'mthasparentcategory' => 1,
        'mthassubcategories' => 1,
        'mtpingsfooter' => 1,
        'mtpingsheader' => 1,
        'mtsubcatisfirst' => 1,
        'mtsubcatislast' => 1,
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
        'numify' => 1,
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
        'mtsubfolders' => 1,
        'mttoplevelfolders' => 1,
        'mtcommentreplies' => 1,
        'mtsetvartemplate' => 1,
        'mtincludeblock' => 1,
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
            return $this->register_tag_handler($name, $code, 'block');
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

    function &stash($name,$value=null) {
        if(isset($this->__stash[$name]))
            $old_val =& $this->__stash[$name];
        else
            $old_val = null;
        if(func_num_args() > 1) {
            $copy = $value;
            $this->__stash[$name] =& $copy;
        }
        return $old_val;
    }

    function localize($vars, $stash_vars_vars = array()) {
        if (! empty($vars) && is_array($vars[0])) {
            list($vars, $stash_vars_vars) = $vars;
        }

        foreach ($vars as $v) {
            if (!isset($this->varstack[$v])) $this->varstack[$v] = array();
            $this->varstack[$v][] = isset($this->__stash[$v]) ? $this->__stash[$v] : null;
        }
        foreach ($stash_vars_vars as $v) {
            if (!isset($this->stash_var_stack[$v])) $this->stash_var_stack[$v] = array();
            $this->stash_var_stack[$v][] = isset($this->__stash['vars'][$v]) ? $this->__stash['vars'][$v] : null;
        }
    }

    function restore($vars, $stash_vars_vars = array()) {
        if (! empty($vars) && is_array($vars[0])) {
            list($vars, $stash_vars_vars) = $vars;
        }

        foreach ($vars as $v) {
            $this->__stash[$v] = (isset($this->varstack[$v]) && count($this->varstack[$v]) > 0) ? array_pop($this->varstack[$v]) : null;
        }
        foreach ($stash_vars_vars as $v) {
            $this->__stash['vars'][$v] = (isset($this->stash_var_stack[$v]) && count($this->stash_var_stack[$v]) > 0) ? array_pop($this->stash_var_stack[$v]) : null;
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
                $ctx->localize(array('conditional', 'else_content', 'elseif_content', 'elseif_conditional', '__cond_name__', '__cond_value__', '__cond_tag__'));
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
            $stash =& $ctx->__stash;
            if ( array_key_exists('__cond_tag__', $stash) ) {
                $tag = $stash['__cond_tag__'];
                if ( isset($tag) && $tag )
                    $args['tag'] = $tag;
            }
            else if ( array_key_exists('__cond_name__', $stash) ) {
                $name = $stash['__cond_name__'];
                if ( isset($name) && $name )
                    $args['name'] = $name;
            }
            if ( array_key_exists('__cond_value__', $stash) ) {
                $value = $stash['__cond_value__'];
                if ( isset($value) && $value )
                    $args['value'] = $value;
            }
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

    var $date_languages = array(
        'de' => array(
            'moments from now' => 'in einem Augenblick',
            '[quant,_1,hour,hours] from now' => 'in [quant,_1,Stunde,Stunden]',
            '[quant,_1,minute,minutes] from now' => 'in [quant,_1,Minute,Minuten]',
            '[quant,_1,day,days] from now' => 'in [quant,_1,Tag,Tagen]',
            'less than 1 minute from now' => 'in weniger als 1 Minute',
            'less than 1 minute ago' => 'vor weniger als 1 Minute',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'in [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'vor [quant,_1,Stunde,Stunden] [quant,_1,Minute,Minuten]',
            '[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'in [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
            '[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'vor [quant,_1,Tag,Tagen] [quant,_1,Stunde,Stunden]',
            '[quant,_1,second,seconds] from now' => 'in [quant,_1,Sekunde,Sekunden]',
            '[quant,_1,second,seconds]' => '[quant,_1,Sekunde,Sekunden]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'in [quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,Minute,Minuten] und [quant,_2,Sekunde,Sekunden]',
            '[quant,_1,minute,minutes]' => '[quant,_1,Minute,Minuten]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,Stunde,Stunden] und [quant,_2,Minute,Minuten]',
            '[quant,_1,hour,hours]' => '[quant,_1,Stunde,Stunden]',
            '[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,Tag,Tage] und [quant,_2,Stunde,Stunden]',
            '[quant,_1,day,days]' => '[quant,_1,Tag,Tage]',
            'moments ago' => 'vor einem Augenblick',
            '[quant,_1,hour,hours] ago' => 'vor [quant,_1,Stunde,Stunden]',
            '[quant,_1,minute,minutes] ago' => 'vor [quant,_1,Minute,Minuten]',
            '[quant,_1,day,days] ago' => 'vor [quant,_1,Tag,Tagen]',
        ),
        'es' => array(
            'moments from now' => 'dentro de unos momentos',
            '[quant,_1,hour,hours] from now' => 'dentro de [quant,_1,hora,horas]',
            '[quant,_1,minute,minutes] from now' => 'dentro de [quant,_1,minuto,minutos]',
            '[quant,_1,day,days] from now' => 'dentro de [quant,_1,día,días]',
            'less than 1 minute from now' => 'dentro de menos de un minuto',
            'less than 1 minute ago' => 'hace menos de un minuto',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dentro de [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'hace [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
            '[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dentro de [quant,_1,día,días], [quant,_2,hora,horas]',
            '[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'hace [quant,_1,día,días], [quant,_2,hora,horas]',
            '[quant,_1,second,seconds] from now' => 'dentro de [quant,_1,segundo,segundos]',
            '[quant,_1,second,seconds]' => '[quant,_1,segundo,segundos]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dentro de [quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
            '[quant,_1,minute,minutes]' => '[quant,_1,minuto,minutos]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,hora,horas], [quant,_2,minuto,minutos]',
            '[quant,_1,hour,hours]' => '[quant,_1,hora,horas]',
            '[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,día,días], [quant,_2,hora,horas]',
            '[quant,_1,day,days]' => '[quant,_1,día,días]',
            'moments ago' => 'hace unos momentos',
            '[quant,_1,hour,hours] ago' => 'hace [quant,_1,hora,horas]',
            '[quant,_1,minute,minutes] ago' => 'hace [quant,_1,minute,minutes]',
            '[quant,_1,day,days] ago' => 'hace [quant,_1,día,días]',
        ),
        'fr' => array(
            'moments from now' => 'maintenant',
            '[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
            '[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
            '[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
            'less than 1 minute from now' => 'moins d\'une minute à partir de maintenant',
            'less than 1 minute ago' => 'il y a moins d\'une minute',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dans [quant,_1,heure,heures], [quant,_2,minute,minutes]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'il y a [quant,_1,heure,heures], [quant,_2,minute,minutes]',
            '[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dans [quant,_1,jour,jours], [quant,_2,heure,heures]',
            '[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'il y a [quant,_1,jour,jours], [quant,_2,heure,heures]',
            '[quant,_1,second,seconds] from now' => 'dans [quant,_1,seconde,secondes]',
            '[quant,_1,second,seconds]' => '[quant,_1,seconde,secondes]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dans [quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
            '[quant,_1,minute,minutes]' => '[quant,_1,minute,minutes]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,heure,heures], [quant,_2,minute,minutes]',
            '[quant,_1,hour,hours]' => '[quant,_1,heure,heures]',
            '[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,jour,jours], [quant,_2,heure,heures]',
            '[quant,_1,day,days]' => '[quant,_1,jour,jours]',
            'moments ago' => 'il y a quelques instants',
            '[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
            '[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
            '[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
        ),
        'ja' => array(
            'moments from now' => '今から',
            '[quant,_1,hour,hours] from now' => '[quant,_1,時間,時間]後',
            '[quant,_1,minute,minutes] from now' => '[quant,_1,分,分]後',
            '[quant,_1,day,days] from now' => '[quant,_1,日,日]後',
            'less than 1 minute from now' => '1分後以内',
            'less than 1 minute ago' => '1分以内',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => '[quant,_1,時間,時間], [quant,_2,分,分]後',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,時間,時間], [quant,_2,分,分]前',
            '[quant,_1,day,days], [quant,_2,hour,hours] from now' => '[quant,_1,日,日], [quant,_2,時間,時間]後',
            '[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,日,日], [quant,_2,時間,時間]前',
            '[quant,_1,second,seconds] from now' => '[quant,_1,秒,秒]後',
            '[quant,_1,second,seconds]' => '[quant,_1,秒,秒]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => '[quant,_1,分,分], [quant,_2,秒,秒]後',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,分,分], [quant,_2,秒,秒]',
            '[quant,_1,minute,minutes]' => '[quant,_1,分,分]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,時間,時間], [quant,_2,分,分]',
            '[quant,_1,hour,hours]' => '[quant,_1,時間,時間]',
            '[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,日,日], [quant,_2,時間,時間]',
            'moments ago' => '直前',
            '[quant,_1,day,days]' => '[quant,_1,日,日]',
            '[quant,_1,hour,hours] ago' => '[quant,_1,時間,時間]前',
            '[quant,_1,minute,minutes] ago' => '[quant,_1,分,分]前',
            '[quant,_1,day,days] ago' => '[quant,_1,日,日]前',
        ),
        'nl' => array(
            'moments from now' => 'ogenblikken in de toekomst',
            '[quant,_1,hour,hours] from now' => 'over [quant,_1,uur,uur]',
            '[quant,_1,minute,minutes] from now' => 'over [quant,_1,minuut,minuten]',
            '[quant,_1,day,days] from now' => 'over [quant,_1,dag,dagen]',
            'less than 1 minute from now' => 'binnen minder dan 1 minuut',
            'less than 1 minute ago' => 'minder dan 1 minuut geleden',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'over [quant,_1,uur,uur] en [quant,_2,minuut,minuten]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,uur,uur], [quant,_2,minuut,minuten] geleden',
            '[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'over [quant,_1,dag,dagen] en [quant,_2,uur,uur]',
            '[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,dag,dagen] en [quant,_2,uur,uur] geleden',
            '[quant,_1,second,seconds] from now' => 'over [quant,_1,seconde,seconden]',
            '[quant,_1,second,seconds]' => '[quant,_1,seconde,seconden]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'over [quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
            '[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuut,minuten], [quant,_2,seconde,seconden]',
            '[quant,_1,minute,minutes]' => '[quant,_1,minuut,minuten]',
            '[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,uur,uren], [quant,_2,minuut,minuten]',
            '[quant,_1,hour,hours]' => '[quant,_1,uur,uren]',
            '[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,dag,dagen], [quant,_2,uur,uren]',
            '[quant,_1,day,days]' => '[quant,_1,dag,dagen]',
            'moments ago' => 'ogenblikken geleden',
            '[quant,_1,hour,hours] ago' => '[quant,_1,uur,uur] geleden',
            '[quant,_1,minute,minutes] ago' => '[quant,_1,minuut,minuten] geleden',
            '[quant,_1,day,days] ago' => '[quant,_1,dag,dagen] geleden',
        ),
    );

    function rd_trans($blog, $phrase, $params) {
        $mt = $this->mt;
        $lang = (
              $blog && $blog->blog_date_language
            ? $blog->blog_date_language
            : $mt->config('DefaultLanguage')
        );
        $lang = substr(strtolower($lang), 0, 2);
        if ($lang === 'jp') {
            $lang = 'ja';
        }
        $lang_ar = $this->date_languages[$lang];
        if ($lang_ar) {
            if (array_key_exists($phrase, $lang_ar)) {
                $phrase = $lang_ar[$phrase];
            }
        }
        return $mt->translate($phrase, $params);
    }

    function relative_date($ts1, $ts2, $style, $blog) {
        // $ts1 and $ts2 (now) should be timestamps
        // $style is a number 1..3, or false, which will default to 1
        $style or $style = 1;

        $future = 0;
        $delta = $ts2 - $ts1;

        if ( ($delta >= 0) && ($delta <= 60) ) { # last minute
            return 
                $style == 1 ? $this->rd_trans($blog, "moments ago") :
                ( $style == 2 ? $this->rd_trans($blog, "less than 1 minute ago") :
                $this->rd_trans($blog,  "[quant,_1,second,seconds]", $delta ) );
        }
        if ( ($delta < 0) && ($delta >= -60) ) { # next minute
            return 
                $style == 1 ? $this->rd_trans($blog, "moments from now") :
                ( $style == 2 ? $this->rd_trans($blog, "less than 1 minute from now") :
                $this->rd_trans($blog,  "[quant,_1,second,seconds] from now", -$delta ) );
        }
        if ( ($delta > 60) && ($delta <= 3600) ) { # last hour
            $min = (int) ( $delta / 60 );
            $sec = $delta % 60;
            return 
                $style == 1 ?   $this->rd_trans($blog, "[quant,_1,minute,minutes] ago", $min) :
                ( $style == 2 ? $this->rd_trans($blog, "[quant,_1,minute,minutes] ago", $min) :
                ( $sec === 0 ?  $this->rd_trans($blog, "[quant,_1,minute,minutes]", $min ) :
                $this->rd_trans($blog,  "[quant,_1,minute,minutes], [quant,_2,second,seconds]", array($min, $sec) ) ) );
        }
        if ( ($delta < -60) && ($delta >= -3600) ) { # next hour
            $delta = -$delta;
            $min = (int) ( $delta / 60 );
            $sec = $delta % 60;
            return 
                $style == 1 ?   $this->rd_trans($blog, "[quant,_1,minute,minutes] from now", $min) :
                ( $style == 2 ? $this->rd_trans($blog, "[quant,_1,minute,minutes] from now", $min) :
                ( $sec === 0 ?  $this->rd_trans($blog, "[quant,_1,minute,minutes] from now", $min ) :
                $this->rd_trans($blog,  "[quant,_1,minute,minutes], [quant,_2,second,seconds] from now", array($min, $sec) ) ) );
        }
        if ( ($delta > 3600) && ($delta <= 86400) ) { # last day
            $hours = (int) ( $delta / 3600 );
            $min = (int) ( ( $delta % 3600 ) / 60 );
            return 
                $style == 1 ? $this->rd_trans($blog, "[quant,_1,hour,hours] ago", $hours) :
                ( $style == 2 ? ( 
                    $min === 0 ? $this->rd_trans($blog, "[quant,_1,hour,hours] ago", $hours) : 
                    $this->rd_trans($blog, "[quant,_1,hour,hours], [quant,_2,minute,minutes] ago", array($hours, $min) ) ) :
                ( $min === 0 ? $this->rd_trans($blog, "[quant,_1,hour,hours]", $hours) :
                $this->rd_trans($blog, "[quant,_1,hour,hours], [quant,_2,minute,minutes]", array($hours, $min) ) ) );
        }
        if ( ($delta < -3600) && ($delta >= -86400) ) { # next day
            $delta = -$delta;
            $hours = (int) ( $delta / 3600 );
            $min = (int) ( ( $delta % 3600 ) / 60 );
            return 
                $style == 1 ? $this->rd_trans($blog, "[quant,_1,hour,hours] from now", $hours) :
                ( $style == 2 ? ( 
                    $min === 0 ? $this->rd_trans($blog, "[quant,_1,hour,hours] from now", $hours) : 
                    $this->rd_trans($blog, "[quant,_1,hour,hours], [quant,_2,minute,minutes] from now", array($hours, $min) ) ) :
                ( $min === 0 ? $this->rd_trans($blog, "[quant,_1,hour,hours] from now", $hours) :
                $this->rd_trans($blog, "[quant,_1,hour,hours], [quant,_2,minute,minutes] from now", array($hours, $min) ) ) );
        }
        if ( ($delta > 86400) && ($delta <= 604800) ) { # last week
            $days = (int) ( $delta / 86400 );
            $hours = (int) ( ( $delta % 86400 ) / 3600 );
            return 
                $style == 1 ? $this->rd_trans($blog, "[quant,_1,day,days] ago", $days) :
                ( $style == 2 ? ( 
                    $hours === 0 ? $this->rd_trans($blog, "[quant,_1,day,days] ago", $days) : 
                    $this->rd_trans($blog, "[quant,_1,day,days], [quant,_2,hour,hours] ago", array($days, $hours) ) ) :
                ( $hours === 0 ? $this->rd_trans($blog, "[quant,_1,day,days]", $days) :
                $this->rd_trans($blog, "[quant,_1,day,days], [quant,_2,hour,hours]", array($days, $hours) ) ) );
        }
        if ( ($delta < -86400) && ($delta >= -604800) ) { # next week
            $delta = -$delta;
            $days = (int) ( $delta / 86400 );
            $hours = (int) ( ( $delta % 86400 ) / 3600 );
            return 
                $style == 1 ? $this->rd_trans($blog, "[quant,_1,day,days] from now", $days) :
                ( $style == 2 ? ( 
                    $hours === 0 ? $this->rd_trans($blog, "[quant,_1,day,days] from now", $days) : 
                    $this->rd_trans($blog, "[quant,_1,day,days], [quant,_2,hour,hours] from now", array($days, $hours) ) ) :
                ( $hours === 0 ? $this->rd_trans($blog, "[quant,_1,day,days] from now", $days) :
                $this->rd_trans($blog, "[quant,_1,day,days], [quant,_2,hour,hours] from now", array($days, $hours) ) ) );
        }
        if ( $style > 1 ) return '';
        $ts1_d = getdate($ts1);
        $ts2_d = getdate($ts2);
        if ( $ts1_d['year'] === $ts2_d['year'] ) {
            $fmt = "%b %e";
        }
        else {
            $fmt = "%b %e %Y";
        }
        return array('format' => $fmt);
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
            if (!is_object($blog)) {
                $blog = $ctx->mt->db()->fetch_blog($blog);
            }
            preg_match('/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/', $ts, $matches);
            list($all, $y, $mo, $d, $h, $m, $s) = $matches;
            $so = $blog->blog_server_offset;
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
                    if (!is_object($blog)) {
                        $blog = $ctx->mt->db()->fetch_blog($blog);
                    }
                    $so = $blog->blog_server_offset;
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
        $fds = format_ts($args['format'], $ts, $blog, isset($args['language']) ? $args['language'] : null);
        if (isset($args['relative'])) {
            if ($args['relative'] == 'js') {
                preg_match('/(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/', $ts, $match);
                list($xx, $y, $mo, $d, $h, $m, $s) = $match;
                $mo--;
                $js = <<<EOT
<script type="text/javascript">
/* <![CDATA[ */
document.write(mtRelativeDate(new Date($y,$mo,$d,$h,$m,$s), '$fds'));
/* ]]> */
</script><noscript>$fds</noscript>
EOT;
                return $js;
            }
            else {
                preg_match('/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/', $ts, $matches);
                list($all, $y, $mo, $d, $h, $m, $s) = $matches;
                $unix_ts = offset_time(gmmktime($h, $m, $s, $mo, $d, $y), $blog, '-');
                $now_ts = time();
                $relative = $this->relative_date($unix_ts, $now_ts, $args['relative'], $blog);
                if (is_array($relative)) {
                    return format_ts($relate['format'], $ts, $blog, isset($args['language']) ? $args['language'] : null);
                }
                elseif ($relative) {
                    return $relative;
                }
            }
        }
        return $fds;
    }

    function tag($tag, $args = array()) {
        $tag = preg_replace('/^mt:?/i', '', strtolower($tag));
        if ((array_key_exists('mt' . $tag, $this->conditionals)) || (preg_match('/^if/i', $tag) || preg_match('/^has/', $tag) || preg_match('/[a-z](header|footer|previous|next)$/i', $tag))) {
            list($hdlr) = $this->handler_for("mt" . $tag);
            if (!$hdlr) {
                $fntag = 'smarty_block_mt' . $tag;
                if (!function_exists($fntag))
                    @include_once("block.mt$tag.php");
                if (function_exists($fntag))
                    $hdlr = $fntag;
            }
            if ($hdlr) {
                $this->_tag_stack[] = array("mt$tag", $args);
                $repeat = true;
                $hdlr($args, NULL, $this, $repeat);
                if ($repeat) {
                    $content = 'true';
                    $repeat = false;
                    $content = $hdlr($args, $content, $this, $repeat);
                    $result = isset($content) && ($content === 'true');
                } else {
                    $result = false;
                }
                array_pop($this->_tag_stack);
                return $result;
            }
        } else {
            list($hdlr, $type) = $this->handler_for("mt" . $tag);
            if ($hdlr) $block_tag = $type == 'block';
            if (!$hdlr) {
                $fntag = 'smarty_function_mt'.$tag;
                if (!function_exists($fntag))
                    if (file_exists($this->mt->config('phplibdir')."/function.mt$tag.php"))
                        @include_once("function.mt$tag.php");
                if (function_exists($fntag))
                    $hdlr = $fntag;
            }
            if (!$hdlr) { // try block tags
                $fntag = 'smarty_block_mt'.$tag;
                if (!function_exists($fntag))
                    if (file_exists($this->mt->config('phplibdir')."/block.mt$tag.php"))
                        @include_once("block.mt$tag.php");
                if (function_exists($fntag)) {
                    $hdlr = $fntag;
                    $block_tag = true;
                }
            }
            if ($hdlr) {
                if ($block_tag) {
                    // block tag is true if it runs atleast one iteration
                    // So we call it twice - one for init, and one iteration
                    // If the tag still not finished, we clean whatever 
                    // it localized from the stash
                    $this->_tag_stack[] = array("mt$tag", $args);
                    $old_varstack =& $this->varstack;
                    $new_varstack = array();
                    $this->varstack =& $new_varstack;
                    $repeat = true;
                    $hdlr($args, NULL, $this, $repeat);
                    if ($repeat) {
                        $content = 'true';
                        $repeat = false;
                        $content = $hdlr($args, $content, $this, $repeat);
                        $result = isset($content) && ($content === 'true');
                    }
                    else {
                        $result = false;
                    }
                    if ($repeat && count($new_varstack)) {
                        $this->restore(array_keys($new_varstack));
                    }
                    $this->varstack =& $old_varstack;
                    array_pop($this->_tag_stack);
                    return $result;
                }
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
        if (! empty($args)) {
            if ($count == 0) {
                $phrase = array_key_exists('none', $args) ? $args['none'] :
                    (array_key_exists('plural', $args) ? $args['plural'] : '');
            } elseif ($count == 1) {
                $phrase = array_key_exists('singular', $args) ? $args['singular'] : '';
            } elseif ($count > 1) {
                $phrase = array_key_exists('plural', $args) ? $args['plural'] : '';
            }
        }
        if ($phrase == '')
            return $count;

        // \# of entries: #  --> # of entries: 10
        $phrase = preg_replace('/(?<!\\\\)#/', $count, $phrase);
        $phrase = preg_replace('/\\\\#/', '#', $phrase);

        return $phrase;
    }
}
?>
