<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
        } elseif ( is_array( $val ) || is_object( $val ) ) {
            $this->data = $mt->db()->serialize($val);
        } else {
            $this->session_data = $val;
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
