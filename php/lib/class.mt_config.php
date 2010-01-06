<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
                if (!ereg('^\s*\#',$line)) {
                    // ignore lines starting with the hash symbol
                    if (preg_match('/^\s*(\S+)\s+(.*)$/', $line, $regs)) {
                        $key = strtolower(trim($regs[1]));
                        $value = trim($regs[2]);
                        //TODO un-specialize for hash
                        if (($key === 'pluginswitch') || ($key === 'pluginschemaversion')) { # special case for hash
                            if (preg_match('/^(.+)=(.+)$/', $value, $match))
                                $this->_data[$key][trim($match[1])] = trim($match[2]);
                        } else {
                            if (!isset($this->_data[$key]))
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

