<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_plugindata
 */
class PluginData extends BaseObject
{
    public $_table = 'mt_plugindata';
    protected $_prefix = "plugindata_";
    private $_data = null;

    public function data($name = null) {
        $mt = MT::get_instance();
        $this->_data = $mt->db()->unserialize($this->data);

        if (!empty($name))
            if (isset($this->_data[$name]))
                return $this->_data[$name];
            else
                return null;
        else
            return $this->_data;

    }

}
