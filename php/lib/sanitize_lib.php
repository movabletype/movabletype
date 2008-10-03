<?php
require_once("MTUtil.php");
function sanitize($s, $arg) {
    if (($arg) && (!is_array($arg)))
        $arg = sanitize_parse_spec($arg);
    $ok_tags = $arg['ok'];
    $tag_attr = $arg['tag_attr'];
    $s = preg_replace('/\x00/', '', $s);
    $closings = array('<'.'?' => '?'.'>', '<!--' => '-->', '<%' => '%>');
    $tokens = preg_split('/(<(?:!--|%|\?)|<\/\w*|<\w*|(?:-->|%>|\?'.'>|>))/', $s, -1, PREG_SPLIT_DELIM_CAPTURE);
    $open_tag_a = array();
    $open_tag_h = array();

    $toknum = 0;
    $result = '';
    while ($toknum < count($tokens)) {
        $token = $tokens[$toknum];
        if (isset($closings[$token])) {
            $toknum = sanitize_tokens_up_to($tokens, $toknum, $closings[$token]);
        } elseif (substr($token, 0, 1) == '<') {
            $closure = 0;
            $name = strtolower(substr($token, 1));
            $start = $toknum;
            $end = sanitize_tokens_up_to($tokens, $start, '>');
            $toknum = $end;
            if (substr($name, 0, 1) == '/') {
                $name = substr($name, 1);
                $closure = 1;
            }
            if (isset($ok_tags[$name])) {
                if ($tag_attr[$name] == '/')
                    $closure = 2;

                # process attribute list...
                $inside = sanitize_output_tokens($tokens, $start + 1, $end - 1);
                if (preg_match('!/>$!', $inside))
                    $closure = 2;
                $inside = preg_replace('!/?>$!', '', $inside);
                $attrs = '';
                if (preg_match_all('/\s*(\w+)\s*=(?:([\'"])(.*?)\2|([^\s]+))\s*/s', $inside, $matches, PREG_SET_ORDER)) {
                    foreach ($matches as $match) {
                        $attr = strtolower($match[1]);
                        if (isset($match[4])) {
                            $value = $match[4];
                            $value = '"' . preg_replace('/"/', '&quot;', $value) . '"';
                            $dec_val = decode_html($match[4]);
                        } else {
                            $value = $match[2] . $match[3] . $match[2];
                            $dec_val = decode_html($match[3]);
                        }
                        if (isset($ok_tags[$name][$attr]) ||
                            isset($ok_tags['*'][$attr])) {
                            $safe = 1;
                            if (preg_match('/^(src|href|dynsrc)$/', $attr)) {
                                $dec_val = preg_replace('/&#0*58(?:=;|[^0-9])/', ':', $dec_val);
                                $dec_val = preg_replace('/&#x0*3[Aa](?:=;|[^a-fA-F0-9])/', ':', $dec_val);
                                if (preg_match('/^([\s\S]+?):/', $dec_val, $proto_match)) {
                                    $proto = $proto_match[1];
                                    if (preg_match('/[\r\n\t]/', $proto)) {
                                        $safe = 0;
                                    } else {
                                        $proto = preg_replace('/\s+/s', '', $proto);
                                        if (preg_match('/[^a-zA-Z0-9\\+]/', $proto))
                                            $safe = 0;
                                        elseif (preg_match('/script$/i', $proto))
                                            $safe = 0;
                                    }
                                }
                            }
                            if ($safe)
                                $attrs .= ' ' . $attr . '=' . $value;
                        }
                    }
                }

                if (($closure != 1) || ($closure == 1 && isset($open_tag_h[$name]))) {
                    if ($closure == 1) {
                        $result .= sanitize_expel_up_to($open_tag_a, $open_tag_h, $name);
                    } elseif (!$closure) {
                        $open_tag_a[] = $name;
                        $open_tag_h[$name]++;
                    }
                }
                $result .= '<' .
                           ($closure == 1 ? '/' : '') .
                           $name .
                           $attrs .
                           ($closure == 2 ? ' /' : '') . '>';
                if ($closure == 1)
                    $open_tag_h[$name]--;
            }
        } else {
            if (strlen($token) > 0)
                $result .= $token;
            $toknum++;
        }
    }
    $result .= sanitize_expel_up_to($open_tag_a, $open_tag_h, null);
    return $result;
}

function sanitize_parse_spec($a) {
    $ok_tags = array();
    $tag_attr = array();
    $rules = preg_split('/\s*,\s*/', $a);
    foreach ($rules as $rule) {
        $ok_attr = array();
        $tag = strtolower($rule);
        $style = '';
        if (preg_match('|^([^\s]+)\s+(.+)$|', $tag, $matches)) {
            $tag = $matches[1];
            $attrs = $matches[2];
            if (preg_match('!/$!', $tag)) {
                $tag = substr($tag, 0, strlen($tag) - 1);
                $style = '/';
            }
            $a_attr = preg_split('/\s+/', $attrs);
            foreach ($a_attr as $attr) {
                $ok_attr[$attr] = 1;
            }
        } else {
            if (preg_match('!/$!', $tag)) {
                $tag = substr($tag, 0, strlen($tag) - 1);
                $style = '/';
            }
        }
        if ($style) $tag_attr[$tag] = $style;
        $ok_tags[$tag] = count($ok_attr) ? $ok_attr : 1;
    }
    return array('ok' => $ok_tags, 'tag_attr' => $tag_attr);
}

function sanitize_expel_up_to(&$open_tag_a, &$open_tag_h, $stop_tag) {
    $out = '';
    while (count($open_tag_a) &&
           (empty($stop_tag) || $open_tag_a[count($open_tag_a)-1] != $stop_tag)) {
        $t = array_pop($open_tag_a);
        $open_tag_h[$t]--;
        $out .= '</' . $t . '>';
    }
    if (count($open_tag_a))
        $t = array_pop($open_tag_a);
    return $out;
}

function sanitize_tokens_up_to($tokens, $i, $closure) {
    while ($i < count($tokens)) {
        if ($tokens[$i++] == $closure)
            break;
    }
    return $i;
}

function sanitize_output_tokens($tokens, $start, $end) {
    $out = '';
    for ($i = $start; $i <= $end; $i++)
        $out .= $tokens[$i];
    return $out;
}
?>
