<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_session
 */
class Session extends BaseObject
{
    public $_table = 'mt_session';
    protected $_prefix = "session_";

    public function data() {
        $mt = MT::get_instance();
        $this->_data = $mt->db()->unserialize($this->data);

        return $this->_data;
    }
}
?>
