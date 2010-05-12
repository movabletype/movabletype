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

    public function data( $val = null ) {
        $mt = MT::get_instance();
        if ( is_null( $val ) ) {
           $this->_data = $mt->db()->unserialize($this->data);
            return $this->_data;
       } else {
           $this->data = $mt->db()->serialize($val);
       }
    }

    public function Save() {
        $val = $this->data;
        $this->data = null;
        $ret = parent::Save();
        if ( $ret ) {
            $mt = MT::get_instance();
            $mt->db()->db()->UpdateBlob( 'mt_session', 'session_data', $val, "session_id='".$this->id."'", 'BLOB' );
        }
    }
}
?>
