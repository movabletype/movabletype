<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function datetime_to_timestamp($dt) {
    $dt = preg_replace('/[^0-9]/', '', $dt);
    $ts = mktime(substr($dt, 8, 2), substr($dt, 10, 2), substr($dt, 12, 2), substr($dt, 4, 2), substr($dt, 6, 2), substr($dt, 0, 4));
    return $ts;
}

function start_end_ts($ts) {
    if ($ts) {
        if (strlen($ts) == 4) {
            $ts_start = $ts . '0101';
            $ts_end = $ts . '1231';
        } elseif (strlen($ts) == 6) {
            $ts_start = $ts . '01';
            $ts_end = $ts . sprintf("%02d", days_in(substr($ts, 4, 2), substr($ts, 0, 4)));
        } else {
            $ts_start = $ts;
            $ts_end = $ts;
        }
    }
    return array($ts_start . '000000', $ts_end . '235959');
}

function start_end_month($ts) {
    $y = substr($ts, 0, 4);
    $mo = substr($ts, 4, 2);
    $start = sprintf("%04d%02d01000000", $y, $mo);
    $end = sprintf("%04d%02d%02d235959", $y, $mo, days_in($mo, $y));
    return array($start, $end);
}

function days_in($m, $y) {
    return date('t', mktime(0, 0, 0, $m, 1, $y));
}

function start_end_day($ts) {
    $day = substr($ts, 0, 8);
    return array($day . "000000", $day . "235959");
}

function start_end_year($ts) {
    $year = substr($ts, 0, 4);
    return array($year . "0101000000", $year . "1231235959");
}

function start_end_week($ts) {
    $y = substr($ts, 0, 4);
    $mo = substr($ts, 4, 2);
    $d = substr($ts, 6, 2);
    $h = substr($ts, 8, 2);
    $s = substr($ts, 10, 2);
    $wday = wday_from_ts($y, $mo, $d);
    list($sd, $sm, $sy) = array($d - $wday, $mo, $y);
    if ($sd < 1) {
        $sm--;
        if ($sm < 1) {
            $sm = 12; $sy--;
        }
        $sd += days_in($sm, $sy);
    }
    $start = sprintf("%04d%02d%02d%s", $sy, $sm, $sd, "000000");
    list($ed, $em, $ey) = array($d + 6 - $wday, $mo, $y);
    if ($ed > days_in($em, $ey)) {
        $ed -= days_in($em, $ey);
        $em++;
        if ($em > 12) {
            $em = 1; $ey++;
        }
    }
    $end = sprintf("%04d%02d%02d%s", $ey, $em, $ed, "235959");
    return array($start, $end);
}

global $In_Year;
$In_Year = array(
    array( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 ),
    array( 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 ),
);
function week2ymd($y, $week) {
    $jan_one_dow_m1 = (ymd2rd($y, 1, 1) + 6) % 7;

    if ($jan_one_dow_m1 < 4) $week--;
    $day_of_year = $week * 7 - $jan_one_dow_m1;
    $leap_year = is_leap_year($y);
    if ($day_of_year < 1) {
        $y--;
        $day_of_year = ($leap_year ? 366 : 365) + $day_of_year;
    }
    if ($leap_year) {
        $ref = array(0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335);
    } else {
        $ref = array(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);
    }
    $m = 0;
    for ($i = count($ref); $i > 0; $i--) {
        if ($day_of_year > $ref[$i-1]) {
            $m = $i;
            break;
        }
    }
    return array($y, $m, $day_of_year - $ref[$m-1]);
}

function is_leap_year($y) {
    return (!($y % 4) && ($y % 100)) || !($y % 400) ? true : false;
}

function ymd2rd($y,$m,$d) {
    # make month in range 3..14 (treat Jan & Feb as months 13..14 of
    # prev year)
    if ( $m <= 2 ) {
        $adj = (int)(( 14 - $m ) / 12);
        $y -= $adj;
        $m += 12 * $adj;
    }
    elseif ( $m > 14 )
    {
        $adj = (int)(( $m - 3 ) / 12);
        $y += $adj;
        $m -= 12 * $adj;
    }

    # make year positive (oh, for a use integer 'sane_div'!)
    if ( $y < 0 )
    {
        $adj = (int)(( 399 - $y ) / 400);
        $d -= 146097 * $adj; 
        $y += 400 * $adj;
    }

    # add: day of month, days of previous 0-11 month period that began
    # w/March, days of previous 0-399 year period that began w/March
    # of a 400-multiple year), days of any 400-year periods before
    # that, and 306 days to adjust from Mar 1, year 0-relative to Jan
    # 1, year 1-relative (whew)
    $d += (int)(( $m * 367 - 1094 ) / 12) + (int)((($y % 100) * 1461) / 4) +
          ( (int)($y / 100) * 36524 + (int)($y / 400) ) - 306;
    return $d;
}

function wday_from_ts($y, $m, $d) {
    global $In_Year;
    $leap = $y % 4 == 0 && ($y % 100 != 0 || $y % 400 == 0) ? 1 : 0;
    $y--;

    ## Copied from Date::Calc.
    $days = $y * 365;
    $days += $y >>= 2;
    $days -= intval($y /= 25);
    $days += $y >> 2;
    $days += $In_Year[$leap][$m-1] + $d;
    return $days % 7;
}

function yday_from_ts($y, $m, $d) {
    global $In_Year;
    $leap = $y % 4 == 0 && ($y % 100 != 0 || $y % 400 == 0) ? 1 : 0;
    return $In_Year[$leap][$m-1] + $d;
}

function substr_wref($str, $start, $length) {
    if (preg_match_all('/(&[^;]*;|.)/', $str, $character_entities)) {
        return implode('', array_slice($character_entities[0], $start, $length));
    } else {
        return '';
    }
}

function format_ts($format, $ts, $blog, $lang = null) {
    global $Languages;
    if (!isset($lang) || empty($lang)) { 
        $mt = MT::get_instance();
        $lang = (
              $blog && $blog->blog_date_language
            ? $blog->blog_date_language
            : $mt->config('DefaultLanguage')
        );
    }
    if ($lang == 'jp') {
        $lang = 'ja';
    }
    $lang = strtolower(substr($lang, 0, 2));
    if (!isset($format) || empty($format)) {
        if (count($Languages[$lang]) >= 4)
            $format = $Languages[$lang][3];
        $format or $format = "%B %e, %Y %l:%M %p";
    }
    global $_format_ts_cache;
    if (!isset($_format_ts_cache)) {
        $_format_ts_cache = array();
    }   
    if (isset($_format_ts_cache[$ts.$lang])) {
        $f = $_format_ts_cache[$ts.$lang];
    } else {
        $L = $Languages[$lang];
        $tsa = array(substr($ts, 0, 4), substr($ts, 4, 2), substr($ts, 6, 2),
                     substr($ts, 8, 2), substr($ts, 10, 2), substr($ts, 12, 2));
        list($f['Y'], $f['m'], $f['d'], $f['H'], $f['M'], $f['S']) = $tsa;
        $f['w'] = wday_from_ts($tsa[0],$tsa[1],$tsa[2]);
        $f['j'] = yday_from_ts($tsa[0],$tsa[1],$tsa[2]);
        $f['y'] = substr($f['Y'], 2);
        $f['b'] = substr_wref($L[1][$f['m']-1], 0, 3);
        $f['B'] = $L[1][$f['m']-1];
        if ($lang == 'ja') {
            $f['a'] = substr($L[0][$f['w']], 0, 8);
        } else {
            $f['a'] = substr_wref($L[0][$f['w']], 0, 3);
        }
        $f['A'] = $L[0][$f['w']];
        $f['e'] = $f['d'];
        $f['e'] = preg_replace('!^0!', ' ', $f['e']);
        $f['I'] = $f['H'];
        if ($f['I'] > 12) {
            $f['I'] -= 12;
            $f['p'] = $L[2][1];
        } elseif ($f['I'] == 0) {
            $f['I'] = 12;
            $f['p'] = $L[2][0];
        } elseif ($f['I'] == 12) {
            $f['p'] = $L[2][1];
        } else {
            $f['p'] = $L[2][0];
        }
        $f['I'] = sprintf("%02d", $f['I']);
        $f['k'] = $f['H'];
        $f['k'] = preg_replace('!^0!', ' ', $f['k']);
        $f['l'] = $f['I'];
        $f['l'] = preg_replace('!^0!', ' ', $f['l']);
        $f['j'] = sprintf("%03d", $f['j']);
        $f['Z'] = '';
        $_format_ts_cache[$ts . $lang] = $f;
    }
    $date_format = null;
    if (count($Languages[$lang]) >= 5)
        $date_format = $Languages[$lang][4];
    $date_format or $date_format = "%B %e, %Y";
    $time_format = null;
    if (count($Languages[$lang]) >= 6)
        $time_format = $Languages[$lang][5];
    $time_format or $time_format = "%l:%M %p";
    $format = preg_replace('!%x!', $date_format, $format);
    $format = preg_replace('!%X!', $time_format, $format);
    ## This is a dreadful hack. I can't think of a good format specifier
    ## for "%B %Y" (which is used for monthly archives, for example) so
    ## I'll just hardcode this, for Japanese dates.
    if ($lang == 'ja') {
        if (count($Languages[$lang]) >= 8) {
            $format = preg_replace('!%B %Y!', $Languages[$lang][6], $format);
            $format = preg_replace('!%B %E,? %Y!i', $Languages[$lang][4], $format);
            $format = preg_replace('!%B %E!', $Languages[$lang][7], $format);
        }
    }
    elseif ( $lang == 'it' ) {
        ## Hack for the Italian dates
        ## In Italian, the date always come before the month.
        $format = preg_replace('!%b %e!', '%e %b', $format);
    }
    if (isset($format)) {
        $format = preg_replace('!%(\w)!e', '\$f[\'\1\']', $format);
    }
    return $format;
}

function dirify($s, $sep = '_') {
    $mt = MT::get_instance();
    $charset = $mt->config('PublishCharset');
    $charset or $charset = 'utf-8';
    if (preg_match('/utf-?8/i', $charset)) {
        return utf8_dirify($s, $sep);
    } else {
        return iso_dirify($s, $sep);
    }
}

function utf8_dirify($s, $sep = '_') {
    if ($sep == '1') $sep = '_';
    $s = xliterate_utf8($s);  ## convert high-ASCII chars to 7bit.
    $s = strtolower($s);                   ## lower-case.
    $s = strip_tags($s);          ## remove HTML tags.
    $s = preg_replace('!&[^;\s]+;!', '', $s); ## remove HTML entities.
    $s = preg_replace('![^\w\s]!', '', $s);   ## remove non-word/space chars.
    $s = preg_replace('/\s+/',$sep,$s);         ## change space chars to underscores.
    return($s);
}

global $Utf8_ASCII;
$Utf8_ASCII = array(
    "\xc3\x80" => 'A',    # A`
    "\xc3\xa0" => 'a',    # a`
    "\xc3\x81" => 'A',    # A'
    "\xc3\xa1" => 'a',    # a'
    "\xc3\x82" => 'A',    # A^
    "\xc3\xa2" => 'a',    # a^
    "\xc4\x82" => 'A',    # latin capital letter a with breve
    "\xc4\x83" => 'a',    # latin small letter a with breve
    "\xc3\x86" => 'AE',   # latin capital letter AE
    "\xc3\xa6" => 'ae',   # latin small letter ae
    "\xc3\x85" => 'A',    # latin capital letter a with ring above
    "\xc3\xa5" => 'a',    # latin small letter a with ring above
    "\xc4\x80" => 'A',    # latin capital letter a with macron
    "\xc4\x81" => 'a',    # latin small letter a with macron
    "\xc4\x84" => 'A',    # latin capital letter a with ogonek
    "\xc4\x85" => 'a',    # latin small letter a with ogonek
    "\xc3\x84" => 'A',    # A:
    "\xc3\xa4" => 'a',    # a:
    "\xc3\x83" => 'A',    # A~
    "\xc3\xa3" => 'a',    # a~
    "\xc3\x88" => 'E',    # E`
    "\xc3\xa8" => 'e',    # e`
    "\xc3\x89" => 'E',    # E'
    "\xc3\xa9" => 'e',    # e'
    "\xc3\x8a" => 'E',    # E^
    "\xc3\xaa" => 'e',    # e^
    "\xc3\x8b" => 'E',    # E:
    "\xc3\xab" => 'e',    # e:
    "\xc4\x92" => 'E',    # latin capital letter e with macron
    "\xc4\x93" => 'e',    # latin small letter e with macron
    "\xc4\x98" => 'E',    # latin capital letter e with ogonek
    "\xc4\x99" => 'e',    # latin small letter e with ogonek
    "\xc4\x9a" => 'E',    # latin capital letter e with caron
    "\xc4\x9b" => 'e',    # latin small letter e with caron
    "\xc4\x94" => 'E',    # latin capital letter e with breve
    "\xc4\x95" => 'e',    # latin small letter e with breve
    "\xc4\x96" => 'E',    # latin capital letter e with dot above
    "\xc4\x97" => 'e',    # latin small letter e with dot above
    "\xc3\x8c" => 'I',    # I`
    "\xc3\xac" => 'i',    # i`
    "\xc3\x8d" => 'I',    # I'
    "\xc3\xad" => 'i',    # i'
    "\xc3\x8e" => 'I',    # I^
    "\xc3\xae" => 'i',    # i^
    "\xc3\x8f" => 'I',    # I:
    "\xc3\xaf" => 'i',    # i:
    "\xc4\xaa" => 'I',    # latin capital letter i with macron
    "\xc4\xab" => 'i',    # latin small letter i with macron
    "\xc4\xa8" => 'I',    # latin capital letter i with tilde
    "\xc4\xa9" => 'i',    # latin small letter i with tilde
    "\xc4\xac" => 'I',    # latin capital letter i with breve
    "\xc4\xad" => 'i',    # latin small letter i with breve
    "\xc4\xae" => 'I',    # latin capital letter i with ogonek
    "\xc4\xaf" => 'i',    # latin small letter i with ogonek
    "\xc4\xb0" => 'I',    # latin capital letter with dot above
    "\xc4\xb1" => 'i',    # latin small letter dotless i
    "\xc4\xb2" => 'IJ',   # latin capital ligature ij
    "\xc4\xb3" => 'ij',   # latin small ligature ij
    "\xc4\xb4" => 'J',    # latin capital letter j with circumflex
    "\xc4\xb5" => 'j',    # latin small letter j with circumflex
    "\xc4\xb6" => 'K',    # latin capital letter k with cedilla
    "\xc4\xb7" => 'k',    # latin small letter k with cedilla
    "\xc4\xb8" => 'k',    # latin small letter kra
    "\xc5\x81" => 'L',    # latin capital letter l with stroke
    "\xc5\x82" => 'l',    # latin small letter l with stroke
    "\xc4\xbd" => 'L',    # latin capital letter l with caron
    "\xc4\xbe" => 'l',    # latin small letter l with caron
    "\xc4\xb9" => 'L',    # latin capital letter l with acute
    "\xc4\xba" => 'l',    # latin small letter l with acute
    "\xc4\xbb" => 'L',    # latin capital letter l with cedilla
    "\xc4\xbc" => 'l',    # latin small letter l with cedilla
    "\xc4\xbf" => 'l',    # latin capital letter l with middle dot
    "\xc5\x80" => 'l',    # latin small letter l with middle dot
    "\xc3\x92" => 'O',    # O`
    "\xc3\xb2" => 'o',    # o`
    "\xc3\x93" => 'O',    # O'
    "\xc3\xb3" => 'o',    # o'
    "\xc3\x94" => 'O',    # O^
    "\xc3\xb4" => 'o',    # o^
    "\xc3\x96" => 'O',    # O:
    "\xc3\xb6" => 'o',    # o:
    "\xc3\x95" => 'O',    # O~
    "\xc3\xb5" => 'o',    # o~
    "\xc3\x98" => 'O',    # O/
    "\xc3\xb8" => 'o',    # o/
    "\xc5\x8c" => 'O',    # latin capital letter o with macron
    "\xc5\x8d" => 'o',    # latin small letter o with macron
    "\xc5\x90" => 'O',    # latin capital letter o with double acute
    "\xc5\x91" => 'o',    # latin small letter o with double acute
    "\xc5\x8e" => 'O',    # latin capital letter o with breve
    "\xc5\x8f" => 'o',    # latin small letter o with breve
    "\xc5\x92" => 'OE',   # latin capital ligature oe
    "\xc5\x93" => 'oe',   # latin small ligature oe
    "\xc5\x94" => 'R',    # latin capital letter r with acute
    "\xc5\x95" => 'r',    # latin small letter r with acute
    "\xc5\x98" => 'R',    # latin capital letter r with caron
    "\xc5\x99" => 'r',    # latin small letter r with caron
    "\xc5\x96" => 'R',    # latin capital letter r with cedilla
    "\xc5\x97" => 'r',    # latin small letter r with cedilla
    "\xc3\x99" => 'U',    # U`
    "\xc3\xb9" => 'u',    # u`
    "\xc3\x9a" => 'U',    # U'
    "\xc3\xba" => 'u',    # u'
    "\xc3\x9b" => 'U',    # U^
    "\xc3\xbb" => 'u',    # u^
    "\xc3\x9c" => 'U',    # U:
    "\xc3\xbc" => 'u',    # u:
    "\xc5\xaa" => 'U',    # latin capital letter u with macron
    "\xc5\xab" => 'u',    # latin small letter u with macron
    "\xc5\xae" => 'U',    # latin capital letter u with ring above
    "\xc5\xaf" => 'u',    # latin small letter u with ring above
    "\xc5\xb0" => 'U',    # latin capital letter u with double acute
    "\xc5\xb1" => 'u',    # latin small letter u with double acute
    "\xc5\xac" => 'U',    # latin capital letter u with breve
    "\xc5\xad" => 'u',    # latin small letter u with breve
    "\xc5\xa8" => 'U',    # latin capital letter u with tilde
    "\xc5\xa9" => 'u',    # latin small letter u with tilde
    "\xc5\xb2" => 'U',    # latin capital letter u with ogonek
    "\xc5\xb3" => 'u',    # latin small letter u with ogonek
    "\xc3\x87" => 'C',    # ,C
    "\xc3\xa7" => 'c',    # ,c
    "\xc4\x86" => 'C',    # latin capital letter c with acute
    "\xc4\x87" => 'c',    # latin small letter c with acute
    "\xc4\x8c" => 'C',    # latin capital letter c with caron
    "\xc4\x8d" => 'c',    # latin small letter c with caron
    "\xc4\x88" => 'C',    # latin capital letter c with circumflex
    "\xc4\x89" => 'c',    # latin small letter c with circumflex
    "\xc4\x8a" => 'C',    # latin capital letter c with dot above
    "\xc4\x8b" => 'c',    # latin small letter c with dot above
    "\xc4\x8e" => 'D',    # latin capital letter d with caron
    "\xc4\x8f" => 'd',    # latin small letter d with caron
    "\xc4\x90" => 'D',    # latin capital letter d with stroke
    "\xc4\x91" => 'd',    # latin small letter d with stroke
    "\xc3\x91" => 'N',    # N~
    "\xc3\xb1" => 'n',    # n~
    "\xc5\x83" => 'N',    # latin capital letter n with acute
    "\xc5\x84" => 'n',    # latin small letter n with acute
    "\xc5\x87" => 'N',    # latin capital letter n with caron
    "\xc5\x88" => 'n',    # latin small letter n with caron
    "\xc5\x85" => 'N',    # latin capital letter n with cedilla
    "\xc5\x86" => 'n',    # latin small letter n with cedilla
    "\xc5\x89" => 'n',    # latin small letter n preceded by apostrophe
    "\xc5\x8a" => 'N',    # latin capital letter eng
    "\xc5\x8b" => 'n',    # latin small letter eng
    "\xc3\x9f" => 'ss',   # double-s
    "\xc5\x9a" => 'S',    # latin capital letter s with acute
    "\xc5\x9b" => 's',    # latin small letter s with acute
    "\xc5\xa0" => 'S',    # latin capital letter s with caron
    "\xc5\xa1" => 's',    # latin small letter s with caron
    "\xc5\x9e" => 'S',    # latin capital letter s with cedilla
    "\xc5\x9f" => 's',    # latin small letter s with cedilla
    "\xc5\x9c" => 'S',    # latin capital letter s with circumflex
    "\xc5\x9d" => 's',    # latin small letter s with circumflex
    "\xc8\x98" => 'S',    # latin capital letter s with comma below
    "\xc8\x99" => 's',    # latin small letter s with comma below
    "\xc5\xa4" => 'T',    # latin capital letter t with caron
    "\xc5\xa5" => 't',    # latin small letter t with caron
    "\xc5\xa2" => 'T',    # latin capital letter t with cedilla
    "\xc5\xa3" => 't',    # latin small letter t with cedilla
    "\xc5\xa6" => 'T',    # latin capital letter t with stroke
    "\xc5\xa7" => 't',    # latin small letter t with stroke
    "\xc8\x9a" => 'T',    # latin capital letter t with comma below
    "\xc8\x9b" => 't',    # latin small letter t with comma below
    "\xc6\x92" => 'f',    # latin small letter f with hook
    "\xc4\x9c" => 'G',    # latin capital letter g with circumflex
    "\xc4\x9d" => 'g',    # latin small letter g with circumflex
    "\xc4\x9e" => 'G',    # latin capital letter g with breve
    "\xc4\x9f" => 'g',    # latin small letter g with breve
    "\xc4\xa0" => 'G',    # latin capital letter g with dot above
    "\xc4\xa1" => 'g',    # latin small letter g with dot above
    "\xc4\xa2" => 'G',    # latin capital letter g with cedilla
    "\xc4\xa3" => 'g',    # latin small letter g with cedilla
    "\xc4\xa4" => 'H',    # latin capital letter h with circumflex
    "\xc4\xa5" => 'h',    # latin small letter h with circumflex
    "\xc4\xa6" => 'H',    # latin capital letter h with stroke
    "\xc4\xa7" => 'h',    # latin small letter h with stroke
    "\xc5\xb4" => 'W',    # latin capital letter w with circumflex
    "\xc5\xb5" => 'w',    # latin small letter w with circumflex
    "\xc3\x9d" => 'Y',    # latin capital letter y with acute
    "\xc3\xbd" => 'y',    # latin small letter y with acute
    "\xc5\xb8" => 'Y',    # latin capital letter y with diaeresis
    "\xc3\xbf" => 'y',    # latin small letter y with diaeresis
    "\xc5\xb6" => 'Y',    # latin capital letter y with circumflex
    "\xc5\xb7" => 'y',    # latin small letter y with circumflex
    "\xc5\xbd" => 'Z',    # latin capital letter z with caron
    "\xc5\xbe" => 'z',    # latin small letter z with caron
    "\xc5\xbb" => 'Z',    # latin capital letter z with dot above
    "\xc5\xbc" => 'z',    # latin small letter z with dot above
    "\xc5\xb9" => 'Z',    # latin capital letter z with acute
    "\xc5\xba" => 'z',    # latin small letter z with acute
);
function xliterate_utf8($s) {
    global $Utf8_ASCII;
    return strtr($s, $Utf8_ASCII);
}

function iso_dirify($s, $sep = '_') {
    if ($sep == '1') $sep = '_';
    $s = convert_high_ascii($s);  ## convert high-ASCII chars to 7bit.
    $s = strtolower($s);                   ## lower-case.
    $s = strip_tags($s);          ## remove HTML tags.
    $s = preg_replace('!&[^;\s]+;!', '', $s); ## remove HTML entities.
    $s = preg_replace('![^\w\s]!', '', $s);   ## remove non-word/space chars.
    $s = preg_replace('/\s+/',$sep,$s);         ## change space chars to underscores.
    return($s);
}

global $Latin1_ASCII;
$Latin1_ASCII = array(
    "\xc0" => 'A',    # A`
    "\xe0" => 'a',    # a`
    "\xc1" => 'A',    # A'
    "\xe1" => 'a',    # a'
    "\xc2" => 'A',    # A^
    "\xe2" => 'a',    # a^
    "\xc4" => 'A',    # A:
    "\xe4" => 'a',    # a:
    "\xc5" => 'A',    # Aring
    "\xe5" => 'a',    # aring
    "\xc6" => 'AE',   # AE
    "\xe6" => 'ae',   # ae
    "\xc3" => 'A',    # A~
    "\xe3" => 'a',    # a~
    "\xc8" => 'E',    # E`
    "\xe8" => 'e',    # e`
    "\xc9" => 'E',    # E'
    "\xe9" => 'e',    # e'
    "\xca" => 'E',    # E^
    "\xea" => 'e',    # e^
    "\xcb" => 'E',    # E:
    "\xeb" => 'e',    # e:
    "\xcc" => 'I',    # I`
    "\xec" => 'i',    # i`
    "\xcd" => 'I',    # I'
    "\xed" => 'i',    # i'
    "\xce" => 'I',    # I^
    "\xee" => 'i',    # i^
    "\xcf" => 'I',    # I:
    "\xef" => 'i',    # i:
    "\xd2" => 'O',    # O`
    "\xf2" => 'o',    # o`
    "\xd3" => 'O',    # O'
    "\xf3" => 'o',    # o'
    "\xd4" => 'O',    # O^
    "\xf4" => 'o',    # o^
    "\xd6" => 'O',    # O:
    "\xf6" => 'o',    # o:
    "\xd5" => 'O',    # O~
    "\xf5" => 'o',    # o~
    "\xd8" => 'O',    # O/
    "\xf8" => 'o',    # o/
    "\xd9" => 'U',    # U`
    "\xf9" => 'u',    # u`
    "\xda" => 'U',    # U'
    "\xfa" => 'u',    # u'
    "\xdb" => 'U',    # U^
    "\xfb" => 'u',    # u^
    "\xdc" => 'U',    # U:
    "\xfc" => 'u',    # u:
    "\xc7" => 'C',    # ,C
    "\xe7" => 'c',    # ,c
    "\xd1" => 'N',    # N~
    "\xf1" => 'n',    # n~
    "\xdd" => 'Y',    # Yacute
    "\xfd" => 'y',    # yacute
    "\xdf" => 'ss',   # szlig
    "\xff" => 'y'     # yuml
);
function convert_high_ascii($s) {
    $mt = MT::get_instance();
    $lang = $mt->config('DefaultLanguage');
    if ($lang == 'ja') {
        $s = mb_convert_encoding($s, 'UTF-8');
        return $s;
    }
    global $Latin1_ASCII;
    return strtr($s, $Latin1_ASCII);
}

global $Languages;
$Languages = array(
    'en' => array(
            array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),
            array('January','February','March','April','May','June',
                  'July','August','September','October','November','December'),
            array('AM','PM'),
          ),

    'fr' => array(
            array('dimanche','lundi','mardi','mercredi','jeudi','vendredi','samedi' ),
            array('janvier', "f&#xe9;vrier", 'mars', 'avril', 'mai', 'juin',
               'juillet', "ao&#xfb;t", 'septembre', 'octobre', 'novembre',
               "d&#xe9;cembre"),
            array('AM','PM'),
          ),

    'es' => array(
            array('Domingo', 'Lunes', 'Martes', "Mi&#xe9;rcoles", 'Jueves',
               'Viernes', "S&#xe1;bado"),
            array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto',
                  'Septiembre','Octubre','Noviembre','Diciembre'),
            array('AM','PM'),
          ),

    'pt' => array(
            array('domingo', 'segunda-feira', "ter&#xe7;a-feira", 'quarta-feira',
               'quinta-feira', 'sexta-feira', "s&#xe1;bado"),
            array('janeiro', 'fevereiro', "mar&#xe7;o", 'abril', 'maio', 'junho',
               'julho', 'agosto', 'setembro', 'outubro', 'novembro',
               'dezembro' ),
            array('AM','PM'),
          ),

    'nl' => array(
            array('zondag','maandag','dinsdag','woensdag','donderdag','vrijdag',
                  'zaterdag'),
            array('januari','februari','maart','april','mei','juni','juli','augustus',
                  'september','oktober','november','december'),
            array('am','pm'),
             "%d %B %Y %H:%M",
             "%d %B %Y"
          ),

    'dk' => array(
            array("s&#xf8;ndag", 'mandag', 'tirsdag', 'onsdag', 'torsdag',
               'fredag', "l&#xf8;rdag"),
            array('januar','februar','marts','april','maj','juni','juli','august',
                  'september','oktober','november','december'),
            array('am','pm'),
            "%d.%m.%Y %H:%M",
            "%d.%m.%Y",
            "%H:%M",
          ),

    'se' => array(
            array("s&#xf6;ndag", "m&#xe5;ndag", 'tisdag', 'onsdag', 'torsdag',
               'fredag', "l&#xf6;rdag"),
            array('januari','februari','mars','april','maj','juni','juli','augusti',
                  'september','oktober','november','december'),
            array('FM','EM'),
          ),

    'no' => array(
            array("S&#xf8;ndag", "Mandag", 'Tirsdag', 'Onsdag', 'Torsdag',
               'Fredag', "L&#xf8;rdag"),
            array('Januar','Februar','Mars','April','Mai','Juni','Juli','August',
                  'September','Oktober','November','Desember'),
            array('FM','EM'),
          ),

    'de' => array(
            array('Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag',
                  'Samstag'),
            array('Januar', 'Februar', "M&#xe4;rz", 'April', 'Mai', 'Juni',
               'Juli', 'August', 'September', 'Oktober', 'November',
               'Dezember'),
            array('FM','EM'),
            "%d.%m.%y %H:%M",
            "%d.%m.%y",
            "%H:%M",
          ),

    'it' => array(
            array('Domenica', "Luned&#xec;", "Marted&#xec;", "Mercoled&#xec;",
               "Gioved&#xec;", "Venerd&#xec;", 'Sabato'),
            array('Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio',
                  'Agosto','Settembre','Ottobre','Novembre','Dicembre'),
            array('AM','PM'),
            "%d.%m.%y %H:%M",
            "%d.%m.%y",
            "%H:%M",
          ),

    'pl' => array(
            array('niedziela', "poniedzia&#322;ek", 'wtorek', "&#347;roda",
               'czwartek', "pi&#261;tek", 'sobota'),
            array('stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca',
               'lipca', 'sierpnia', "wrze&#347;nia", "pa&#378;dziernika",
               'listopada', 'grudnia'),
            array('AM','PM'),
            "%e %B %Y %k:%M",
            "%e %B %Y",
            "%k:%M",
          ),
            
    'fi' => array(
            array('sunnuntai','maanantai','tiistai','keskiviikko','torstai','perjantai',
                  'lauantai'),
            array('tammikuu', 'helmikuu', 'maaliskuu', 'huhtikuu', 'toukokuu',
               "kes&#xe4;kuu", "hein&#xe4;kuu", 'elokuu', 'syyskuu', 'lokakuu',
               'marraskuu', 'joulukuu'),
            array('AM','PM'),
            "%d.%m.%y %H:%M",
          ),
            
    'is' => array(
            array('Sunnudagur', "M&#xe1;nudagur", "&#xde;ri&#xf0;judagur",
               "Mi&#xf0;vikudagur", 'Fimmtudagur', "F&#xf6;studagur",
               'Laugardagur'),
            array("jan&#xfa;ar", "febr&#xfa;ar", 'mars', "apr&#xed;l", "ma&#xed;",
               "j&#xfa;n&#xed;", "j&#xfa;l&#xed;", "&#xe1;g&#xfa;st", 'september',             
               "okt&#xf3;ber", "n&#xf3;vember", 'desember'),
            array('FH','EH'),
            "%d.%m.%y %H:%M",
          ),
            
    'si' => array(
            array('nedelja', 'ponedeljek', 'torek', 'sreda', "&#xe3;etrtek",
               'petek', 'sobota'),
            array('januar','februar','marec','april','maj','junij','julij','avgust',
                  'september','oktober','november','december'),
            array('AM','PM'),
            "%d.%m.%y %H:%M",
          ),
            
    'cz' => array(
            array('Ned&#283;le', 'Pond&#283;l&#237;', '&#218;ter&#253;',
               'St&#345;eda', '&#268;tvrtek', 'P&#225;tek', 'Sobota'),
            array('Leden', '&#218;nor', 'B&#345;ezen', 'Duben', 'Kv&#283;ten',
               '&#268;erven', '&#268;ervenec', 'Srpen', 'Z&#225;&#345;&#237;',
               '&#216;&#237;jen', 'Listopad', 'Prosinec'),
            array('AM','PM'),
            "%e. %B %Y %k:%M",
            "%e. %B %Y",
            "%k:%M",
          ),
            
    'sk' => array(
            array('nede&#318;a', 'pondelok', 'utorok', 'streda',
               '&#353;tvrtok', 'piatok', 'sobota'),
            array('janu&#225;r', 'febru&#225;r', 'marec', 'apr&#237;l',
               'm&#225;j', 'j&#250;n', 'j&#250;l', 'august', 'september',
               'okt&#243;ber', 'november', 'december'),
            array('AM','PM'),
            "%e. %B %Y %k:%M",
            "%e. %B %Y",
            "%k:%M",
          ),

    'jp' => array(
            array('&#26085;&#26332;&#26085;', '&#26376;&#26332;&#26085;',
              '&#28779;&#26332;&#26085;', '&#27700;&#26332;&#26085;',
              '&#26408;&#26332;&#26085;', '&#37329;&#26332;&#26085;',
              '&#22303;&#26332;&#26085;'),
            array('1','2','3','4','5','6','7','8','9','10','11','12'),
            array('AM','PM'),
            "%Y&#24180;%b&#26376;%e&#26085; %H:%M",
            "%Y&#24180;%b&#26376;%e&#26085;",
            "%H:%M",
            "%Y&#24180;%b&#26376;",
            "%b&#26376;%e&#26085;",
          ),

    'ja' => array(
            array('&#26085;&#26332;&#26085;', '&#26376;&#26332;&#26085;',
              '&#28779;&#26332;&#26085;', '&#27700;&#26332;&#26085;',
              '&#26408;&#26332;&#26085;', '&#37329;&#26332;&#26085;',
              '&#22303;&#26332;&#26085;'),
            array('1','2','3','4','5','6','7','8','9','10','11','12'),
            array('AM','PM'),
            "%Y&#24180;%b&#26376;%e&#26085; %H:%M",
            "%Y&#24180;%b&#26376;%e&#26085;",
            "%H:%M",
            "%Y&#24180;%b&#26376;",
            "%b&#26376;%e&#26085;",
          ),

    'et' => array(
            array('ip&uuml;hap&auml;ev','esmasp&auml;ev','teisip&auml;ev',
                  'kolmap&auml;ev','neljap&auml;ev','reede','laup&auml;ev'),
            array('jaanuar', 'veebruar', 'm&auml;rts', 'aprill', 'mai',
               'juuni', 'juuli', 'august', 'september', 'oktoober',
              'november', 'detsember'),
            array('AM','PM'),
            "%m.%d.%y %H:%M",
            "%e. %B %Y",
            "%H:%M",
          ),
);

global $_encode_xml_Map;
$_encode_xml_Map = array('&' => '&amp;', '"' => '&quot;',
                         '<' => '&lt;', '>' => '&gt;',
                         '\'' => '&apos;');

function __check_xml_char($matches) {
    $val = $matches[2];
    $is_hex = $matches[1];
    if ($is_hex)
        $val = hexdec($val);
    $val = 0 + $val;
    if (   ($val == 9) 
        || ($val == 0xA) 
        || ($val == 0xD) 
        || (($val >= 0x20) and ($val <= 0xD7FF)) 
        || (($val >= 0xE000) and ($val <= 0xFFFD)) 
        || (($val >= 0x10000) and ($val <= 0x10FFFF))) 
    {
        return "&#" . $is_hex . $matches[2] . ";";
    }
    else {
        return "&amp;#"  . $is_hex . $matches[2] . ";";
    }
}

function encode_xml($str, $nocdata = 0) {
    $mt = MT::get_instance();
    global $_encode_xml_Map;
    $cfg_nocdata = $mt->config('NoCDATA');
    $nocdata or (isset($cfg_nocdata) and $nocdata = $cfg_nocdata);
    if ((!$nocdata) && (preg_match('/
        <[^>]+>  ## HTML markup
        |        ## or
        &(?:(?!(\#([0-9]+)|\#x([0-9a-fA-F]+))).*?);
                 ## something that looks like an HTML entity.
        /x', $str))) {
        ## If ]]> exists in the string, encode the > to &gt;.
        $str = preg_replace('/]]>/', ']]&gt;', $str);
        $str = '<![CDATA[' . $str . ']]>';
    } else {
        $str = strtr($str, $_encode_xml_Map);
        $str = preg_replace_callback('/&amp;#(x?)((?:[0-9]+|[0-9a-fA-F]+).*?);/', __check_xml_char, $str);
    }
    return $str;
}

function decode_xml($str) {
    if (preg_match('/<!\[CDATA\[(.*?)]]>/', $str)) {
        $str = preg_replace('/<!\[CDATA\[(.*?)]]>/', '\1', $str);
        ## Decode encoded ]]&gt;
        $str = preg_replace('/]]&(gt|#62);/', ']]>', $str);
    } else {
        global $_encode_xml_Map;
        $str = strtr($str, array_flip($_encode_xml_Map));
    }
    return $str;
}

function encode_js($str) {
    if (!isset($str)) return '';
    $str = preg_replace('!\\\\!', '\\\\', $str);
    $str = preg_replace('!>!', '\\>', $str);
    $str = preg_replace('!<!', '\\<', $str);
    $str = preg_replace('!(s)(cript)!i', '$1\\\\$2', $str);
    $str = preg_replace('!</!', '<\\/', $str); # </ is supposed to be the end of Javascript (</script in most UA)
    $str = preg_replace('!\'!', '\\\'', $str);
    $str = preg_replace('!"!', '\\"', $str);
    $str = preg_replace('!\n!', '\\n', $str);
    $str = preg_replace('!\f!', '\\f', $str);
    $str = preg_replace('!\r!', '\\r', $str);
    $str = preg_replace('!\t!', '\\t', $str);
    return $str;
}

function gmtime($ts = null) {
    if (!isset($ts)) {
        $ts = time();
    }
    $offset = date('Z', $ts);
    $ts -= $offset;
    $tsa = localtime($ts);
    $tsa[8] = 0;
    return $tsa;
}

function is_hash($array) {
    if ( is_array($array) ) {
        if ( array_keys($array) === range(0, count($array) - 1) ) {
            // 0,1,2,3... must be an array
            return false;
        }
        return true;
    }
    return false;
}

function offset_time_list($ts, $blog = null, $dir = null) {
    return gmtime(offset_time($ts, $blog, $dir));
}

function strip_hyphen($s) {
    return preg_replace('/-+/', '-', $s);
}

function first_n_words($text, $n) {
    $text = strip_tags($text);
    $words = preg_split('/\s+/', $text);
    $max = count($words) > $n ? $n : count($words);
    return join(' ', array_slice($words, 0, $max));
}

function html_text_transform($str = '') {
    $paras = preg_split('/\r?\n\r?\n/', $str);
    if ($str == '') {
        return '';
    }
    foreach ($paras as $k => $p) {
        if (!preg_match('/^<\/?(?:h1|h2|h3|h4|h5|h6|table|ol|dl|ul|menu|dir|p|pre|center|form|select|fieldset|blockquote|address|div|hr)/', $p)) {
            $p = preg_replace('/\r?\n/', "<br />\n", $p);
            $p = "<p>$p</p>";
            $paras[$k] = $p;
        }
    }
    return implode("\n\n", $paras);
}

function encode_html($str, $quote_style = ENT_COMPAT) {
    if (!isset($str)) return '';
    $trans_table = get_html_translation_table(HTML_SPECIALCHARS, $quote_style);
    if( $trans_table["'"] != '&#039;' ) { # some versions of PHP match single quotes to &#39;
        $trans_table["'"] = '&#039;';
    }
    return (strtr($str, $trans_table));
}

function decode_html($str, $quote_style = ENT_COMPAT) {
    if (!isset($str)) return '';
    $trans_table = get_html_translation_table(HTML_SPECIALCHARS, $quote_style);
    if( $trans_table["'"] != '&#039;' ) { # some versions of PHP match single quotes to &#39;
        $trans_table["'"] = '&#039;';
    }
    return (strtr($str, array_flip($trans_table)));
}

function get_category_context(&$ctx, $class = 'category') {
    # Get our hands on the category for the current context
    # Either in MTCategories, a Category Archive Template
    # Or the category for the current entry
    $cat = $ctx->stash('category') or
           $ctx->stash('archive_category');
    if (!isset($cat)) {
        # No category found so far, test the entry
        if ($ctx->stash('entry')) {
            $entry = $ctx->stash('entry');
            $place = $entry->placement();
            if (empty($place))
                return null;
            $cat = $place[0]->category();

            # Return empty string if entry has no category
            # as the tag has been used in the correct context
            # but there is no category to work with
            if (!isset($cat)) {
                return null;
            }
        } else {
            $tag = $ctx->this_tag();
            return $ctx->error("$tag must be used in a category context");
        }
    }
    return $cat;
}

function munge_comment($text, $blog) {
    if (!$blog->blog_allow_comment_html) {
        $text = strip_tags($text);
    }
    if ($blog->blog_autolink_urls) {
        $text = preg_replace('!(^|\s|>)(https?://[^\s<]+)!s', '$1<a href="$2">$2</a>', $text);
    }
    return $text;
}

function length_text($text) {
    if (!extension_loaded('mbstring')) {
        $len = strlen($text);
    } else {
        $len = mb_strlen($text);
    }
    return $len;
}

function substr_text($text, $startpos, $length) {
    if (!extension_loaded('mbstring')) {
        $text = substr($text, $startpos, $length);
    } else {
        $text = mb_substr($text, $startpos, $length);
    }
    return $text;
}

function first_n_text($text, $n) {
    if (!isset($lang) || empty($lang)) { 
        $mt = MT::get_instance();
        $lang = ($blog && $blog->blog_language ? $blog->blog_language : 
                     $mt->config('DefaultLanguage'));
    }
    if ($lang == 'jp') {
        $lang = 'ja';
    }

    if ($lang == 'ja') {
        $text = strip_tags($text);
        $text = preg_replace('/\r?\n/', " ", $text);
        return substr_text($text, 0, $n);
    }else{
        return first_n_words($text, $n);
    }
}

function tag_split_delim($delim, $str) {
    $delim = quotemeta($delim);
    $tags = array();
    $str = trim($str);
    while (strlen($str) && (preg_match("/^(((['\"])(.*?)\3[^$delim]*?|.*?)($delim\s*|$))/s", $str, $match))) {
        $str = substr($str, strlen($match[1]));
        $tag = (isset($match[4]) && $match[4] != '') ? $match[4] : $match[2];
        $tag = trim($tag);
        $tag = preg_replace('/\s+/', ' ', $tag);
        $n8d_tag = tag_normalize($tag);
        if ($n8d_tag != '')
            if ($tag != '') $tags[] = $tag;
    }
    return $tags;
}

function tag_split($str) {
    return tag_split_delim(',', $str);
}

function catarray_path_length_sort($a, $b) {
	$al = strlen($a->category_label_path);
	$bl = strlen($bcategory_label_path);
	return $al == $bl ? 0 : $al < $bl ? 1 : -1;
}

# sorts by length of category label, from longest to shortest
function catarray_length_sort($a, $b) {
	$al = strlen($a->category_label);
	$bl = strlen($b->category_label);
	return $al == $bl ? 0 : $al < $bl ? 1 : -1;
}

function create_expr_exception($m) {
    if ($m[2])
        return '(0)';
    else
        return $m[1];
}

function create_cat_expr_function($expr, &$cats, $param) {
    $mt = MT::get_instance();
    $cats_used = array();
    $orig_expr = $expr;

    $include_children = $param['children'] ? 1 : 0;
    $cats_used = array();

    if (preg_match('/\//', $expr)) {
        foreach ($cats as $id => $cat) {
            $catp = category_label_path($cat);
            $cats[$id]->category_label_path = $catp;
        }
        $cols = array('category_label_path', 'category_label');
    } else {
        $cols = array('category_label');
    }
    foreach ($cols as $col) {
        if ($col == 'category_label_path') {
            usort($cats, 'catarray_path_length_sort');
        } else {
            usort($cats, 'catarray_length_sort');
        }
        $cats_replaced = array();
        foreach ($cats as $cat) {
            $catl = $cat->$col;
            $catid = $cat->category_id;
            $catre = preg_quote($catl, "/");
            if (!preg_match("/(?:(?<![#\d])\[$catre\]|$catre)|(?:#$catid\b)/", $expr))
                continue;
            if ($include_children) {
                $kids = array($cat);
                $child_cats = array();
                while ($c = array_shift($kids)) {
                    $child_cats[$c->category_id] = $c;
                    $children = $mt->db()->fetch_categories(array('category_id' => $c->category_id, 'children' => 1, 'show_empty' => 1, 'class' => $c->category_class));
                    if ($children) {
                        foreach ($children as $child) {
                            $kids[] = $child;
                        }
                    }
                }
                $repl = '';
                foreach ($child_cats as $ccid => $cc) {
                    $repl .= '||#' . $ccid;
                }
                if (strlen($repl)) $repl = substr($repl, 2);
                $repl = '(' . $repl . ')';
            } else {
                $repl = "(#$catid)";
            }
            if (isset($cats_replaced[$catl])) {
                $last_catid = $cats_replaced[$catl];
                $expr = preg_replace("/(#$last_catid\b)/", '($1 || #' . $catid . ')', $expr);
            } else {
        	    $expr = preg_replace("/(?:(?<!#)(?:\[$catre\]|$catre))|#$catid\b/", $repl,
                    $expr);
                $cats_replaced[$catl] = $catid;
            }
            if ($include_children) {
                foreach ($child_cats as $ccid => $cc)
                    $cats_used[$ccid] = $cc;
            } else {
                $cats_used[$catid] = $cat;
            }
        }
    }

    $expr = preg_replace('/\bAND\b/i', '&&', $expr);
    $expr = preg_replace('/\bOR\b/i', '||', $expr);
    $expr = preg_replace('/\bNOT\b/i', '!', $expr);
    $expr = preg_replace_callback('/( |#\d+|&&|\|\||!|\(|\))|([^()]+)/', 'create_expr_exception', $expr);

    # strip out all the 'ok' stuff. if anything is left, we have
    # some invalid data in our expression:
    $test_expr = preg_replace('/!|&&|\|\||\(0\)|\(|\)|\s|#\d+/', '', $expr);
    if ($test_expr != '') {
        echo "Invalid category filter: $orig_expr";
        return;
    }
	if (!preg_match('/!/', $expr))
	    $cats = array_values($cats_used);

    $expr = preg_replace('/#(\d+)/', "array_key_exists('\\1', \$pm)", $expr);
    $expr = '$pm = array_key_exists($e->entry_id, $c["p"]) ? $c["p"][$e->entry_id] : array(); return (' . $expr . ');';
    $fn = create_function('&$e,&$c', $expr);
    if ($fn === FALSE) {
        echo "Invalid category filter: $orig_expr";
        return;
    }
    return $fn;
}

function category_label_path($cat) {
    $mt = MT::get_instance();
    $mtdb =& $mt->db();
    if (isset($cat->__label_path))
        return $cat->__label_path;
    $result = preg_match('/\//', $cat->category_label) ? '[' . $cat->category_label . ']' : $cat->category_label;
    while ($cat) {
        $cat = $cat->category_parent ? $mtdb->fetch_category($cat->category_parent) : null;
        if ($cat)
            $result = (preg_match('/\//', $cat->category_label) ? '[' . $cat->category_label . ']' : $cat->category_label) . '/' . $result;
    }
    # caching this information may be problematic IF
    # parent category labels are changed.
    $cat->__label_path = $result;
    return $result;
}

function cat_path_to_category($path, $blogs = null, $class = 'category') {
    $mt = MT::get_instance();
    if (!$blogs) {
        $ctx = $mt->context();
        $blogs = array('include_blogs' => $ctx->stash('blog_id'));
    }
    if (!is_array($blogs))
        $blogs = array($blogs);
    $mtdb =& $mt->db();
    if (preg_match_all('/(\[[^]]+?\]|[^]\/]+)/', $path, $matches)) {
        # split on slashes, fields quoted by []
        $cat_path = $matches[1];
        for ($i = 0; $i < count($cat_path); $i++) {
            $cat_path[$i] = preg_replace('/^\[(.*)\]$/', '\1', $cat_path[$i]);       # remove any []
        }
        $last_cat_ids = array(0);
        foreach ($cat_path as $label) {
            $cats = $mtdb->fetch_categories(array_merge($blogs, array('label' => $label, 'parent' => $last_cat_ids, 'show_empty' => 1, 'class' => $class)));
            if (!$cats)
                break;
            $last_cat_ids = array();
            foreach ($cats as $cat)
                $last_cat_ids[] = $cat->category_id;
        }
    }
    if ($cats)
        return $cats;
    if (!$cats && $path) {
        $cats = $mtdb->fetch_categories(array_merge($blogs, array('label' => $path, 'show_empty' => 1, 'class' => $class)));
        if ($cats)
            return $cats;
    }
    return null;
}

# sorts by length of tag name, from longest to shortest
function tagarray_name_sort($a, $b) {
    return strcmp(strtolower($a->tag_name), strtolower($b->tag_name));
}

function create_tag_expr_function($expr, &$tags, $datasource = 'entry') {
    $tags_used = array();
    $orig_expr = $expr;

    $tags_dict = array();
    foreach ($tags as $tag) {
        $tags_dict[$tag->tag_name] = $tag;
    }
    $tokens = preg_split('/\b(AND|NOT|OR|\(\))\b/i', $expr, NULL, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY);
    $result = '';
    foreach ($tokens as $t) {
        $upperToken = strtoupper( $t );
        if ( ($t === ')') || ($t === '(') || preg_match('/^\s+$/', $t) ) {
            $result .= $t; continue;
        }
        if ($upperToken === 'AND') {
            $result .= '&&'; continue;
        }
        if ($upperToken === 'OR') {
            $result .= '||'; continue;
        }
        if ($upperToken === 'NOT') {
            $result .= '!'; continue;
        }
        $t = trim($t);
        if (!array_key_exists($t, $tags_dict)) {
            # a tag that does not exists - is always false
            $result .= ' (0) ';
            continue;
        }
        $tag = $tags_dict[$t];
        $result .= ' array_key_exists(' . $tag->tag_id . ', $tm) ';
        $tags_used[$tag->tag_id] = $tag;
    }

    # Populate array (passed in by reference) of used tags
    $tags = array_values($tags_used);

    # Create a PHP-blessed function of that code and return it
    # if all is well.  This function will be used later to 
    # test for existence of specified tags in entries.
    $expr = '$tm = array_key_exists($e->'.$datasource.'_id, $c["t"]) ? $c["t"][$e->'.$datasource.'_id] : array(); return (' . $result . ');';
    $fn = create_function('&$e,&$c', $expr);
    if ($fn === FALSE) {
        echo "Invalid tag filter: $orig_expr";
        return;
    }
    return $fn;
}

function tag_normalize($str) {
    # FIXME: character set issues here...
    $private = preg_match('/^@/', $str) ? 1 : 0;
    $str = preg_replace('/[@!`\\<>\*&#\/~\?\'"\.\,=\(\)\${}\[\];:\ \+\-\r\n]+/', '', $str);
    $str = strtolower($str);
    if ($private) $str = '@' . $str;
    return $str;
}

function static_path($host) {
    $mt = MT::get_instance();
    $path = $mt->config('StaticWebPath');
    if (!$path) {
        $path = $mt->config('CGIPath');
        if (substr($path, 0, 1) == '/') {  # relative
            if (!preg_match('!/$!', $host))
                $host .= '/';
            if (preg_match('!^(https?://[^/:]+)(:\d+)?/!', $host, $matches)) {
                $path = $matches[1] . $path;
            }
        }
        if (substr($path, strlen($path) - 1, 1) != '/')
            $path .= '/';
        $path .= 'mt-static/';
    } elseif (substr($path, 0, 1) == '/') {
        if (!preg_match('!/$!', $host))
            $host .= '/';
        if (preg_match('!^(https?://[^/:]+)(:\d+)?/!', $host, $matches)) {
            $path = $matches[1] . $path;
        }        
    }
    if (substr($path, strlen($path) - 1, 1) != '/')
        $path .= '/';

    return $path;
}

function static_file_path() {
    $mt = MT::get_instance();
    $path = $mt->config('StaticFilePath');
    if (!$path) {
        $path = dirname(dirname(dirname(__FILE__)));
        $path .= DIRECTORY_SEPARATOR . 'mt-static' . DIRECTORY_SEPARATOR;
    }
    if (substr($path, strlen($path) - 1, 1) != DIRECTORY_SEPARATOR)
        $path .= DIRECTORY_SEPARATOR;

    return $path;
}

function support_directory_url() {
    $mt = MT::get_instance();
    $url = $mt->config('SupportDirectoryURL');
    if (!$url) {
        $url = static_path('');
        $url .= 'support/';
    }
    elseif (!preg_match('!/$!', $url) ) {
        $url .= '/';
    }
    return $url;
}

function support_directory_path() {
    $mt = MT::get_instance();
    $path = $mt->config('SupportDirectoryPath');
    if (!$path) {
        $path = static_file_path();
        $path .= 'support';
    }

    return $path;
}

function asset_path($path, $blog) {
    $site_path = $blog->site_path();
    $site_path = preg_replace('/\/$/', '', $site_path);
    $path = preg_replace('/^%r/', $site_path, $path);

    $static_file_path = support_directory_path();
    $static_file_path = preg_replace('/\/$/', '', $static_file_path);
    $path = preg_replace('/^%s/', $static_file_path, $path);

    $archive_path = $blog->archive_path();
    if ($archive_path) {
        $archive_path = preg_replace('/\/$/', '', $archive_path);
        $path = preg_replace('/^%a/', $archive_path, $path);
    }

    return $path;
}

function userpic_url($asset, $blog, $author) {
    $mt = MT::get_instance();
    $format = $mt->translate('userpic-[_1]-%wx%h%x', array($author->author_id));
    $max_dim = $mt->config('UserpicThumbnailSize');

    # generate thumbnail
    $src_file = asset_path($asset->asset_file_path, $blog);

    $cache_path = $mt->config('AssetCacheDir');
    $image_path = $cache_path . DIRECTORY_SEPARATOR . 'userpics';
    $support_directory_path = support_directory_path();

    require_once('thumbnail_lib.php');
    $thumb = new Thumbnail($src_file);
    $thumb->width($max_dim);
    $thumb->height($max_dim);
    $thumb->format($support_directory_path.DIRECTORY_SEPARATOR .$image_path.DIRECTORY_SEPARATOR.$format);
    $thumb->type('png');
    $thumb->square( true );
    $thumb->id($asset->asset_id);
    if (!$thumb->get_thumbnail()) {
        return '';
    }
    $basename = basename($thumb->dest());

    if (DIRECTORY_SEPARATOR != '/') {
        $image_path = str_replace(DIRECTORY_SEPARATOR, '/', $image_path);
    }
    $support_directory_url = support_directory_url();
    $url = sprintf("%s%s/%s", $support_directory_url, $image_path, $basename);
    return $url;
}

function get_thumbnail_file($asset, $blog, $args) {
    # Parse args
    $format = '%f-thumb-%wx%h-%i%x';
    if (isset($args['format']))
        $format = $args['format'];

    # Get parameter
    $site_path = $blog->site_path();
    $site_path = preg_replace('/\/$/', '', $site_path);
    $filename = asset_path($asset->asset_file_path, $blog);

    # Retrieve thumbnail
    $mt = MT::get_instance();
    $path_parts = pathinfo($filename);
    $cache_path = $mt->config('AssetCacheDir');

    $ts = preg_replace('![^0-9]!', '', $asset->asset_created_on);
    $date_stamp = format_ts('%Y/%m', $ts, $blog);
    $base_path = $site_path;
    $archive_path = $blog->archive_path();
    if (preg_match('/^%a/', $asset->asset_file_path) && !empty($archive_path)) {
        $base_path = $blog->archive_path();
        $base_path = preg_replace('/\/$/', '', $base_path);
    }

    $cache_dir = $base_path . DIRECTORY_SEPARATOR . $cache_path . DIRECTORY_SEPARATOR . $date_stamp . DIRECTORY_SEPARATOR;
    $thumb_name = $cache_dir . $format;

    # generate thumbnail
    require_once('thumbnail_lib.php');
    $thumb = new Thumbnail($filename);
    $thumb->id($asset->id);
    $thumb->format($thumb_name);
    $thumb->type('auto');
    if (isset($args['width']))
        $thumb->width($args['width']);
    if (isset($args['height']))
        $thumb->height($args['height']);
    if (isset($args['scale']))
        $thumb->scale($args['scale']);
    if (isset($args['square']))
        $thumb->square($args['square'] ? true : false);
    if (!$thumb->get_thumbnail()) {
        return '';
    }

    # make url
    $basename = basename($thumb->dest());
    $base_url = $blog->site_url();
    $archive_url = $blog->archive_url();
    if (preg_match('/^%a/', $asset->asset_file_path) && !empty($archive_url))
        $base_url = $blog->archive_url();
    if (!preg_match('!/$!', $base_url))
        $base_url .= '/';

    if (DIRECTORY_SEPARATOR != '/') {
        $cache_path = str_replace(DIRECTORY_SEPARATOR, '/', $cache_path);
    }
    $thumb_url = $base_url . $cache_path . '/' . $date_stamp . '/' . $basename;

    return array($thumb_url, $thumb->width(), $thumb->height(), $thumb->dest());
}

function asset_cleanup($str) {
    $str = preg_replace_callback('/<(?:[Ff][Oo][Rr][Mm]|[Ss][Pp][Aa][Nn])([^>]*?)\smt:asset-id="\d+"([^>]+?>)(.*?)<\/(?:[Ff][Oo][Rr][Mm]|[Ss][Pp][Aa][Nn])>/s', 'asset_cleanup_cb', $str);
    return $str;
}

function asset_cleanup_cb($matches) {
    $attr = $matches[1] . $matches[2];
    $inner = $matches[3];
    $attr = preg_replace('/\s[Cc][Oo][Nn][Tt][Ee][Nn][Tt][Ee][Dd][Ii][Tt][Aa][Bb][Ll][Ee]=([\'"][^\'"]*?[\'"]|[Ff][Aa][Ll][Ss][Ee])/', '', $attr);
    return '<span' . $attr . $inner . '</span>';
}

function create_role_expr_function($expr, &$roles, $datasource = 'author') {
    $roles_used = array();
    $orig_expr = $expr;

    $expr = preg_replace('/,/i', ' OR ', $expr);

    foreach ($roles as $role) {
        $rolen = $role->role_name;
        $roleid = $role->role_id;
        $oldexpr = $expr;
        $expr = preg_replace("!(?:\Q[$rolen]\E|\Q$rolen\E)!", "#$roleid", $expr);
        if ($oldexpr != $expr)
            $roles_used[$roleid] = $role;
    }

    $expr = preg_replace('/\bOR\b/i', '||', $expr);
    $expr = preg_replace('/\bAND\b/i', '&&', $expr);
    $expr = preg_replace('/\bNOT\b/i', '!', $expr);
    $expr = preg_replace_callback('/( |#\d+|&&|\|\||!|\(|\))|([^#0-9&|!()]+)/', 'create_expr_exception', $expr);

    $test_expr = preg_replace('/!|&&|\|\||\(0\)|\(|\)|\s|#\d+/', '', $expr);
    if ($test_expr != '') {
        echo "Invalid role filter: $orig_expr";
        return;
    }

    if (!preg_match('/!/', $expr))
        $roles = array_values($roles_used);

    $column_name = $datasource . '_id';
    $expr = preg_replace('/#(\d+)/', "array_key_exists('\\1', \$tm)", $expr);

    $expr = '$tm = array_key_exists($e->'.$datasource.'_id, $c["r"]) ? $c["r"][$e->'.$datasource.'_id] : array(); return ' . $expr . ';';
    $fn = create_function('&$e,&$c', $expr);
    if ($fn === FALSE) {
        echo "Invalid role filter: $orig_expr";
        return;
    }
    return $fn;
}

function create_status_expr_function($expr, &$status, $datasource = 'author') {
    $orig_expr = $expr;

    foreach ($status as $s) {
        $statusn = $s['name'];
        $statusid = $s['id'];
        $oldexpr = $expr;
        $expr = preg_replace("!(?:\Q[$statusn]\E|\Q$statusn\E)!", "#$statusid", $expr);
    }

    $expr = preg_replace('/\bOR\b/i', '||', $expr);
    $expr = preg_replace_callback('/( |#\d+|&&|\|\||!|\(|\))|([^#0-9&|!()]+)/', 'create_expr_exception', $expr);

    $test_expr = preg_replace('/!|&&|\|\||\(0\)|\(|\)|\s|#\d+/', '', $expr);
    if ($test_expr != '') {
        echo "Invalid status filter: $orig_expr";
        return;
    }

    $expr = preg_replace('/#(\d+)/', '$e->status == $1', $expr);
    $expr = 'return ' . $expr . ';';
    $fn = create_function('&$e,&$c', $expr);
    if ($fn === FALSE) {
        echo "Invalid status filter: $orig_expr";
        return;
    }
    return $fn;
}

function create_rating_expr_function($expr, $filter, $namespace, $datasource = 'entry') {
    $orig_expr = $expr;

    require_once 'rating_lib.php';
    $expr = '$ctx = $c; if ($ctx == null) { $mt = MT::get_instance(); $ctx = $mt->context(); }';
    if ($filter == 'min_score') {
        $expr .= '$ret = score_for($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  >= '.$orig_expr.';';
    } elseif ($filter == 'max_score') {
        $expr .= '$ret = score_for($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  <= '.$orig_expr.';';
    } elseif ($filter == 'min_rate') {
        $expr .= '$ret = score_avg($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  >= '.$orig_expr.';';
    } elseif ($filter == 'max_rate') {
        $expr .= '$ret = score_avg($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  <= '.$orig_expr.';';
    } elseif ($filter == 'min_count') {
        $expr .= '$ret = score_count($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  >= '.$orig_expr.';';
    } elseif ($filter == 'max_count') {
        $expr .= '$ret = score_count($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'")  <= '.$orig_expr.';';
    } elseif ($filter == 'scored_by') {
        $expr .= '$ret = get_score($ctx, $e->'.$datasource.'_id, "'.$datasource.'", "'.$namespace.'", '.$orig_expr.') > 0;';
    }
    $expr .= ' return $ret;';

    $fn = create_function('&$e,&$c', $expr);
    if ($fn === FALSE) {
        echo "Invalid rating filter: $orig_expr";
        return;
    }
    return $fn;
}

function _math_operation($op, $lvalue, $rvalue) {
    if (!preg_match('/^\-?[\d\.]+$/', $lvalue))
        return;
    if ( isset($rvalue) && !preg_match('/^\-?[\d\.]+$/', $rvalue))
        return;
    if ( !isset($rvalue)
      && $op != 'inc' && $op != 'dec' && $op != '++' && $op != '--' )
        return;
    if ( ( '+' == $op ) || ( 'add' == $op ) ) {
        return $lvalue + $rvalue;
    }
    elseif ( ( '++' == $op ) || ( 'inc' == $op ) ) {
        return $lvalue + 1;
    }
    elseif ( ( '-' == $op ) || ( 'sub' == $op ) ) {
        return $lvalue - $rvalue;
    }
    elseif ( ( '--' == $op ) || ( 'dec' == $op ) ) {
        return $lvalue - 1;
    }
    elseif ( ( '*' == $op ) || ( 'mul' == $op ) ) {
        return $lvalue * $rvalue;
    }
    elseif ( ( '/' == $op ) || ( 'div' == $op ) ) {
        if ( $rvalue == 0 )
            return;
        return $lvalue / $rvalue;
    }
    elseif ( ( '%' == $op ) || ( 'mod' == $op ) ) {
        // to be in line with perl equivalent
        $lvalue = floor($lvalue);
        $rvalue = floor($rvalue);
        if ( $rvalue == 0 )
            return;
        return $lvalue % $rvalue;
    }
    return;
}

function apply_text_filter ($ctx, $text, $filters) {
    if ($text == '' || $filters == '') return $text;

    $f = preg_split('/\s*,\s*/', $filters);
    if (is_array($f) && count($f) > 0) {
        foreach ($f as $filter) {
            if ($filter == '__default__') {
                $filter = 'convert_breaks';
            } elseif ($filter == '__sanitize__') {
                $filter = 'sanitize';
            }
            if ($filter == 'convert_breaks') {
                $text = html_text_transform($text);
            } elseif ($ctx->load_modifier($filter)) {
                $mod = 'smarty_modifier_'.$filter;
                $text = $mod($text);
            }
        }
    }

    return $text;
}

function get_page_column ($layout) {
    $columns = 0;
    if (empty($layout)) return $columns;

    $columns_map = array(
        'layout-wt'  => 2,
        'layout-tw'  => 2,
        'layout-wm'  => 2,
        'layout-mw'  => 2,
        'layout-wtt' => 3,
        'layout-twt' => 3);

    if(array_key_exists($layout, $columns_map))
         $columns = $columns_map[$layout];

    return $columns;
}

function mkpath($path, $mode = 0777) {
    return mkdir($path, $mode, true);
}

function _strip_index($url, $blog) {
    $mt = MT::get_instance();
    $index = $mt->config('IndexBasename');
    if (is_array($blog))
        $ext = $blog['blog_file_extension'];
    else
        $ext = $blog->file_extension;
    if ($ext != '') $ext = '.' . $ext;
    $index = preg_quote($index . $ext);
    $url = preg_replace("/\/$index(#.*)?$/", '/$1', $url);
    return $url;
}

function common_loop_vars() {
    return array(
        '__counter__',
        '__odd__',
        '__even__',
        '__first__',
        '__last__',
        '__key__',
        '__value__',
    );
}

function normalize_language($language, $locale, $ietf) {
    $real_lang = array('cz' => 'cs', 'dk' => 'da', 'jp' => 'ja', 'si' => 'sl');

    if ($real_lang[$language]) {
        $language = $real_lang[$language];
    }
    if ($locale) {
        $language = preg_replace('/^([A-Za-z][A-Za-z])([-_]([A-Za-z][A-Za-z]))?$/e', '\'$1\' . "_" . (\'$3\' ? strtoupper(\'$3\') : strtoupper(\'$1\'))', $language);
    } elseif ($ietf) {
        # http://www.ietf.org/rfc/rfc3066.txt
        $language = preg_replace('/_/', '-', $language);
    }
    return $language;
}

?>
