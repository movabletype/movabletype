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
    public $_prefix = "session_";

    # session fields generated from perl implementation.
    public $session_id;
    public $session_data;
    public $session_duration;
    public $session_email;
    public $session_kind;
    public $session_name;
    public $session_start;

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

        // avoid strcmp warnings
        // See https://github.com/ADOdb/ADOdb/blob/bacd08a8232b6d941b9902f02d323f53de81fafe/adodb-active-record.inc.php#L1081
        $this->session_data = $this->session_data ?? '';

        $ret = parent::Save();
        if ( $ret ) {
            $mt = MT::get_instance();
            $db = $mt->db()->db();
            $db->UpdateBlob('mt_session', 'session_data', $val, "session_id=". $db->Quote($this->id), 'BLOB');
        }
    }
}
?>
