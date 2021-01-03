<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_config
 */
class Config extends BaseObject
{
    public $_table = 'mt_config';
    protected $_prefix = "config_";
    private $_data = array();

    public function data($name = null) {
        if (empty($this->_data)) {
            $data = $this->data;
            $data = preg_split('/[\r?\n]/', $data);
            foreach ($data as $line) {
                // search through the file
                if (!preg_match('/^\s*\#/i',$line)) {
                    // ignore lines starting with the hash symbol
                    if (preg_match('/^\s*(\S+)\s+(.*)$/', $line, $regs)) {
                        $key = strtolower(trim($regs[1]));
                        $value = trim($regs[2]);
                        //TODO un-specialize for hash and array
                        if (in_array($key, MT::$config_type_hash)) { # special case for hash
                            if (preg_match('/^(.+)=(.+)$/', $value, $match))
                                $this->_data[$key][trim($match[1])] = trim($match[2]);
                        } else {
                            if (in_array($key, MT::$config_type_array)) # special case for array
                                $this->_data[$key][] = $value;
                            else
                                $this->_data[$key] = $value;
                        }
                    }
                }
            }
        }
        if (!empty($name)) {
            $name = strtolower($name);
            return isset($this->_data[$name]) ? $this->_data[$name] : null;
        } else
            return $this->_data;
    }
}
?>
