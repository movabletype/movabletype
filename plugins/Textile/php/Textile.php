<?php
# $Id$

class Textile {

	var $filers;
	var $charset;
	var $char_encoding;
	var $do_quotes;
	var $trim_spaces;
	var $preserve_spaces;
	var $head_offset;
	var $css;
	var $css_mode;
	var $macros;
	var $flavor;
	var $urlre;
	var $punct;
	var $valignre;
	var $tblalignre;
	var $halignre;
	var $alignre;
	var $imgalignre;
	var $clstypadre;
	var $clstyre;
	var $clstyfiltre;
	var $codere;
	var $codere2;
	var $blocktags;
	var $qtags;
	var $qtag;

	function __construct($opt = array()) {
		$this->filters = $opt['filters'] or array();
		$this->charset = $opt['charset'] or 'iso-8859-1';
		$this->char_encoding = array_key_exists('char_encoding',$opt) ? $opt['char_encoding'] : 1;
		$this->do_quotes = array_key_exists('do_quotes',$opt) ? $opt['do_quotes'] : 1;
		$this->trim_spaces = array_key_exists('trim_spaces',$opt) ? $opt['trim_spaces'] : 1;
		//$options{smarty_mode} = 1 unless exists $options{smarty_mode};
		$this->preserve_spaces = array_key_exists('preserve_spaces',$opt) ? $options['preserve_spaces'] : 0;
		$this->head_offset = array_key_exists('head_offset',$opt) ?  $options['head_offset'] : 0;

		if (array_key_exists('css',$opt))
			$this->set_css($opt['css']);
		$this->macros = array_key_exists('macros', $opt) ? $opt['macros'] : $this->default_macros();
		if (array_key_exists('flavor',$opt)) {
			$this->set_flavor($opt['flavor']);
		} else {
			$this->set_flavor('xhtml1/css');
		}
	
	
		# regular expression initialization
	
		# a URL discovery regex. This is from Mastering Regex from O'Reilly.
		# Some modifications by Brad Choate <brad@bradchoate.com>
		$this->urlre = '(?:
		(?=[a-zA-Z0-9.\/#])
		(?:
			(?:ftp|https?|telnet|nntp):\/\/(?:\w+(?::\w+)?@)?[-\w]+(?:\.\w[-\w]*)+
			|
			(?:mailto:)?[-\+\w]+\@[-\w]+(?:\.\w[-\w]*)+
			|
			(?i: [a-z0-9] (?:[-a-z0-9]*[a-z0-9])? \. )+
			(?-i: com\b
				| edu\b
				| biz\b
				| gov\b
				| in(?:t|fo)\b # .int or .info
				| mil\b
				| net\b
				| org\b
				| museum\b
				| aero\b
				| coop\b
				| name\b
				| pro\b
				| [a-z][a-z]\b # two-letter country codes
			)
		)?
		(?: : \d+ )?
		(?:
		 \/?
		 [^.\!,?;:"\'<>()\[\]{}\s\x7F-\xFF]*
		 (?:
			[.\!,?;:]+  [^.\!,?;:"\'<>()\[\]{}\s\x7F-\xFF]+
		 )*
		)?)';
	
		$this->punct = '(?:[\!"#\$%&\'()\*\+,\-\./:;<=>\?@\[\\\\\]\^_`{\|}\~])';
		$this->valignre = '(?:[\-^~])';
		$this->tblalignre = '(?:[<>=])';
		$this->halignre = '(?:<>|[<>=])';
		$this->alignre = "(?:".$this->valignre.'|<>'.$this->valignre.'?|'.$this->valignre.'?<>|'.$this->valignre.'?'.$this->halignre.'?|'.$this->halignre.'?'.$this->valignre.'?)(?!\w)';
		$this->imgalignre = '(?:[<>]|'.$this->valignre.'){1,2}';
	
		$this->clstypadre = '(?:
	  (?: \([A-Za-z0-9_\- \#]+\) )
	  |
	  (?: {
		     (?: \( [^)]+ \) | [^}] )+
		  } )
	  |
	  (?: \(+? (?![A-Za-z0-9_\-\#]) )
	  |
	  (?: \)+? )
	  |
	  (?: \[ [a-zA-Z\-]+? \] ) )';
	
		$this->clstyre = '(?:
	  (?: \([A-Za-z0-9_\- \#]+\) )
	  |
	  (?: {
		    [A-Za-z0-9_\-](?: \( [^)]+ \) | [^}] )+
		  } )
	  |
	  (?: \[ [a-zA-Z\-]+? \] ) )';
	
		$this->clstyfiltre = '(?:
	  (?: \([A-Za-z0-9_\- \#]+\) )
	  |
	  (?: {
		    [A-Za-z0-9_\-](?: \( [^)]+ \) | [^}] )+
		  } )
	  |
	  (?: \|[^\|]+\| )
	  |
	  (?: \(+?(?![A-Za-z0-9_\-\#]) )
	  |
	  (?: \)+ )
	  |
	  (?: \[ [a-zA-Z]+? \] ) )';
	
		$this->codere = "(?:
		(?:
		  [[{]
		  @						   # opening
		  (?: \[([A-Za-z0-9]+)\] )?	 # 1: language id
		  (.+?)					   # 2: code
		  @						   # closing
		  [\]}]
		)
		|
		(?:
		  (?: ^|(?<=[\s\(]) )
		  @						   # opening
		  (?: \[([A-Za-z0-9]+)\] )?	 # $3: language id
		  ([^\s].+?[^\s])			 # $4: code itself
		  @						   # closing
		  (?: $|(?=[[:punct:]]{1,2}|\s) )
		) )";
		# non-capturing version for tokenize
		$this->codere2 = "(?:
		(?:
		  [[{]
		  @						   # opening
		  (?: \[(?:[A-Za-z0-9]+)\] )?	 # 1: language id
		  (?:.+?)					   # 2: code
		  @						   # closing
		  [\]}]
		)
		|
		(?:
		  (?: ^|(?<=[\s\(]) )
		  @						   # opening
		  (?: \[(?:[A-Za-z0-9]+)\] )?	 # $3: language id
		  (?:[^\s].+?[^\s])			 # $4: code itself
		  @						   # closing
		  (?: $|(?=[[:punct:]]{1,2}|\s) )
		) )";
	
		$this->blocktags = "(?:
		<
		(?: (?: \/? (?: h[1-6]
		 | p
		 | pre
		 | div
		 | table
		 | t[rdh]
		 | [ou]l
		 | li
		 | block(?: quote | code )
		 | form
		 | input
		 | select
		 | option
		 | textarea
		 )
		[ >]
		)
		| !--
		) )";
        $this->qtag = array(
            '**' => 'b',
            '__' => 'i',
            '??' => 'cite',
            '*' => 'strong',
            '_' => 'em',
            '-' => 'del',
            '+' => 'ins',
            '++' => 'big',
            '--' => 'small',
            '~' => 'sub'
        );
		$this->qtags = array(
			array('**', 'b',	  '(?<!\*)\*\*(?!\*)', '\*'),
			array('__', 'i',	  '(?<!_)__(?!_)', '_'),
			array('??', 'cite',   '\?\?(?!\?)', '\?'),
			array('*',  'strong', '(?<!\*)\*(?!\*)', '\*'),
			array('_',  'em',	 '(?<!_)_(?!_)', '_'),
			array('-',  'del',	'(?<!\-)\-(?!\-)', '-'),
			array('+',  'ins',	'(?<!\+)\+(?!\+)', '\+'),
			array('++', 'big',	'(?<!\+)\+\+(?!\+)', '\+\+'),
			array('--', 'small',  '(?<!\-)\-\-(?!\-)', '\-\-'),
			array('~',  'sub',	'(?<!\~)\~(?![\\\\\/~])', '\~')
		);
	
	}
	
	# getter/setter methods...
	
	function set($opt, $value) {
		if (is_array($opt)) {
			foreach ($opt as $key => $val) {
				$this->set($key, $val);
			}
		} else {
			# the following options have special set methods
			# that activate upon setting:
			if ($opt == 'charset') {
				$this->set_charset($value);
			} elseif ($opt == 'css') {
				$this->set_css($value);
			} elseif ($opt == 'flavor') {
				$this->set_flavor($value);
			} else {
				$this->$opt = $value;
			}
		}
	}
	
	function get($opt) {
		return $this->$opt;
	}
	
	function set_flavor($flavor) {
		$this->flavor = $flavor;
		if (preg_match('/^xhtml(\d)?(\D|$)/',$flavor,$matches)) {
			if ($matches[1] == '2') {
				$this->_line_open = '<l>';
				$this->_line_close = '</l>';
				$this->_blockcode_open = '<blockcode>';
				$this->_blockcode_close = '</blockcode>';
				$this->css_mode = 1;
			} else {
				# xhtml 1.x
				$this->_line_open = '';
				$this->_line_close = '<br />';
				$this->_blockcode_open = '<pre><code>';
				$this->_blockcode_close = '</code></pre>';
				$this->css_mode = 1;
			}
		} elseif (preg_match('/^html/', $flavor)) {
			$this->_line_open = '';
			$this->_line_close = '<br>';
			$this->_blockcode_open = '<pre><code>';
			$this->_blockcode_close = '</code></pre>';
			$this->css_mode = preg_match('/\/css/',$flavor);
		}
		if ($this->css_mode && !$this->css)
			$this->_css_defaults();
	}
	
	function set_css($css) {
		if (is_array($css)) {
			$this->css = $css;
			$this->css_mode = 1;
		} else {
			$this->css_mode = $css;
			if ($css && !$this->css)
				$this->_css_defaults();
		}
	}
	
	function set_charset($charset) {
		$this->charset = $charset;
		if (preg_match('/^utf-?8$/i',$charset)) {
			$this->char_encoding = 0;
		} else {
			$this->char_encoding = 1;
		}
	}
	
	# end of getter/setter methods

    function _replace_block($matches) {
        return $matches[1] . "\n\n"
            . $this->_repl($this->format_block(array('text' => $matches[2])))
            . "\n\n".$matches[3];
    }
    function _replace_inline_block($matches) {
        return $this->_repl($this->format_block(array('text' => $matches[2], 'inline' => 1, 'pre' => $matches[1], 'post' => $matches[3])));
    }
    function _replace_simple($matches) {
        return $this->_repl($matches[1]);
    }
    function _replace_pre($matches) {
        return "\n\n"
            .$this->_repl($matches[1].$this->encode_html($matches[2], 1).$matches[3])
            ."\n\n";
    }
    function _replace_pre_oneline($matches) {
        return $this->_repl($matches[1].$this->encode_html($matches[2], 1).$matches[3]);
    }
    function _replace_code($matches) {
		return $this->_repl($this->format_code(array('text' => $matches[2].$matches[4], 'lang' => $matches[1].$matches[3])));
    }
    function _save_link($matches) {
		$this->links[$matches[1]] = array('url' => $matches[3],
		    'title' => $matches[2]);
		return $matches[4];
    }
    function _replace_image($matches) {
		return $this->_repl($this->format_image(array('pre' => $matches[1], 'src' => $matches[5], 'align' => $matches[2].$matches[4], 'extra' => $matches[6], 'url' => $matches[7], 'clsty' => $matches[3], 'post' => $matches[8])));
    }
    function _replace_span($matches) {
		return $this->_repl($this->format_span(array('pre' => $matches[1], 'text' => $matches[5], 'align' => $matches[2].$matches[4], 'cite' => $matches[6], 'clsty' => $matches[3], 'post' => $matches[7])));
    }
    function _replace_link($matches) {
		return $this->_repl($this->format_link(array('text' => $matches[1], 'linktext' => $matches[3].$matches[6], 'title' => $this->encode_html_basic($matches[4].$matches[7]), 'url' => $matches[8], 'clsty' => $matches[2].$matches[5])));
    }
    function _replace_citation($matches) {
	   return $this->_repl($this->format_cite(array('pre' => $matches[1], 'text' => $matches[2], 'cite' => $matches[3], 'post' => $matches[4])));
    }
    function _replace_macro($matches) {
        return $this->format_macro(array('pre' => $matches[1], 'post' => $matches[3], 'macro' => $matches[2]));
    }
    function _replace_format($matches) {
        $marker = $matches[2];
        $tag = $this->qtag[$marker];
        return $this->format_tag(array('tag' => $tag, 'marker' => $marker, 'pre' => $matches[1], 'text' => $matches[4], 'clsty' => $matches[3], 'post' => $matches[5]));
    }
    function _replace_acronym($matches) {
        return $this->_repl('<acronym title="'.$this->encode_html_basic($matches[2]).'">'.$matches[1].'</acronym>');
    }
    function _replace_capped($matches) {
		return $matches[1].$this->_repl('<span class="'.$this->css['class_caps'].'">'.$matches[2].'</span>');
    }
    function _replace_enc_link($matches) {
        return $matches[1].$this->encode_url($matches[2]);
    }
    function _replace_enc_char($matches) {
		return ord($matches[1]) > 255 ? '%u' . (sprintf('%04X', ord($matches[1])))
					: '%'  . (sprintf('%02X', ord($matches[1])));
    }
    function _repl($item) {
	    $this->repl[] = $item;
	    return '<textile#'.(count($this->repl)).'>';
    }

	function process(&$str) {
            return $this->TextileThis($str);
        }

	function TextileThis($str) {
	    # save a copy of whatever replacements might exist. this is
	    # in case we call ourselves at some point:
	    $save_repl = $this->repl;
	    $save_links = $this->links;

		# quick translator for abbreviated block names
		# to their tag
		$macros = array('bq' => 'blockquote');
		
		# an array to hold any portions of the text to be preserved
		# without further processing by Textile
	    $this->repl = array();
	
		# strip out extra newline characters. we're only matching for \n herein
		#$str = preg_replace('!(?:\015?\012|\015)!',"\n", $str);
	
		# optionally remove trailing spaces
		if ($this->trim_spaces)
			$str = preg_replace("/ +$/m", '', $str);
	
		# preserve contents of the '==', 'pre', 'blockcode' sections
		$str = preg_replace_callback("/(^|\n\n)==(.+?)==($|\n\n)/s",
				 array(&$this, '_replace_block'), $str);
	
		if (!$this->disable_html) {
			# preserve style, script tag contents
			$str = preg_replace_callback('/(<(style|script)(?:>| .+?'.'>).*?<\/\2>)/s',array(&$this, '_replace_simple'), $str);
	
			# preserve HTML comments
			$str = preg_replace_callback('/(<!--.+?-->)/s',array(&$this, '_replace_simple'),$str);
	
			# preserve pre block contents, encode contents by default
			$pre_start = count($this->repl);
			$str = preg_replace_callback('/(<pre(?: [^>]*)?'.'>)(.+?)(<\/pre>)/s',
					 array(&$this, '_replace_pre'), $str);
			# fix code tags within pre blocks we just saved.
			for ($i = $pre_start; $i < count($this->repl); $i++) {
				$this->repl[$i] = preg_replace('/&lt;(\/?)code(.*?)&gt;/s','<\\1code\\2>', $this->repl[$i]);
			}
	
			# preserve code blocks by default, encode contents
			$str = preg_replace_callback('/(<code(?: [^>]+)?'.'>)(.+?)(<\/code>)/s',
					 array(&$this, '_replace_pre'), $str);
	
			# encode blockcode tag (an XHTML 2 tag) and encode it's
			# content by default
			$str = preg_replace_callback('/(<blockcode(?: [^>]+)?'.'>)(.+?)(<\/blockcode>)/s',
					 array(&$this, '_replace_pre'), $str);

			# preserve span tag contents
			if ($this->css['class_caps']) {
				$str = preg_replace_callback('/(<span class="'.$this->css['class_caps'].'">)(.+?)(<\/span>)/s',
					 array(&$this, '_replace_pre_oneline'), $str);
			}
	
			# preserve PHPish, ASPish code
			$str = preg_replace_callback('/(<([\?\%]).*?(\2)>)/s',array(&$this, '_replace_simple'), $str);
		}
	
		# pass through and remove links that follow this format
		# [id_without_spaces (optional title text)]url
		# lines like this are stripped from the content, and can be
		# referred to using the "link text":id_without_spaces syntax
		$this->links = array();
		$str = preg_replace_callback('/(?:\n|^) [ ]* \[ ([^ ]+?) [ ]*? (?:\( (.+?) \) )?  \] ((?:(?:ftp|https?|telnet|nntp):\/\/|\/)[^ ]+?) [ ]* (\n|$)/mx',
				 array(&$this, '_save_link'), $str);
	
		# eliminate starting/ending blank lines
		$str = preg_replace('/^\n+/s', '', $str);
		$str = preg_replace('/\n+$/s', '', $str);
	
		# split up text into paragraph blocks, capturing newlines too
		$paras = preg_split('/(\n{2,})/', $str, -1, PREG_SPLIT_DELIM_CAPTURE);
		//my ($block, $bqlang, $filter, $class, $sticky, @lines,
		//	$style, $stickybuff, $lang, $clear);
	
		$out = '';
	
		foreach ($paras as $para) {
			if (preg_match('/^\n+$/s', $para)) {
				if ($sticky && isset($stickybuff)) {
					$stickybuff .= $para;
				} else {
					$out .= $para;
				}
				continue;
			}
			
			if ($sticky) {
				$sticky++;
			} else {
				unset ($block, $class, $lang);
				$style = '';
			}
	
			unset ($id, $cite, $align, $padleft, $padright, $lines, $buffer);
			$sigre = '/^(h[1-6]|p|bq|bc|fn\d+)
						   ((?:'.$this->clstyfiltre.'*|'.$this->halignre.')*)
						   (\.\.?)
						   (?: : (\d+|'.$this->urlre.'))?\ /x';
			$xxre = '/^
						(?:'.$this->halignre.'|'.$this->clstypadre.'*)*
						[\*\#]
						(?:'.$this->halignre.'|'.$this->clstypadre.'*)*
					\ /x';
			if (preg_match($sigre, $para, $matches)) {
				$para = substr($para, strlen($matches[0]));
				if ($sticky) {
					if ($block == 'bc') {
						# close our blockcode section
						$out = preg_replace('/\n\n$/s','',$out);
						$out .= $this->_blockcode_close."\n\n";
					} elseif ($block == 'bq') {
						$out = preg_replace('/\n\n$/', '', $out);
						$out .= '</blockquote>'."\n\n";
					} elseif ($block == 'table') {
						$table_out = $this->format_table(array('text' => $stickybuff));
						if (!isset($table_out))
							$table_out = '';
						$out .= $table_out;
						unset($stickybuff);
					} elseif ($block == 'dl') {
						$dl_out = $this->format_deflist(array('text' => $stickybuff));
						if (!isset($dl_out))
							$dl_out = '';
						$out .= $dl_out;
						unset($stickybuff);
					}
					$sticky = 0;
				}
				# block macros: h[1-6](class)., bq(class)., bc(class)., p(class).
				# echo "paragraph: [[$para]]\n\tblock: $1\n\tparams: $2\n\tcite: $4";
				$block = $matches[1];
				$params = $matches[2];
				$cite = $matches[4];
				if ($matches[3] == '..') {
					$sticky = 1;
				} else {
					$sticky = 0;
					unset ($class, $bqlang, $lang, $filter);
					$style = '';
				}
				if (preg_match('/^h([1-6])$/', $block, $matches)) {
					if ($this->head_offset > 0) {
						$block = 'h' . ($matches[1] + $this->head_offset);
					}
				}
				if (preg_match('/('.$this->halignre.'+)/', $params, $matches)) {
					$align = $matches[1];
					$params = preg_replace('/'.$this->halignre.'+/x','',$params, 1);
				}
				if (isset($params)) {
					if (preg_match('/\|(.+)\|/', $params, $matches)) {
						$filter = $matches[1];
						$params = preg_replace('/\|.+?\|/','',$params, 1);
					}
					if (preg_match('/{([^}]+)}/', $params, $matches)) {
						$style = $matches[1];
						$style = preg_replace('/\n/', ' ', $style);
						$params = preg_replace('/{[^}]+}/', '', $params);
					}
					if (preg_match('/\(([A-Za-z0-9_\-\ ]+?)(?:\#(.+?))?\)/', $params, $matches) or
						preg_match('/\(([A-Za-z0-9_\-\ ]+?)?(?:\#(.+?))\)/',$params,  $matches)) {
						if ($matches[1] or $matches[2]) {
							$class = $matches[1];
							$id = $matches[2];
							if ($class) {
								$params = preg_replace('/\([A-Za-z0-9_\-\ ]+?(#.*?)?\)/', '', $params);
							} elseif ($id) {
								$params = preg_replace('/\(#.+?\)/', '', $params);
							}
						}
					}
					if (preg_match('/(\(+)/', $params, $matches)) {
						$padleft = strlen($matches[1]);
						$params = preg_replace('/\(+/', '', $params, 1);
					}
					if (preg_match('/(\)+)/', $params, $matches)) {
						$padright = strlen($matches[1]);
						$params = preg_replace('/\)+/', '', $params, 1);
					}
					if (preg_match('/\[(.+?)\]/', $params, $matches)) {
						$lang = $matches[1];
						if ($block == 'bc') {
							$bqlang = $lang;
							unset($lang);
						}
						$params = preg_replace('/\[.+?\]/', '', $params, 1);
					}
				}
				#warn "settings:\n\tblock: $block\n\tpadleft: $padleft\n\tpadright: $padright\n\tclass: $class\n\tstyle: $style\n\tid: $id\n\tfilter: $filter\n\talign: $align\n\tlang: $lang\n\tsticky: $sticky";
			} elseif (preg_match('/^<textile#(\d+)>$/', $para, $matches)) {
				$buffer = $this->repl[$matches[1]-1];
			} elseif (preg_match('/^clear([<>]+)?\.$/', $para, $matches)) {
				if ($matches[1] == '<') {
					$clear = 'left';
				} elseif ($matches[1] == '>') {
					$clear = 'right';
				} else {
					$clear = 'both';
				}
				continue;
			} elseif ($sticky && (isset($stickybuff)) &&
					 (($block == 'table') or ($block == 'dl'))) {
				$stickybuff .= $para;
				continue;
			} elseif (preg_match($xxre, $para)) {
				# '*', '#' prefix means a list
				$buffer = $this->format_list(array('text' => $para));
			} elseif (preg_match('/^(?:table(?:'.$this->tblalignre.'|'.$this->clstypadre.'*)*
								 (\.\.?)\s+)?
								 (?:_|'.$this->alignre.'|'.$this->clstypadre.'*)*\|/sx', $para, $matches)) {
				# handle wiki-style tables
				if (isset($matches[1]) && ($matches[1] == '..')) {
					$block = 'table';
					$stickybuff = $para;
					$sticky = 1;
					continue;
				} else {
					$buffer = $this->format_table(array('text' => $para));
				}
			} elseif (preg_match('/^(?:dl(?:'.$this->clstyre.')*(\.\.?)\s+)/x', $para, $matches)) {
				# handle definition lists
				if (isset($matches[1]) && ($matches[1] == '..')) {
					$block = 'dl';
					$stickybuff = $para;
					$sticky = 1;
					continue;
				} else {
					$buffer = $this->format_deflist(array('text' => $para));
				}
			}
			if (isset($buffer)) {
				$out .= $buffer;
				continue;
			}
			$lines = preg_split('/\n/', $para);
			if (!count($lines))
				continue;
	
			$block or $block = 'p';

			$buffer = '';
			$pre = '';
			$post = '';
	
			if ($block == 'bc') {
				if ($sticky <= 1) {
					$pre .= $this->_blockcode_open;
					$pre = preg_replace('/>$/', '', $pre, 1);
					if ($bqlang)
						$pre .= " language=\"$bqlang\"";
					if ($align) {
						$alignment = _halign($align);
						if ($this->css_mode) {
							if (($padleft or $padright) &&
								(($alignment == 'left') || ($alignment == 'right'))) {
								$style .= ';float:'.$alignment;
							} else {
								$style .= ';text-align:'.$alignment;
							}
							$class .= ' '.$this->css["class_align_$alignment"] or  $alignment;
						} else {
							if ($alignment)
								$pre .= " align=\"$alignment\"";
						}
					}
					if ($padleft)
						$style .= ";padding-left:$padleft".'em';
					if ($padright)
						$style .= ";padding-right:$padright".'em';
					if ($clear)
						$style .= ";clear:$clear";
					if ($class) {
						$class = preg_replace('/^ /', '', $class, 1);
						$pre .= " class=\"$class\"";
					}
					if ($id)
						$pre .= " id=\"$id\"";
					if ($style) {
						$style = preg_replace('/^;/', '', $style, 1);
						$pre .= " style=\"$style\"";
					}
					if ($lang)
						$pre .= " lang=\"$lang\"";
					$pre .= '>';
					unset ($lang, $bqlang, $clear);
				}
				$para = preg_replace_callback("/(?:^|(?<=[\s>])|([{[]))
						   ==(.+?)==
						   (?:$|([\]}])|(?=[[:punct:]]{1,2}|\s))/sx",
						  array(&$this, '_replace_inline_block'), $para);
				$buffer .= $this->encode_html_basic($para, 1);
				$buffer = preg_replace('/&lt;textile#(\d+)&gt;/', '<textile#\\1>/', $buffer);
				if ($sticky == 0)
					$post .= $this->_blockcode_close;
				$out .= $pre . $buffer . $post;
				continue;
			} elseif ($block == 'bq') {
				if ($sticky <= 1) {
					$pre .= '<blockquote';
					if ($align) {
						$alignment = _halign($align);
						if ($this->css_mode) {
							if (($padleft or $padright) &&
								(($alignment == 'left') || ($alignment == 'right'))) {
								$style .= ';float:'.$alignment;
							} else {
								$style .= ';text-align:'.$alignment;
							}
							$class .= ' '.$this->css["class_align_$alignment"] or $alignment;
						} else {
							if ($alignment)
								$pre .= " align=\"$alignment\"";
						}
					}
					if ($padleft)
						$style .= ";padding-left:$padleft".'em';
					if ($padright)
						$style .= ";padding-right:$padright".'em';
					if ($clear)
						$style .= ";clear:$clear";
					if ($class) {
						$class = preg_replace('/^ /', '', $class);
						$pre .= " class=\"$class\"";
					}
					if ($id)
						$pre .= " id=\"$id\"";
					if ($style) {
						$style = preg_replace('/^;/','',$style);
						$pre .= " style=\"$style\"";
					}
					if ($lang)
						$pre .= " lang=\"$lang\"";
					if (isset($cite))
						$pre .= ' cite="' . $this->format_url(array('url' => $cite)) . '"';
					$pre .= '>';
					unset($clear);
				}
				$pre .= '<p>';
			} elseif (preg_match('/fn(\d+)/', $block, $matches)) {
				$fnum = $matches[1];
				$pre .= '<p';
				if (array_key_exists('class_footnote', $this->css))
					$class .= ' '.$this->css['class_footnote'];
				if ($align) {
					$alignment = _halign($align);
					if ($this->css_mode) {
						if (($padleft or $padright) &&
							(($alignment == 'left') || ($alignment == 'right'))) {
							$style .= ';float:'.$alignment;
						} else {
							$style .= ';text-align:'.$alignment;
						}
						$class .= ($this->css["class_align_$alignment"] or $alignment);
					} else {
						$pre .= " align=\"$alignment\"";
					}
				}
				if ($padleft)
					$style .= ";padding-left:$padleft".'em';
				if ($padright)
					$style .= ";padding-right:$padright".'em';
				if ($clear)
					$style .= ";clear:$clear";
				if ($class) {
					$class = preg_replace('/^ /', '', $class);
					$pre .= " class=\"$class\"";
				}
				$pre .= ' id="'.($this->css['id_footnote_prefix'] ? $this->css['id_footnote_prefix'] : 'fn').$fnum.'"';
				if ($style) {
					$style = preg_replace('/^;/', '', $style);
					$pre .= " style=\"$style\"";
				}
				if ($lang)
					$pre .= " lang=\"$lang\"";
				$pre .= '>';
				$pre .= '<sup>'.$fnum.'</sup> ';
				# we can close like a regular paragraph tag now
				$block = 'p';
				unset($clear);
			} else {
				$pre .= '<' . ($macros[$block] ? $macros[$block] : $block);
				if ($align) {
					$alignment = _halign($align);
					if ($this->css_mode) {
						if (($padleft or $padright) &&
							(($alignment == 'left') or ($alignment == 'right'))) {
							$style .= ';float:'.$alignment;
						} else {
							$style .= ';text-align:'.$alignment;
						}
						$class .= ' '.$this->css["class_align_$alignment"] or $alignment;
					} else {
						$pre .= " align=\"$alignment\"";
					}
				}
				if ($padleft)
					$style .= ";padding-left:$padleft".'em';
				if ($padright)
					$style .= ";padding-right:$padright".'em';
				if ($clear)
					$style .= ";clear:$clear";
				if ($class) {
					$class = preg_replace('/^ /', '', $class);
					$pre .= " class=\"$class\"";
				}
				if ($id)
					$pre .= " id=\"$id\"";
				if ($style) {
					$style = preg_replace('/^;/', '', $style);
					$pre .= " style=\"$style\"";
				}
				if ($lang)
					$pre .= " lang=\"$lang\"";
				if (isset($cite) && ($block == 'bq'))
					$pre .= ' cite="' . $this->format_url(array('url' => $cite)) . '"';
				$pre .= '>';
				unset($clear);
			}
	
			$buffer = $this->format_paragraph(array('text' => $para));
	
			if ($block == 'bq') {
				if (!preg_match('/<p[ >]/', $buffer))
					$post .= '</p>';
				if ($sticky == 0)
					$post .= '</blockquote>';
			} else {
				$post .= '</' . $block . '>';
			}
	
			if (preg_match('/'.$this->blocktags.'/x', $buffer)) {
				$buffer = preg_replace('/^\n\n/s', '', $buffer);
				$out .= $buffer;
			} else {
				if (isset($filter))
					$buffer = $this->format_block(array('text' => "|$filter|".$buffer, 'inline' => 1));
				$out .= $pre . $buffer . $post;
			}
		}
	
		if ($sticky) {
			if ($block == 'bc') {
				# close our blockcode section
				$out .= $this->_blockcode_close;
			} elseif ($block == 'bq') {
				$out .= '</blockquote>';
			} elseif (($block == 'table') && ($stickybuff)) {
				$table_out = $this->format_table(array('text' => $stickybuff));
				if (isset($table_out))
					$out .= $table_out;
			} elseif (($block == 'dl') && ($stickybuff)) {
				$dl_out = $this->format_deflist(array('text' => $stickybuff));
				if (isset($dl_out))
					$out .= $dl_out;
			}
		}
	
		# cleanup-- restore preserved blocks
		while ($i = count($this->repl)) {
			$rep = array_pop($this->repl);
			$out = preg_replace("/(?:<|&lt;)textile#$i(?:>|&gt;)/", $rep, $out, 1);
		}
	
		# scan for br, hr tags that are not closed and close them
		# only for xhtml! just the common ones -- don't fret over input
		# and the like.
		if (preg_match('/^xhtml/i', $this->flavor))
			$out = preg_replace('/(<(?:img|br|hr)[^>]*?(?<!\/))>/','\\1 />', $out);

	    $this->repl = $save_repl;
        $this->links = $save_links;

		return $out;
	}
	
	function format_paragraph($args) {
	    $save_repl = $this->repl;
	    $this->repl = array();

		$buffer = array_key_exists('text', $args) ? $args['text'] : '';
	
		$buffer = preg_replace_callback('/(?:^|(?<=[\s>])|([{[]))
					 ==(.+?)==
					 (?:$|([\]}])|(?=[[:punct:]]{1,2}|\s))/sx',
					array(&$this, '_replace_inline_block'), $buffer);
	
		if (preg_match('/</', $buffer) && (!$this->disable_html)) {  # optimization -- no point in tokenizing if we
								# have no tags to tokenize
			$tokens = $this->tokenize($buffer);
		} else {
			$tokens = array(array('text', $buffer));
		}
		$result = '';
		foreach ($tokens as $token) {
			$text = $token[1];
			if ($token[0] == 'tag') {
				$text = preg_replace('/&(?!amp;)/', '&amp;', $text);
				$result .= $text;
			} else {
				$text = $this->format_inline(array('text' => $text));
				$result .= $text;
			}
		}
	
		# now, add line breaks for lines that contain plaintext
		$lines = preg_split('/\n/', $result);
		$result = '';
		$needs_closing = 0;
		foreach ($lines as $line) {
			if (!preg_match('/'.$this->blocktags.'/x', $line)
				&& ((preg_match('/^[^<]/', $line) || preg_match('/>[^<]/', $line))
					|| (!preg_match('/<img /', $line)))) {
				if ($this->_line_open) {
					if ($result != '')
						$result .= "\n";
					$result .= $this->_line_open . $line . $this->_line_close;
				} else {
					if ($needs_closing) {
						$result .= $this->_line_close ."\n";
					} else {
						$needs_closing = 1;
						if ($result != '')
							$result .= "\n";
					}
					$result .= $line;
				}
			} else {
				if ($needs_closing) {
					$result .= $this->_line_close ."\n";
				} else {
					if ($result != '')
						$result .= "\n";
				}
				$result .= $line;
				$needs_closing = 0;
			}
		}
	
		# at this point, we will restore the \001's to \n's (reversing
		# the step taken in _tokenize).
		#$result =~ s/\r/\n/g;
		$result = preg_replace('/\001/', "\n", $result);
	
		while ($i = count($this->repl)) {
			$rep = array_pop($this->repl);
			$result = preg_replace("/<textile#$i>/", $rep, $result, 1);
		}
	
		# quotalize
		if ($this->do_quotes) {
			$result = $this->process_quotes($result);
		}

        $this->repl = $save_repl;
		return $result;
	}
	
	function format_inline($args) {
		$text = array_key_exists('text', $args) ? $args['text'] : '';
        $save_repl = $this->repl;
		$this->repl = array();
	
		$text = preg_replace_callback("/".$this->codere."/x",
			array(&$this, '_replace_code'), $text);
	
		# images must be processed before encoding the text since they might
		# have the <, > alignment specifiers...
	
		# !blah (alt)! -> image
		$imgre = '/
		    (?: ^ | (?<=[\s>]) | ([{[]) )
			!
			('.$this->imgalignre.'?)?
			('.$this->clstypadre.'*)?
			('.$this->imgalignre.'?)?
			(?:\s*)
			([^\s\(!]+)
			(?:\s*)
			([^\(!]*(?:\([^\)]+\))?[^!]*)
			!
			(?: : (\d+ | '.$this->urlre.') )?
			(?: $ | ([\]}]) | (?= [[:punct:]]{1,2} | \s ) )
		   /x';
		$text = preg_replace_callback($imgre,
		   array(&$this, '_replace_image'), $text);
	
		$text = preg_replace_callback('/
			(?: ^ | (?<=[\s>]) | ([{[]) )	 # $1: open brace, bracket
			%						  # opening
			('.$this->halignre.'?)		  # $2: optional alignment
			('.$this->clstyre.'*)		   # $3: optional CSS class, id
			('.$this->halignre.'?)		  # $4: optional alignment
			(?:\s*)					 # spacing
			([^\%]+?)				   # $5: text
			%						  # closing
			(?: : (\d+|'.$this->urlre.'))?	# $6: optional URL
			(?:$|([\]}])|(?=[[:punct:]]{1,2}|\s))# $7: closing brace, bracket
			/x',
			array(&$this, '_replace_span'), $text);
	
		$text = $this->encode_html($text);
		$text = preg_replace('/&lt;textile#(\d+)&gt;/', '<textile#\\1>', $text);
		$text = preg_replace('/&amp;quot;/', '&#34;', $text);
                $text = preg_replace('/&amp;(#?[xX]?(?:[0-9a-fA-F]+|\w{1,8});)/', '&\\1', $text);
		$text = preg_replace('/&amp;(([a-z]+|#\d+);)/', '&\\1', $text);
		$text = preg_replace('/&quot;/', '"', $text);
	
		# These create markup with entities. Do first and 'save' result for later:
		# "text":url -> hyperlink
		# links with brackets surrounding
		$parenre = '\((?:[^()])*\)';
		$text = preg_replace_callback('/(
			[{[]
			(?:
				(?:"					# quote character
				   ('.$this->clstyre.'*)?		 # $2: optional CSS class, id
				   ([^"]+?)			 # $3: link text
				   (?:\( ( (?:[^()]|'.$parenre.')*) \))? # $4: optional link title
				   "					# closing quote
				)
				|
				(?:\'					# open single quote
				   ('.$this->clstyre.'*)?		 # $5: optional CSS class, id
				   ([^\']+?)			 # $6: link text
				   (?:\( ( (?:[^()]|'.$parenre.')*) \))? # $7: optional link title
				   \'					# closing quote
				)
			)
			:(.+?)					  # $8: URL suffix
			[\]}]
		   )
		   /x',
		   array(&$this, '_replace_link'), $text);
	
		$text = preg_replace_callback('/
			((?:^|(?<=[\s>\(]))		 # $1: open brace, bracket
			(?: (?:"				   # quote character
				   ('.$this->clstyre.'*)?		 # $2: optional CSS class, id
				   ([^"]+?)			# $3: link text
				   (?:\( ( (?:[^()]|'.$parenre.')*) \))? # $4: optional link title
				   "				   # closing quote
				)
				|
				(?:\'					# open single quote
				   ('.$this->clstyre.'*)?		 # $5: optional CSS class, id
				   ([^\']+?)			 # $6: link text
				   (?:\( ( (?:[^()]|'.$parenre.')*) \))?  # $7: optional link title
				   \'					# closing quote
				)
			)
			:(\d+|'.$this->urlre.')			   # $8: URL suffix
			(?:$|(?=[[:punct:]]{1,2}|\s)))   # $9: closing brace, bracket
		   /x',
		   array(&$this, '_replace_link'), $text);
	
		if (preg_match('/^xhtml2/', $this->flavor)) {
			# citation with cite link
			$text = preg_replace_callback('/
				(?:^|(?<=[\s>\'"\(])|([{[]))# $1: open brace, bracket
				\?\?						# opening
				([^\?]+?)				   # $2: characters
				\?\?						# closing
				:(\d+|'.$this->urlre.')			   # $3: optional citation URL
				(?:$|([\]}])|(?=[[:punct:]]{1,2}|\s))# $4: closing brace, bracket
			   /x',
			   array(&$this, '_replace_citation'), $text);
		}
	
		# footnotes
		if (preg_match('/[^ ]\[\d+\]/', $text)) {
			$fntag = '<sup';
			if (array_key_exists('class_footnote', $this->css))
				$fntag .= ' class="'.$this->css['class_footnote'].'"';
			$fntag .= '><a href="#'.($this->css['id_footnote_prefix'] ? $this->css['id_footnote_prefix'] : 'fn');
			$text = preg_replace('/([^ ])\[(\d+)\]/', '\\1'.$fntag.'\\2">\\2</a></sup>', $text);
		}
	
		# translate macros:
		$text = preg_replace_callback('{(\{)(.+?)(\})}x',
				  array(&$this, '_replace_macro'), $text);

		# these were present with textile 1 and are common enough
		# to not require macro braces...
		# (tm) -> &trade;
		$text = preg_replace('/[\(\[]TM[\)\]]/i', '&#8482;', $text);
		# (c) -> &copy;
		$text = preg_replace('/[\(\[]C[\)\]]/i', '&#169;', $text);
		# (r) -> &reg;
		$text = preg_replace('/[\(\[]R[\)\]]/i', '&#174;', $text);
	
		if ($this->preserve_spaces) {
			# replace two spaces with an em space
			$text = preg_replace('/(?<!\s)\ \ (?!=\s)/', '&#8195;', $text);
		}
	
		$redo = preg_match('/[\*_\?\-\+\^\~]/', $text);
		$last = $text;
		while ($redo) {
			# simple replacements...
			$redo = 0;
			foreach ($this->qtags as $tag) {
				list($f, $r, $qf, $cls) = $tag;
				if ($text = preg_replace_callback('/
					(?:^|(?<=[\s>\'"])|([{[]))# 1 - pre
					('.$qf.')
					('.$this->clstyre.'*)?		# 3 - attributes
					([^'.$cls.'\s].*?)			# 4 - content
					(?<=\S)'.$qf.'
					(?:$|([\]}])|(?=[[:punct:]]{1,2}|\s)) # 5 - post
				   /x',
				   array(&$this, '_replace_format'), $text)) {
				   $redo or $redo = $last != $text;
				   $last = $text;
				}
			}
		}
	
		# superscript is an even simpler replacement...
		$text = preg_replace('/(?<!\^)\^(?!\^)(.+?)(?<!\^)\^(?!\^)/', '<sup>\\1</sup>', $text);
	
		# ABC(Aye Bee Cee) -> acronym
		$text = preg_replace_callback('/\b([A-Z][A-Za-z0-9]*?[A-Z0-9]+?)\b(?:[(]([^)]*)[)])/',
				  array(&$this, '_replace_acronym'), $text);
	
		# ABC -> 'capped' span
		if ($this->css['class_caps']) {
			$text = preg_replace_callback('/
				(^|[^"][>\s])
				((?:[A-Z](?:[A-Z0-9\.,\']|\&amp;){2,}\ *)+?)
				(?=[^A-Z\.0-9]|$)
				/x',
				array(&$this, '_replace_capped'), $text);
		}
	
		# nxn -> n&times;n
		$text = preg_replace('/((?:[0-9\.]0|[1-9]|\d[\'"])\ ?)x(\ ?\d)/', '\\1&#215;\\2', $text);
	
		# translate these entities to the Unicode equivalents:
		$text = preg_replace('/&#133;/', '&#8230;', $text);
		$text = preg_replace('/&#145;/', '&#8216;', $text);
		$text = preg_replace('/&#146;/', '&#8217;', $text);
		$text = preg_replace('/&#147;/', '&#8220;', $text);
		$text = preg_replace('/&#148;/', '&#8221;', $text);
		$text = preg_replace('/&#150;/', '&#8211;', $text);
		$text = preg_replace('/&#151;/', '&#8212;', $text);

		# Restore replacements done earlier:
		while ($i = count($this->repl)) {
			$rep = array_pop($this->repl);
			$text = preg_replace('/<textile#'.$i.'>/', $rep, $text, 1);
		}
	
		# translate entities to characters for highbit stuff since
		# we're using utf8
		# removed for backward compatability with older versions of Perl
		#if ($this->{charset} =~ m/^utf-?8$/i) {
		#	# translate any unicode entities to native UTF-8
		#	$text =~ s/\&\#(\d+);/($1 > 127) ? pack('U',$1) : chr($1)/ge;
		#}

	    $this->repl = $save_repl;

		return $text;
	}
	
	function format_macro($args) {
		$macro = $args['macro'];
		if (array_key_exists($macro, $this->macros)) {
			return $this->macros[$macro];
		}
	
		# handle full unicode name translation
		#if ($Have_Charnames) {
		#	# charnames::vianame is only available in Perl 5.8.0 and later...
		#	if (defined (my $unicode = charnames::vianame(uc($macro)))) {
		#		return '&#'.$unicode.';';
		#	}
		#}
	
		return $args['pre'].$macro.$args['post'];
	}
	
	function format_cite($args) {
		$pre = array_key_exists('pre', $args) ? $args['pre'] : '';
		$text = array_key_exists('text', $args) ? $args['text'] : '';
		$cite = $args['cite'];
		$post = array_key_exists('post', $args) ? $args['post'] : '';
		_strip_borders($pre, $post);
		$tag = $pre.'<cite';
		if ((preg_match('/^xhtml2/', $this->flavor)) && isset($cite)) {
		  $cite = $this->format_url(array('url' => $cite));
		  $tag .= " cite=\"$cite\"";
		} else {
		  $post .= ':';
		}
		$tag .= '>';
		return $tag . $this->format_inline(array('text' => $text)) . '</cite>'.$post;
	}
	
	function format_code($args) {
		$code = array_key_exists('text', $args) ? $args['text'] : '';
		$lang = $args['lang'];
		$code = $this->encode_html($code, 1);
		$code = preg_replace('/&lt;textile#(\d+)&gt;/', '<textile#\\1>', $code);
		$tag = '<code';
		if ($lang)
			$tag .= " language=\"$lang\"";
		return $tag . '>' . $code . '</code>';
	}
	
	function format_classstyle($clsty, $class = '', $style = '') {
		$class = preg_replace('/^ /', '', $class);
	
		if ($clsty && (preg_match('/{([^}]+)}/', $clsty, $matches))) {
			$_style = $matches[1];
			$_style = preg_replace('/\n/', ' ', $_style);
			$style .= ';'.$_style;
			$clsty = preg_replace('/{[^}]+}/', '', $clsty);
		}
		if ($clsty && (preg_match('/\(([A-Za-z0-9_\- ]+?)(?:#(.+?))?\)/',$clsty,$matches) ||
					   preg_match('/\(([A-Za-z0-9_\- ]+?)?(?:#(.+?))\)/', $clsty, $matches))) {
			if ($matches[1] || $matches[2]) {
				if ($class) {
					$class = $matches[1] . ' ' . $class;
				} else {
					$class = $matches[1];
				}
				$id = $matches[2];
				if ($class)
					$clsty = preg_replace('/\([A-Za-z0-9_\- ]+?(#.*?)?\)/', '', $clsty);
				if ($id)
					$clsty = preg_replace('/\(#.+?\)/', '', $clsty);
			}
		}
		if ($clsty && (preg_match('/(\(+)/', $clsty, $matches))) {
			$padleft = strlen($matches[1]);
			$clsty = preg_replace('/\(+/', '', $clsty, 1);
		}
		if ($clsty && (preg_match('/(\)+)/', $clsty, $matches))) {
			$padright = strlen($matches[1]);
			$clsty = preg_replace('/\)+/', '', $clsty, 1);
		}
		if ($clsty && (preg_match('/\[(.+?)\]/', $clsty, $matches))) {
			$lang = $matches[1];
			$clsty = preg_replace('/\[.+?\]/', '', $clsty);
		}
		$attrs = '';
		if ($padleft)
			$style .= ";padding-left:$padleft".'em';
		if ($padright)
			$style .= ";padding-right:$padright".'em';
		$style = preg_replace('/^;/', '', $style);
		$class = preg_replace('/^ /', '', $class);
		$class = preg_replace('/ $/', '', $class);
		if ($class)
			$attrs .= " class=\"$class\"";
		if ($id)
			$attrs .= " id=\"$id\"";
		if ($style)
			$attrs .= " style=\"$style\"";
		if ($lang)
			$attrs .= " lang=\"$lang\"";
		$attrs = preg_replace('/^ /', '', $attrs);
		return $attrs;
	}
	
	function format_tag($args) {
		$tagname = $args['tag'];
		$text = array_key_exists('text', $args) ? $args['text'] : '';
		$pre = array_key_exists('pre', $args) ? $args['pre'] : '';
		$post = array_key_exists('post', $args) ? $args['post'] : '';
		$clsty = array_key_exists('clsty', $args) ? $args['clsty'] : '';
		_strip_borders($pre, $post);
		$tag = "<$tagname";
		$attr = $this->format_classstyle($clsty);
		if ($attr)
			$tag .= " $attr";
		$tag .= ">$text</$tagname>";
		return $pre.$tag.$post;
	}
	
	function _add_term($dt, $dd) {
		if (preg_match('/^('.$this->clstyre.'*)/x', $dt, $matches)) {
			$param = $matches[1];
			$dtattr = $this->format_classstyle($param);
			if (preg_match('/\[([A-Za-z]+?)\]/', $param, $matches)) {
				$dtlang = $matches[1];
			}
			$dt = substr($dt, strlen($param));
		}
		if (preg_match('/^('.$this->clstyre.'*)/x', $dd, $matches)) {
			$param = $matches[1];
			# if the language was specified for the term,
			# then apply it to the definition as well (unless
			# already specified of course)
			if ($dtlang && (preg_match('/\[([A-Za-z]+?)\]/', $param))) {
				unset($dtlang);
			}
			$ddattr = $this->format_classstyle(($dtlang ? "[$dtlang]" : '') . $param);
			$dd = substr($dd, strlen($param));
		}
		$out = '<dt';
		if ($dtattr)
			$out .= " $dtattr";
		$out .= '>' . $this->format_paragraph(array('text' => $dt)) . '</dt>' . "\n";
		if (preg_match('/\n\n/', $dd)) {
			$dd = $this->textile($dd);
		} else {
			$dd = $this->format_paragraph(array('text' => $dd));
		}
		$out .= '<dd';
		if ($ddattr)
			$out .= " $ddattr";
		return $out .= '>' . $dd . '</dd>' . "\n";
	}
	
	function format_deflist($args) {
		$str = array_key_exists('text', $args) ? $args['text'] : '';
		$lines = preg_split('/\n/', $str);
		if (preg_match('/^(dl('.$this->clstyre.'*?)\.\.?(?:\ +|$))/x', $lines[0], $matches)) {
			$clsty = $matches[2];
			$lines[0] = substr($lines[0], strlen($matches[1]));
		}
	
		$out = '';
		foreach ($lines as $line) {
			if (preg_match('/^((?:'.$this->clstyre.'*)(?:[^\ ].*?)(?<!["\'\ ])):([^\ \/].*)$/x', $line, $matches)) {
				if ($dt && $dd)
					$out .= $this->_add_term($dt, $dd);
				$dt = $matches[1];
				$dd = $matches[2];
			} else {
				$dd .= "\n" . $line;
			}
		}
		if ($dt && $dd)
			$out .= $this->_add_term($dt, $dd);
	
		$tag = '<dl';
		if ($clsty)
			$attr = $this->format_classstyle($clsty);
		if ($attr)
			$tag .= " $attr";
		$tag .= '>'."\n";
		
		return $tag.$out."</dl>\n";
	}
	
	function format_list($args) {
		$str = array_key_exists('text', $args) ? $args['text'] : '';
	
		$list_tags = array('*' => 'ul', '#' => 'ol');
	
		$lines = preg_split('/\n/', $str);
	
		$stack = array();
		$last_depth = 0;
		$item = '';
		$out = '';
		foreach ($lines as $line) {
			if (preg_match('/^((?:'.$this->clstypadre.'*|'.$this->halignre.')*)?
						   ([\#\*]+)
						   ((?:'.$this->halignre.'|'.$this->clstypadre.'*)*)?
						   \ (.+)$/x', $line, $matches)) {
				if ($item != '') {
					if (preg_match('/\n/', $item)) {
						if ($this->_line_open) {
							$item = preg_replace('/(<li[^>]*>|^)/m', '\\1'.$this->_line_open.'/', $item);
							$item = preg_replace('/(\n|$)/s', $this->_line_close.'\\1', $item);
						} else {
							$item = preg_replace('/(\n)/s',$this->_line_close.'\\1', $item);
						}
					}
					$out .= $item;
					$item = '';
				}
				$type = substr($matches[2], 0, 1);
				$depth = strlen($matches[2]);
				$blockparam = $matches[1];
				$itemparam = $matches[3];
				$line = $matches[4];
				unset ($blockclsty, $blockalign, $blockattr, $itemattr, $itemclsty,
					   $itemalign);
				if (preg_match('/('.$this->clstypadre.'+)/x', $blockparam, $matches))
					$blockclsty = $matches[1];
				if (preg_match('/('.$this->halignre.'+)/x', $blockparam, $matches))
					$blockalign = $matches[1];
				if (preg_match('/('.$this->clstypadre.'+)/x', $itemparam, $matches))
					$itemclsty = $matches[1];
				if (preg_match('/('.$this->halignre.'+)/x', $itemparam, $matches))
					$itemalign = $matches[1];
				if ($itemclsty)
					$itemattr = $this->format_classstyle($itemclsty);
				if ($depth > $last_depth) {
					for ($j = $last_depth; $j < $depth; $j++) {
						$out .= "\n<" . $list_tags[$type];
						$stack[] = $type;
						if ($blockclsty) {
							$blockattr = $this->format_classstyle($blockclsty);
							if ($blockattr)
								$out .= ' '.$blockattr;
						}
						$out .= ">\n<li";
						if ($itemattr)
							$out .= " $itemattr";
						$out .= ">";
					}
				} elseif ($depth < $last_depth) {
					for ($j = $depth; $j < $last_depth; $j++) {
						if ($j == $depth)
							$out .= "</li>\n";
						$type = array_pop($stack);
						$out .= "</$list_tags[$type]>\n</li>\n";
					}
					if ($depth) {
						$out .= '<li';
						if ($itemattr)
							$out .= " $itemattr";
						$out .= '>';
					}
				} else {
					$out .= "</li>\n<li";
					if ($itemattr)
						$out .= " $itemattr";
					$out .= '>';
				}
				$last_depth = $depth;
			}
			if ($item != '')
				$item .= "\n";
			$item .= $this->format_paragraph(array('text' => $line));
		}
	
		if (preg_match('/\n/', $item)) {
			if ($this->_line_open) {
				$item = preg_replace('/(<li[^>]*>|^)/m', '\\1'.$this->_line_open, $item);
				$item = preg_replace('/(\n|$)/s', $this->_line_close.'\\1', $item);
			} else {
				$item = preg_replace('/(\n)/s', $this->_line_close.'\\1', $item);
			}
		}
		$out .= $item;
	
		for ($j = 1; $j <= $last_depth; $j++) {
			if ($j == 1)
			$out .= '</li>';
			$type = array_pop($stack);
			$out .= "\n".'</'.$list_tags[$type].'>'."\n";
			if ($j != $last_depth)
				$out .= '</li>';
		}
	
		return $out."\n";
	}
	
	function format_block($args) {
		$str = array_key_exists('text', $args) ? $args['text'] : '';
		$inline = $args['inline'];
		$pre = array_key_exists('pre', $args) ? $args['pre'] : '';
		$post = array_key_exists('post', $args) ? $args['post'] : '';
		_strip_borders($pre, $post);
		if (preg_match('/^(\|(?:(?:[a-z0-9_\-]+)\|)+)/', $str, $matches)) {
			$filters = $matches[1];
			$filtreg = preg_quote($filters);
			$str = preg_replace("/^$filtreg/", '', $str);
			$filters = preg_replace('/^\|/', '', $filters);
			$filters = preg_replace('/\|$/', '', $filters);
			$filter_list = preg_split('/\|/', $filters);
			$str = $this->apply_filters(array('text' => $str, 'filters' => $filter_list));
			$count = count($filter_list);
			if ($str = preg_replace("/(<p>){$count}/s", '\\1', $str)) {
				$str = preg_replace("/(<\/p>){$count}/s", '\\1', $str);
				$str = preg_replace("/(<br( \/)?".">){$count}/s", '\\1', $str);
			}
		}
		if ($inline) {
			# strip off opening para, closing para, since we're
			# operating within an inline block
			$str = preg_replace('/^\s*<p[^>]*>/', '', $str);
			$str = preg_replace('/<\/p>\s*$/', '', $str);
		}
		return $pre.$str.$post;
	}
	
	function format_link($args) {
		$text = array_key_exists('text', $args) ? $args['text'] : '';
		$linktext = array_key_exists('linktext', $args) ? $args['linktext'] : '';
		$title = $args['title'];
		$url = $args['url'];
		$clsty = $args['clsty'];
	
		if (!isset($url) || ($url == ''))
			return $text;
		if (array_key_exists($url, $this->links)) {
			$title or $title = $this->links[$url]['title'];
			$url = $this->links[$url]['url'];
		}
		$linktext = preg_replace('/ +$/', '', $linktext);
		$linktext = $this->format_paragraph(array('text' => $linktext));
		$url = $this->format_url(array('linktext' => $linktext, 'url' => $url));
		$tag = "<a href=\"$url\"";
		$attr = $this->format_classstyle($clsty);
		if ($attr)
			$tag .= " $attr";
		if ($title != '') {
			$title = preg_replace('/^\s+/', '', $title);
			if (title != '')
				$tag .= " title=\"$title\"";
		}
		$tag .= ">$linktext</a>";
		return $tag;
	}
	
	function format_url($args) {
		$url = array_key_exists('url', $args) ? $args['url'] : '';
		if (preg_match('/^(mailto:)?([-\+\w]+\@[-\w]+(\.\w[-\w]*)+)$/', $url, $matches))
			$url = 'mailto:'.$this->mail_encode($matches[2]);
		if (!preg_match('/^(\/|\.\/|\.\.\/|#)/', $url))
			if (!preg_match('/^(https?|ftp|mailto|nntp|telnet)/', $url))
				$url = "http://$url";
		$url = preg_replace('/&(?!amp;)/', '&amp;', $url);
		$url = preg_replace('/\ /', '+', $url);
		$url = preg_replace_callback('/^((?:.+?)\?)(.+)$/', array(&$this, '_replace_enc_link'), $url);
		return $url;
	}
	
	function format_span($args) {
		$text = array_key_exists('text', $args) ? $args['text'] : '';
		$pre = array_key_exists('pre', $args) ? $args['pre'] : '';
		$post = array_key_exists('post', $args) ? $args['post'] : '';
		$align = $args['align'];
		$cite = array_key_exists('cite', $args) ? $args['cite'] : '';
		$clsty = $args['clsty'];
		_strip_borders($pre, $post);
		$tag  = '<span';
		$style = '';
		if (isset($align)) {
			if ($this->css_mode) {
				$alignment = _halign($align);
				if ($alignment) {
					$style .= ";float:$alignment";
					$class .= ' '.$this->css["class_align_$alignment"];
				}
			} else {
				$alignment = _halign($align) or _valign($align);
				if ($alignment)
					$tag .= " align=\"$alignment\"";
			}
		}
		$attr = $this->format_classstyle($clsty, $class, $style);
		if ($attr)
			$tag .= " $attr";
		if ($cite != '') {
			$cite = preg_replace('/^:/', '', $cite);
			$cite = $this->format_url(array('url' => $cite));
			$tag .= " cite=\"$cite\"";
		}
		return $pre.$tag.'>'.$this->format_paragraph(array('text' => $text)).'</span>'.$post;
	}
	
	function format_image($args) {
		$src = array_key_exists('src', $args) ? $args['src'] : '';
		$extra = $args['extra'];
		$align = $args['align'];
		$pre = array_key_exists('pre', $args) ? $args['pre'] : '';
		$post = array_key_exists('post', $args) ? $args['post'] : '';
		$link = $args['url'];
		$clsty = $args['clsty'];
		_strip_borders($pre, $post);
		if ($src == '')
			return $pre.'!!'.$post;
		if (preg_match('/^xhtml2/', $this->flavor)) {
			$type; # poor man's mime typing. need to extend this externally
			if (preg_match('/(?:\.jpeg|\.jpg)$/i', $src)) {
				$type = 'image/jpeg';
			} elseif (preg_match('/\.gif$/i', $src)) {
				$type = 'image/gif';
			} elseif (preg_match('/\.png$/i', $src)) {
				$type = 'image/png';
			} elseif (preg_match('/\.tiff$/i', $src)) {
				$type = 'image/tiff';
			}
			$tag = '<object';
			if ($type)
				$tag .= " type=\"$type\"";
			$tag .= " data=\"$src\"";
		} else {
			$tag = "<img src=\"$src\"";
		}
		if (isset($align)) {
			if ($this->css_mode) {
				$alignment = _halign($align);
				if ($alignment) {
					$style .= ";float:$alignment";
					$class .= ' '.$alignment;
				}
				$alignment = _valign($align);
				if ($alignment) {
					$imgvalign = (preg_match('/(top|bottom)/', $alignment) ? 'text-' . $alignment : $alignment);
					if ($imgvalign)
						$style .= ";vertical-align:$imgvalign";
					if ($aligment)
						$class .= ' '.$this->css["class_align_$alignment"];
				}
			} else {
				$alignment = _halign($align) or _valign($align);
				if ($alignment)
					$tag .= " align=\"$alignment\"";
			}
		}
		if (isset($extra)) {
			if (preg_match('/\(([^\)]+)\)/', $extra, $matches))
				$alt = $matches[1];
			$extra = preg_replace('/\([^\)]+\)/', '', $extra, 1);
			if (preg_match('/(?:^|\s)(\d+)%(?:\s|$)/', $extra, $matches))
				$pct = $matches[1];
			if (!$pct) {
				if (preg_match('/(?:^|\s)(\d+)%x(\d+)%(?:\s|$)/', $extra, $matches)) {
					$pctw = $matches[1];
					$pcth = $matches[2];
				}
			} else {
				$pctw = $pct;
				$pcth = $pct;
			}
			if (!$pctw && !$pcth) {
				if (preg_match('/(?:^|\s)(\d+|\*)x(\d+|\*)(?:\s|$)/', $extra, $matches)) {
					$w = $matches[1];
					$h = $matches[2];
				}
				if ($w == '*')
					$w = '';
				if ($h == '*')
					$h = '';
				if (!$w)
					if (preg_match('/(^|[,\s])(\d+)w([\s,]|$)/', $extra, $matches))
						$w = $matches[1];
				if (!$h)
					if (preg_match('/(^|[,\s])(\d+)h([\s,]|$)/', $extra, $matches))
						$h = $matches[1];
			}
		}
		if (!isset($alt))
			$alt = '';
		if (!preg_match('/^xhtml2/', $this->flavor)) {
			$tag .= ' alt="' . $this->encode_html_basic($alt) . '"';
		}
		if ($w && $h) {
			if (!preg_match('/^xhtml2/', $this->flavor)) {
				$tag .= " height=\"$h\" width=\"$w\"";
			} else {
				$style .= ";height:$h\px;width:$w\px";
			}
		} else {
			list($image_w, $image_h) = $this->image_size($src);
			if (($image_w && $image_h) && ($w || $h)) {
				# image size determined, but only width or height specified
				if ($w && !$h) {
					# width defined, scale down height proportionately
					$h = int($image_h * ($w / $image_w));
				} elseif ($h && !$w) {
					$w = int($image_w * ($h / $image_h));
				}
			} else {
				$w = $image_w;
				$h = $image_h;
			}
			if ($w && $h) {
				if ($pctw || $pcth) {
					$w = int($w * $pctw / 100);
					$h = int($h * $pcth / 100);
				}
				if (preg_match('/^xhtml2', $this->flavor)) {
					$tag .= " height=\"$h\" width=\"$w\"";
				} else {
					$style .= ";height:$h\px;width:$w\px";
				}
			}
		}
		$attr = $this->format_classstyle($clsty, $class, $style);
		if ($attr)
			$tag .= " $attr";
		if (preg_match('/^xhtml2/', $this->flavor)) {
			$tag .= '><p>' . $this->encode_html_basic($alt) . '</p></object>';
		} elseif (preg_match('/^xhtml/', $this->flavor)) {
			$tag .= ' />';
		} else {
			$tag .= '>';
		}
		if ($link != '') {
			$link = preg_replace('/^:/', '', $link);
			$link = $this->format_url(array('url' => $link));
			$tag = '<a href="'.$link.'">'.$tag.'</a>';
		}
		return $pre.$tag.$post;
	}
	
	function format_table($args) {
		$str = array_key_exists('text',$args) ? $args['text'] : '';

		$lines = preg_split('/\n/', $str);
		$rows = array();
		$line_count = count($lines);
		for ($i = 0; $i < $line_count; $i++) {
			if (!preg_match('/\|\s*$/', $lines[$i])) {
				if ($i + 1 < $line_count) {
					if ($i+1 <= (count($lines) - 1))
						$lines[$i+1] = $lines[$i] . "\n" . $lines[$i+1];
				} else {
					$rows[] = $lines[$i];
				}
		   } else {
			   $rows[] = $lines[$i];
		   }
		}
		unset ($tid, $tpadl, $tpadr, $tlang);
		$tclass = '';
		$tstyle = '';
		$talign = '';
		if (preg_match('/^table[^\.]/', $rows[0])) {
			$row = $rows[0];
			$row = preg_replace('/^table/', '', $row);
			$params = 1;
			# process row parameters until none are left
			while ($params) {
				if (preg_match('/^('.$this->tblalignre.')/x', $row, $matches)) {
					# found row alignment
					$talign .= $matches[1];
					if ($matches[1]) {
    					$row = substr($row, strlen($matches[1]));
    					continue;
    				}
				}
				if (preg_match('/^('.$this->clstypadre.')/x', $row, $matches)) {
					# found a class/id/style/padding indicator
					$clsty = $matches[1];
					if ($clsty)
    					$row = substr($row, strlen($clsty));
					if (preg_match('/{([^}]+)}/', $clsty, $matches)) {
						$tstyle = $matches[1];
						$clsty = preg_replace('/{([^}]+)}/', '', $clsty);
						if ($tstyle)
    						continue;
					}
					if (preg_match('/\(([A-Za-z0-9_\- ]+?)(?:#(.+?))?\)/', $clsty, $matches) ||
						preg_match('/\(([A-Za-z0-9_\- ]+?)?(?:#(.+?))\)/', $clsty, $matches)) {
						if ($matches[1] or $matches[2]) {
							$tclass = $matches[1];
							$tid = $matches[2];
							continue;
						}
					}
					if (preg_match('/(\(+)/', $clsty, $matches))
    					$tpadl = strlen($matches[1]);
    				if (preg_match('/(\)+)/', $clsty, $matches))
    					$tpadr = strlen($matches[1]);
    				if (preg_match('/\[(.+?)\]/', $clsty, $matches))
    					$tlang = $matches[1];
    				if ($clsty)
    					continue;
				}
				$params = 0;
			}
			$row = preg_replace('/\.\s+/s', '', $row, 1);
			$rows[0] = $row;
		}
		$out = '';
		$cols = preg_split('/\|/', $rows[0].' ');
		$colaligns = array();
		$rowspans = array();
		foreach ($rows as $row) {
			$cols = preg_split('/\|/', $row.' ');
			$colcount = count($cols) - 1;
			array_pop($cols);
			$colspan = 0;
			$row_out = '';
			unset ($rowclass, $rowid, $rowalign, $rowstyle, $rowheader);
			if (!isset($cols[0]))
    			$cols[0] = '';
			if (preg_match('/_/', $cols[0])) {
				$cols[0] = preg_replace('/_/', '', $cols[0]);
				$rowheader = 1;
			}
			if (preg_match('/{([^}]+)}/', $cols[0], $matches)) {
				$rowstyle = $matches[1];
				$cols[0] = preg_replace('/{[^}]+}/', '', $cols[0]);
			}
			if (preg_match('/\(([^\#]+?)?(#(.+))?\)/', $cols[0], $matches)) {
				$rowclass = $matches[1];
				$rowid = $matches[3];
				$cols[0] = preg_replace('/\([^\)]+\)/', '', $cols[0]);
			}
			if (preg_match('/('.$this->alignre.')/x', $cols[0], $matches))
    			$rowalign = $matches[1];
			for ($c = $colcount - 1; $c > 0; $c--) {
				if ($rowspans[$c]) {
					$rowspans[$c]--;
					if ($rowspans[$c] > 1)
					    continue;
				}
				unset ($colclass, $colid, $header, $colparams, $colpadl, $colpadr, $collang);
				$colstyle = '';
				$colalign = $colaligns[$c];
				$col = array_pop($cols);
				$col or $col = '';
				$attrs = '';
				if (preg_match('/^(((_|[\/\\\\]\d+|'.$this->alignre.'|'.$this->clstypadre.')+)\. )/x', $col, $matches)) {
					$colparams = $matches[2];
					$col = substr($col, strlen($matches[1]));
					$params = 1;
					# keep processing column parameters until there
					# are none left...
					while ($params) {
						if (preg_match('/^(_|'.$this->alignre.')/x', $colparams, $matches)) {
							# found alignment or heading indicator
							$attrs .= $matches[1];
							if ($matches[1]) {
    							$colparams = substr($colparams, strlen($matches[1]));
    							continue;
    						}
						}
						if (preg_match('/^('.$this->clstypadre.')/x', $colparams, $matches)) {
							# found a class/id/style/padding marker
							$clsty = $matches[1];
							if ($matches[1])
    							$colparams = substr($colparams, strlen($matches[1]));
							if (preg_match('/{([^}]+)}/', $clsty, $matches)) {
								$colstyle = $matches[1];
								$clsty = preg_replace('/{([^}]+)}/', '', $clsty, 1);
							}
							if (preg_match('/\(([A-Za-z0-9_\- ]+?)(?:#(.+?))?\)/', $clsty, $matches) ||
								preg_match('/\(([A-Za-z0-9_\- ]+?)?(?:#(.+?))\)/', $clsty, $matches)) {
								if ($matches[1] or $matches[2]) {
									$colclass = $matches[1];
									$colid = $matches[2];
									if ($colclass) {
										$clsty = preg_replace('/\([A-Za-z0-9_\- ]+?(#.*?)?\)/', '', $clsty);
									} elseif ($colid) {
										$clsty = preg_replace('/\(#.+?\)/', '', $clsty);
									}
								}
							}
							if (preg_match('/(\(+)/', $clsty, $matches)) {
								$colpadl = strlen($matches[1]);
								$clsty = preg_replace('/\(+/', '', $clsty, 1);
							}
							if (preg_match('/(\)+)/', $clsty, $matches)) {
								$colpadr = strlen($matches[1]);
								$clsty = preg_replace('/\)+/', '', $clsty, 1);
							}
							if (preg_match('/\[(.+?)\]/', $clsty, $matches)) {
								$collang = $matches[1];
								$clsty = preg_replace('/\[.+?\]/', '', $clsty, 1);
							}
							if ($clsty)
							    continue;
						}
						if (preg_match('/^\\\\(\d+)/', $colparams, $matches)) {
							$colspan = $matches[1];
							$colparams = substr($colparams, strlen($matches[1])+1);
						    continue;
						}
						if (preg_match('/\/(\d+)/', $colparams, $matches)) {
						    if ($matches[1])
							    $rowspans[$c] = $matches[1];
							$colparams = substr($colparams, strlen($matches[1])+1);
							continue;
						}
						$params = 0;
					}
				}
				if (strlen($attrs)) {
				    if (preg_match('/_/', $attrs))
    					$header = 1;
    				if (preg_match('/('.$this->alignre.')/x', $attrs, $matches) && strlen($matches[1]))
					    $colalign = '';
					# determine column alignment
					if (preg_match('/<>/', $attrs)) {
						$colalign .= '<>';
					} elseif (preg_match('/</', $attrs)) {
						$colalign .= '<';
					} elseif (preg_match('/=/', $attrs)) {
						$colalign = '=';
					} elseif (preg_match('/>/', $attrs)) {
						$colalign = '>';
					}
					if (preg_match('/\^/', $attrs)) {
						$colalign .= '^';
					} elseif (preg_match('/~/', $attrs)) {
						$colalign .= '~';
					} elseif (preg_match('/-/', $attrs)) {
						$colalign .= '-';
					}
				}
				if ($rowheader)
				    $header = 1;
				if ($header)
				    $colaligns[$c] = $colalign;
				$col = preg_replace('/^ +/', '', $col);
				$col = preg_replace('/ +$/', '', $col);
				if (strlen($col)) {
					# create one cell tag
					$rowspan = $rowspans[$c];
					$col_out = '<' . ($header ? 'th' : 'td');
					if (!empty($colalign)) {
						# horizontal, vertical alignment
						$halign = _halign($colalign);
						if ($halign)
						    $col_out .= " align=\"$halign\"";
						$valign = _valign($colalign);
						if ($valign)
						    $col_out .= " valign=\"$valign\"";
					}
					# apply css attributes, row, column spans
					if ($colpadl)
					    $colstyle .= ";padding-left:$colpadl".'em';
					if ($colpadr)
					    $colstyle .= ";padding-right:$colpadr".'em';
					if ($colclass)
					    $col_out .= " class=\"$colclass\"";
					if ($colid)
					    $col_out .= " id=\"$colid\"";
					if ($colstyle)
					    $colstyle = preg_replace('/^;/', '', $colstyle);
					if ($colstyle)
    				    $col_out .= " style=\"$colstyle\"";
    				if ($collang)
					    $col_out .= " lang=\"$collang\"";
					if ($colspan > 1)
					    $col_out .= " colspan=\"$colspan\"";
					if ($rowspan > 1)
    					$col_out .= " rowspan=\"$rowspan\"";
					$col_out .= '>';
					# if the content of this cell has newlines OR matches
					# our paragraph block signature, process it as a full-blown
					# textile document
					if (preg_match('/\n\n/', $col) ||
						preg_match('/^(?:'.$this->halignre.'|'.$this->clstypadre.'*)*
									[\*\#]
									(?:'.$this->clstypadre.'*|'.$this->halignre.')*\ /x', $col, $matches)) {
						$col_out .= $this->TextileThis($col);
					} else {
						$col_out .= $this->format_paragraph(array('text' => $col));
					}
					$col_out .= '</' . ($header ? 'th' : 'td') . '>';
					$row_out = $col_out . $row_out;
					if ($colspan)
					    $colspan = 0;
				} else {
				    if ($colspan == 0)
					    $colspan = 1;
					$colspan++;
				}
			}
			if ($colspan > 1) {
				# handle the spanned column if we came up short
				$colspan--;
				$row_out = '<td'
						 . ($colspan>1 ? " colspan=\"$colspan\"" : '')
						 . "></td>$row_out";
			}
	
			# build one table row
			$out .= '<tr';
			if ($rowalign) {
				$valign = _valign($rowalign);
				if ($valign)
				    $out .= " valign=\"$valign\"";
			}
			if ($rowclass)
			    $out .= " class=\"$rowclass\"";
			if ($rowid)
			    $out .= " id=\"$rowid\"";
			if ($rowstyle)
			    $out .= " style=\"$rowstyle\"";
			$out .= ">$row_out</tr>";
		}
	
		# now, form the table tag itself
		$table = '';
		$table .= '<table';
		if ($talign) {
			if ($this->css_mode) {
				# horizontal alignment
				$alignment = _halign($talign);
				if ($talign == '=') {
					$tstyle .= ';margin-left:auto;margin-right:auto';
				} else {
				    if ($alignment)
					    $tstyle .= ';float:'.$alignment;
				}
				if ($alignment)
				    $tclass .= ' '.$alignment;
			} else {
				$alignment = _halign($talign);
				if ($alignment)
				    $table .= " align=\"$alignment\"";
			}
		}
		if ($tpadl)
		    $tstyle .= ";padding-left:$tpadl".'em';
		if ($tpadr)
		    $tstyle .= ";padding-right:$tpadr".'em';
		if ($tclass)
		    $tclass = preg_replace('/^ /', '', $tclass);
		if ($tclass)
		    $table .= " class=\"$tclass\"";
		if ($tid)
		    $table .= " id=\"$tid\"";
		if ($tstyle)
		    $tstyle = preg_replace('/^;/', '', $tstyle);
		if ($tstyle)
		    $table .= " style=\"$tstyle\"";
		if ($tlang)
		    $table .= " lang=\"$tlang\"";
		if ($tclass || $tid || $tstyle)
		    $table .= ' cellspacing="0"';
		$table .= ">$out</table>";
		if (preg_match('|<tr></tr>|', $table)) {
			# exception -- something isn't right so return fail case
			return null;
		}
	
		return $table;
	}
	
	function apply_filters($args) {
		$text = $args['text'];
		if (!isset($text))
			return '';
		$list = $args['filters'];
		$filters = $this->filters;
		if (!is_array($filters))
			return $text;
	
		$param = $this->filter_param;
		foreach ($list as $filter) {
			if (!array_key_exists($filter, $filters))
				continue;
			if (is_callable($filters[$filter])) {
				$text = $filters[$filter]($text, $param);
			}
		}
		$text;
	}
	
	# minor utility / formatting routines
	
	function encode_html($html, $can_double_encode = 0) {
		if (!isset($html))
			return '';
		if ($this->char_encoding) {
			$html = htmlentities($html);
		} else {
			$html = $this->encode_html_basic($html, $can_double_encode);
		}
		return $html;
	}
	
	function decode_html($html) {
		$html = preg_replace('/&quot;/', '"', $html);
		$html = preg_replace('/&amp;/', '&', $html);
		$html = preg_replace('/&lt;/', '<', $html);
		$html = preg_replace('/&gt;/', '>', $html);
		return $html;
	}
	
	function encode_html_basic($html, $can_double_encode = 0) {
	    //$html = stripslashes($html);
		if (!isset($html))
			return '';
		if (!preg_match('/[^\w\s]/', $html))
			return $html;
		if ($can_double_encode)
			$html = preg_replace('/&/', '&amp;', $html);
		else {
			## Encode any & not followed by something that looks like
			## an entity, numeric or otherwise.
			$html = preg_replace('/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w{1,8});)/', '&amp;', $html);
		}
		$html = preg_replace('/"/', '&quot;', $html);
		$html = preg_replace('/</', '&lt;', $html);
		$html = preg_replace('/>/', '&gt;', $html);
		return $html;
	}
	
	function image_size($file) {
		if ($Have_ImageSize) {
			if (file_exists($file)) {
				#return Image::Size::imgsize($file);
			} else {
				if ($docroot = $this->docroot) {
					#require File::Spec;
					#$fullpath = File::Spec->catfile($docroot, $file);
					#if (-f $fullpath) {
					#	return Image::Size::imgsize($fullpath);
					#}
				}
			}
		}
		return;
	}
	
	function encode_url($str) {
		$str = preg_replace_callback('/([^A-Za-z0-9_\.\-\+\&=\%;])/x',
		    array(&$this, '_replace_enc_char'), $str);
		return $str;
		#return urlencode($str);
	}
	
	function mail_encode($addr) {
		$addr = preg_replace_callback('/([^\$])/x',
			 array(&$this, '_replace_enc_char'), $addr);
		return $addr;
	}
	
	function process_quotes($str) {
		return $str;
	}
	
	# a default set of macros for the {...} macro syntax
	# just a handy way to write a lot of the international characters
	# and some commonly used symbols
	
	function default_macros() {
		# <, >, " must be html entities in the macro text since
		# those values are escaped by the time they are processed
		# for macros.
		return array(
		  'c|' => '&#162;', # CENT SIGN
		  '|c' => '&#162;', # CENT SIGN
		  'L-' => '&#163;', # POUND SIGN
		  '-L' => '&#163;', # POUND SIGN
		  'Y=' => '&#165;', # YEN SIGN
		  '=Y' => '&#165;', # YEN SIGN
		  '(c)' => '&#169;', # COPYRIGHT SIGN
		  '&lt;&lt;' => '&#171;', # LEFT-POINTING DOUBLE ANGLE QUOTATION
		  '(r)' => '&#174;', # REGISTERED SIGN
		  '+_' => '&#177;', # PLUS-MINUS SIGN
		  '_+' => '&#177;', # PLUS-MINUS SIGN
		  '&gt;&gt;' => '&#187;', # RIGHT-POINTING DOUBLE ANGLE QUOTATION
		  '1/4' => '&#188;', # VULGAR FRACTION ONE QUARTER
		  '1/2' => '&#189;', # VULGAR FRACTION ONE HALF
		  '3/4' => '&#190;', # VULGAR FRACTION THREE QUARTERS
		  'A`' => '&#192;', # LATIN CAPITAL LETTER A WITH GRAVE
		  '`A' => '&#192;', # LATIN CAPITAL LETTER A WITH GRAVE
		  'A\'' => '&#193;', # LATIN CAPITAL LETTER A WITH ACUTE
		  '\'A' => '&#193;', # LATIN CAPITAL LETTER A WITH ACUTE
		  'A^' => '&#194;', # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
		  '^A' => '&#194;', # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
		  'A~' => '&#195;', # LATIN CAPITAL LETTER A WITH TILDE
		  '~A' => '&#195;', # LATIN CAPITAL LETTER A WITH TILDE
		  'A"' => '&#196;', # LATIN CAPITAL LETTER A WITH DIAERESIS
		  '"A' => '&#196;', # LATIN CAPITAL LETTER A WITH DIAERESIS
		  'Ao' => '&#197;', # LATIN CAPITAL LETTER A WITH RING ABOVE
		  'oA' => '&#197;', # LATIN CAPITAL LETTER A WITH RING ABOVE
		  'AE' => '&#198;', # LATIN CAPITAL LETTER AE
		  'C,' => '&#199;', # LATIN CAPITAL LETTER C WITH CEDILLA
		  ',C' => '&#199;', # LATIN CAPITAL LETTER C WITH CEDILLA
		  'E`' => '&#200;', # LATIN CAPITAL LETTER E WITH GRAVE
		  '`E' => '&#200;', # LATIN CAPITAL LETTER E WITH GRAVE
		  'E\'' => '&#201;', # LATIN CAPITAL LETTER E WITH ACUTE
		  '\'E' => '&#201;', # LATIN CAPITAL LETTER E WITH ACUTE
		  'E^' => '&#202;', # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
		  '^E' => '&#202;', # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
		  'E"' => '&#203;', # LATIN CAPITAL LETTER E WITH DIAERESIS
		  '"E' => '&#203;', # LATIN CAPITAL LETTER E WITH DIAERESIS
		  'I`' => '&#204;', # LATIN CAPITAL LETTER I WITH GRAVE
		  '`I' => '&#204;', # LATIN CAPITAL LETTER I WITH GRAVE
		  'I\'' => '&#205;', # LATIN CAPITAL LETTER I WITH ACUTE
		  '\'I' => '&#205;', # LATIN CAPITAL LETTER I WITH ACUTE
		  'I^' => '&#206;', # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
		  '^I' => '&#206;', # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
		  'I"' => '&#207;', # LATIN CAPITAL LETTER I WITH DIAERESIS
		  '"I' => '&#207;', # LATIN CAPITAL LETTER I WITH DIAERESIS
		  'D-' => '&#208;', # LATIN CAPITAL LETTER ETH
		  '-D' => '&#208;', # LATIN CAPITAL LETTER ETH
		  'N~' => '&#209;', # LATIN CAPITAL LETTER N WITH TILDE
		  '~N' => '&#209;', # LATIN CAPITAL LETTER N WITH TILDE
		  'O`' => '&#210;', # LATIN CAPITAL LETTER O WITH GRAVE
		  '`O' => '&#210;', # LATIN CAPITAL LETTER O WITH GRAVE
		  'O\'' => '&#211;', # LATIN CAPITAL LETTER O WITH ACUTE
		  '\'O' => '&#211;', # LATIN CAPITAL LETTER O WITH ACUTE
		  'O^' => '&#212;', # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
		  '^O' => '&#212;', # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
		  'O~' => '&#213;', # LATIN CAPITAL LETTER O WITH TILDE
		  '~O' => '&#213;', # LATIN CAPITAL LETTER O WITH TILDE
		  'O"' => '&#214;', # LATIN CAPITAL LETTER O WITH DIAERESIS
		  '"O' => '&#214;', # LATIN CAPITAL LETTER O WITH DIAERESIS
		  'O/' => '&#216;', # LATIN CAPITAL LETTER O WITH STROKE
		  '/O' => '&#216;', # LATIN CAPITAL LETTER O WITH STROKE
		  'U`' =>  '&#217;', # LATIN CAPITAL LETTER U WITH GRAVE
		  '`U' =>  '&#217;', # LATIN CAPITAL LETTER U WITH GRAVE
		  'U\'' => '&#218;', # LATIN CAPITAL LETTER U WITH ACUTE
		  '\'U' => '&#218;', # LATIN CAPITAL LETTER U WITH ACUTE
		  'U^' => '&#219;', # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
		  '^U' => '&#219;', # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
		  'U"' => '&#220;', # LATIN CAPITAL LETTER U WITH DIAERESIS
		  '"U' => '&#220;', # LATIN CAPITAL LETTER U WITH DIAERESIS
		  'Y\'' => '&#221;', # LATIN CAPITAL LETTER Y WITH ACUTE
		  '\'Y' => '&#221;', # LATIN CAPITAL LETTER Y WITH ACUTE
		  'a`' => '&#224;', # LATIN SMALL LETTER A WITH GRAVE
		  '`a' => '&#224;', # LATIN SMALL LETTER A WITH GRAVE
		  'a\'' => '&#225;', # LATIN SMALL LETTER A WITH ACUTE
		  '\'a' => '&#225;', # LATIN SMALL LETTER A WITH ACUTE
		  'a^' => '&#226;', # LATIN SMALL LETTER A WITH CIRCUMFLEX
		  '^a' => '&#226;', # LATIN SMALL LETTER A WITH CIRCUMFLEX
		  'a~' => '&#227;', # LATIN SMALL LETTER A WITH TILDE
		  '~a' => '&#227;', # LATIN SMALL LETTER A WITH TILDE
		  'a"' => '&#228;', # LATIN SMALL LETTER A WITH DIAERESIS
		  '"a' => '&#228;', # LATIN SMALL LETTER A WITH DIAERESIS
		  'ao' => '&#229;', # LATIN SMALL LETTER A WITH RING ABOVE
		  'oa' => '&#229;', # LATIN SMALL LETTER A WITH RING ABOVE
		  'ae' => '&#230;', # LATIN SMALL LETTER AE
		  'c,' => '&#231;', # LATIN SMALL LETTER C WITH CEDILLA
		  ',c' => '&#231;', # LATIN SMALL LETTER C WITH CEDILLA
		  'e`' => '&#232;', # LATIN SMALL LETTER E WITH GRAVE
		  '`e' => '&#232;', # LATIN SMALL LETTER E WITH GRAVE
		  'e\'' => '&#233;', # LATIN SMALL LETTER E WITH ACUTE
		  '\'e' => '&#233;', # LATIN SMALL LETTER E WITH ACUTE
		  'e^' => '&#234;', # LATIN SMALL LETTER E WITH CIRCUMFLEX
		  '^e' => '&#234;', # LATIN SMALL LETTER E WITH CIRCUMFLEX
		  'e"' => '&#235;', # LATIN SMALL LETTER E WITH DIAERESIS
		  '"e' => '&#235;', # LATIN SMALL LETTER E WITH DIAERESIS
		  'i`' => '&#236;', # LATIN SMALL LETTER I WITH GRAVE
		  '`i' => '&#236;', # LATIN SMALL LETTER I WITH GRAVE
		  'i\'' => '&#237;', # LATIN SMALL LETTER I WITH ACUTE
		  '\'i' => '&#237;', # LATIN SMALL LETTER I WITH ACUTE
		  'i^' => '&#238;', # LATIN SMALL LETTER I WITH CIRCUMFLEX
		  '^i' => '&#238;', # LATIN SMALL LETTER I WITH CIRCUMFLEX
		  'i"' => '&#239;', # LATIN SMALL LETTER I WITH DIAERESIS
		  '"i' => '&#239;', # LATIN SMALL LETTER I WITH DIAERESIS
		  'n~' => '&#241;', # LATIN SMALL LETTER N WITH TILDE
		  '~n' => '&#241;', # LATIN SMALL LETTER N WITH TILDE
		  'o`' => '&#242;', # LATIN SMALL LETTER O WITH GRAVE
		  '`o' => '&#242;', # LATIN SMALL LETTER O WITH GRAVE
		  'o\'' => '&#243;', # LATIN SMALL LETTER O WITH ACUTE
		  '\'o' => '&#243;', # LATIN SMALL LETTER O WITH ACUTE
		  'o^' => '&#244;', # LATIN SMALL LETTER O WITH CIRCUMFLEX
		  '^o' => '&#244;', # LATIN SMALL LETTER O WITH CIRCUMFLEX
		  'o~' => '&#245;', # LATIN SMALL LETTER O WITH TILDE
		  '~o' => '&#245;', # LATIN SMALL LETTER O WITH TILDE
		  'o"' => '&#246;', # LATIN SMALL LETTER O WITH DIAERESIS
		  '"o' => '&#246;', # LATIN SMALL LETTER O WITH DIAERESIS
		  ':-' => '&#247;', # DIVISION SIGN
		  '-:' => '&#247;', # DIVISION SIGN
		  'o/' => '&#248;', # LATIN SMALL LETTER O WITH STROKE
		  '/o' => '&#248;', # LATIN SMALL LETTER O WITH STROKE
		  'u`' => '&#249;', # LATIN SMALL LETTER U WITH GRAVE
		  '`u' => '&#249;', # LATIN SMALL LETTER U WITH GRAVE
		  'u\'' => '&#250;', # LATIN SMALL LETTER U WITH ACUTE
		  '\'u' => '&#250;', # LATIN SMALL LETTER U WITH ACUTE
		  'u^' => '&#251;', # LATIN SMALL LETTER U WITH CIRCUMFLEX
		  '^u' => '&#251;', # LATIN SMALL LETTER U WITH CIRCUMFLEX
		  'u"' => '&#252;', # LATIN SMALL LETTER U WITH DIAERESIS
		  '"u' => '&#252;', # LATIN SMALL LETTER U WITH DIAERESIS
		  'y\'' => '&#253;', # LATIN SMALL LETTER Y WITH ACUTE
		  '\'y' => '&#253;', # LATIN SMALL LETTER Y WITH ACUTE
		  'y"' => '&#255;', # LATIN SMALL LETTER Y WITH DIAERESIS
		  '"y' => '&#255;', # LATIN SMALL LETTER Y WITH DIAERESIS
		  'OE' => '&#338;', # LATIN CAPITAL LIGATURE OE
		  'oe' => '&#339;', # LATIN SMALL LIGATURE OE
		  '*' => '&#2022;', # BULLET
		  'Fr' => '&#8355;', # FRENCH FRANC SIGN
		  'L=' => '&#8356;', # LIRA SIGN
		  '=L' => '&#8356;', # LIRA SIGN
		  'Rs' => '&#8360;', # RUPEE SIGN
		  'C=' => '&#8364;', # EURO SIGN
		  '=C' => '&#8364;', # EURO SIGN
		  'tm' => '&#8482;', # TRADE MARK SIGN
		  '&lt;-' => '&#8592;', # LEFTWARDS ARROW
		  '-&gt;' => '&#8594;', # RIGHTWARDS ARROW
		  '&lt;=' => '&#8656;', # LEFTWARDS DOUBLE ARROW
		  '=&gt;' => '&#8658;', # RIGHTWARDS DOUBLE ARROW
		  '=/' => '&#8800;', # NOT EQUAL TO
		  '/=' => '&#8800;', # NOT EQUAL TO
		  '&lt;_' => '&#8804;', # LESS-THAN OR EQUAL TO
		  '_&lt;' => '&#8804;', # LESS-THAN OR EQUAL TO
		  '&gt;_' => '&#8805;', # GREATER-THAN OR EQUAL TO
		  '_&gt;' => '&#8805;', # GREATER-THAN OR EQUAL TO
		  ':(' => '&#9785;', # WHITE FROWNING FACE
		  ':)' => '&#9786;', # WHITE SMILING FACE
		  'spade' => '&#9824;', # BLACK SPADE SUIT
		  'club' => '&#9827;', # BLACK CLUB SUIT
		  'heart' => '&#9829;', # BLACK HEART SUIT
		  'diamond' => '&#9830;', # BLACK DIAMOND SUIT
		);
	}
	
	# "private", internal routines
	
	function _css_defaults() {
		$css_defaults = array(
		   'class_align_right' => 'right',
		   'class_align_left' => 'left',
		   'class_align_center' => 'center',
		   'class_align_top' => 'top',
		   'class_align_bottom' => 'bottom',
		   'class_align_middle' => 'middle',
		   'class_align_justify' => 'justify',
		   'class_caps' => 'caps',
		   'class_footnote' => 'footnote',
		   'id_footnote_prefix' => 'fn',
		);
		$this->set_css($css_defaults);
	}

    function tokenize($str) {
    	$tokens = array();

    	$depth = 6;
    	$tag = array();
    	for ($i = 0; $i < $depth; $i++) {
    	    $tag[] = '(?:<\/?[A-Za-z0-9:]+ \s? (?:[^<>]';
    	}
    	$nested_tags = implode('|', $tag) . str_repeat(')*>)',$depth);
    	$match = '/((?s: <! ( -- .*? -- \s* )+ > )|
    			  (?s: <\? .*? \?> )|
    			  (?s: <% .*? %> )|
    			  '.$nested_tags.'|
    			  '.$this->codere2.')/x';
    	$items = preg_split($match, $str, -1, PREG_SPLIT_DELIM_CAPTURE);
		foreach ($items as $item) {
			if (preg_match('/^[[{]?\@/', $item)) {
				$tokens[] = array('text', $item);
			} elseif (preg_match($match, $item)) {
	    		$item = preg_replace('/\n/', "\001", $item);
    			$tokens[] = array('tag', $item);
    		} else {
    			$tokens[] = array('text', $item);
    		}
    	}
    	return $tokens;
    }
}

function _halign($align) {
	if (preg_match('/<>/', $align)) {
		return 'justify';
	} elseif (preg_match('/</', $align)) {
		return 'left';
	} elseif (preg_match('/>/', $align)) {
		return 'right';
	} elseif (preg_match('/=/', $align)) {
		return 'center';
	}
	return '';
}

function _valign($align) {
	if (preg_match('/\^/', $align)) {
		return 'top';
	} elseif (preg_match('/~/', $align)) {
		return 'bottom';
	} elseif (preg_match('/-/', $align)) {
		return 'middle';
	}
	return '';
}

function _imgalign($align) {
	$align = preg_replace('/(<>|=)/', '', $align);
	return _valign($align) or _halign($align);
}

function _strip_borders(&$pre, &$post) {
	$open = substr($pre, 0, 1);
	if ($post && $pre && preg_match('/[{[]/', $open)) {
		$close = substr($post, 0, 1);
		if ((($open == '{') && ($close == '}')) ||
			(($open == '[') && ($close == ']'))) {
			$pre = substr($pre, 1);
			$post = substr($post, 1);
		} else {
			if (!preg_match('/[}\]]/', $close))
				$close = substr($post, -1, 1);
			if ((($open == '{') & ($close == '}')) ||
				(($open == '[') & ($close == ']'))) {
				$pre = substr($pre, 1);
				$post = substr($post, 0, strlen($post) - 1);
			}
		}
	}
	return array($pre, $post);
}
?>
