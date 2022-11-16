<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_rebuild_trigger
 */
class RebuildTrigger extends BaseObject
{
    public $_table = 'mt_rebuild_trigger';
    protected $_prefix = "rebuild_trigger_";
    private $_data = array();

    public function data($name = null) {
        if (!empty($name)) {
            $name = strtolower($name);
            return isset($this->_data[$name]) ? $this->_data[$name] : null;
        } else
            return $this->_data;
    }
}
?>
