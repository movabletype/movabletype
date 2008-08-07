<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $SERIALIZE_VERSION;
$SERIALIZE_VERSION = 2;

class MTSerialize {
    function unserialize($frozen) {
        return $this->_thaw_mt_2($frozen);
    }

    function serialize($data) {
        return $this->_freeze_mt_2($data);
    }

    function _freeze_mt_2($ref) {
        # version 2 signature: 'SERG' + packed long 0 + packed long protocol
        $freezer = create_function('$i, $v, $f', '
            if (is_array($v)) {
                $type = perl_array_type($v);
                return $i[$type]($i, $v, $f);
            } else {
                if (!is_null($v)) {
                    return "-" . pack("N", strlen($v)) . $v;
                } else {
                    return "U";
                }
            }
        ');

        # The ice tray freezes a single element, yielding a frozen cube
        $ice_tray = array(
            'HASH' => create_function('$i, $v, $f', '
                $cube = "H" . pack("N", count(array_keys($v)));
                foreach ($v as $k => $kv)
                    $cube .= pack("N", strlen($k)) . $k . $f($i, $kv, $f);
                return $cube;
            '),
            'ARRAY' => create_function('$i, $v, $f','
                $cube = "A" . pack("N", count($v));
                foreach ($v as $k) {
                    $cube .= $f($i, $k, $f);
                }
                return $cube;
            '),
        );

        return 'SERG' . pack('N', 0) . pack('N', 2) .
            $freezer($ice_tray, $ref, $freezer);
    }

    function _thaw_mt_2($frozen) {
        if (substr($frozen, 0, 4) != 'SERG') {
            return NULL;
        }
    
        $thawed = NULL;
        $refs = array(&$thawed);
    
        # The microwave thaws and pops out an element
        $microwave = array(
            'H' => create_function('&$s','   # hashref
                $keys = unpack("Nlen", substr($s["frozen"], $s["pos"], 4));
                $s["pos"] += 4;
                $values = array();
                $s["refs"][] = $values;
                for ($k = 0; $k < $keys["len"]; $k++ ) {
                    $key_name_len = unpack("Nlen", substr($s["frozen"], $s["pos"], 4));
                    $key_name = substr($s["frozen"], $s["pos"] + 4, $key_name_len["len"]);
                    $s["pos"] += 4 + $key_name_len["len"];
                    if ( strlen($s["frozen"]) >= $s["pos"] + 4 ) {
                        $h = $s["heater"];
                        $values[$key_name] = $h($s);
                    } else {
                        $values[$key_name] = "";
                    }
                }
                return $values;
            '),
            'A' => create_function('&$s', '   # arrayref
                $array_count = unpack("Nlen", substr($s["frozen"], $s["pos"], 4));
                $s["pos"] += 4;
                $values = array();
                $s["refs"][] = &$values;
                $h = $s["heater"];
                for ($a = 0; $a < $array_count["len"]; $a++) {
                    $values[] = $h($s);
                }
                return $values;
            '),
            'S' => create_function('&$s', '  # scalarref
                $slen = unpack("Nlen", substr($s["frozen"], $s["pos"], 4));
                $col_val = substr($s["frozen"], $s["pos"]+4, $slen["len"]);
                $s["pos"] += 4 + $slen["len"];
                $s["refs"][] = &$col_val;
                return $col_val;
            '),
            'R' => create_function('&$s', '   # refref
                $value = NULL;
                $s["refs"][] = &$value;
                $h = $s["heater"];
                $value = $h($s);
                return $value;
            '),
            '-' => create_function('&$s', '   # scalar value
                $slen = unpack("Nlen", substr($s["frozen"], $s["pos"], 4));
                $col_val = substr($s["frozen"], $s["pos"]+4, $slen["len"]);
                $s["pos"] += 4 + $slen["len"];
                return $col_val;
            '),
            'U' => create_function('&$s', '   # undef
                return NULL;
            '),
            'P' => create_function('&$s', '   # pointer to known ref
                $ptr = unpack("Npos", substr($s["frozen"], $s["pos"], 4));
                $s["pos"] += 4;
                return $s["refs"][$ptr["pos"]];
            ')
        );
    
        $heater = create_function('&$s', '
            $type = substr($s["frozen"], $s["pos"], 1); $s["pos"]++;
            if (array_key_exists($type, $s["microwave"])) {
                $h = $s["microwave"][$type];
                return $h($s);
            } else {
                return NULL;
            }
        ');

        $state = array('pos' => 12, 'heater' => $heater, 'refs' => $refs,
                       'frozen' => $frozen, 'microwave' => $microwave);
        return $heater($state);
    }
}

function perl_array_type(&$v) {
    $keys = array_keys($v);
    foreach ($keys as $i)
        if (!is_int($i)) return 'HASH';
    return 'ARRAY';
}
?>