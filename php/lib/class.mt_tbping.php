<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_tbping
 */
class TBPing extends BaseObject
{
    public $_table = 'mt_tbping';
    protected $_prefix = "tbping_";
    protected $_has_meta = true;

    public function trackback() {
        $col_name = "tbping_tb_id";
        $tb = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $tb_id = $this->$col_name;

            require_once('class.mt_trackback.php');
            $tb = new Trackback;
            $tb->Load("trackback_id = $tb_id");
        }

        return $tb;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('TBPing', 'mt_tbping_meta','tbping_meta_tbping_id');	
?>
