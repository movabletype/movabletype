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
    public $_prefix = "tbping_";
    protected $_has_meta = true;

    # tbping fields generated from perl implementation.
    public $tbping_id;
    public $tbping_blog_id;
    public $tbping_blog_name;
    public $tbping_created_by;
    public $tbping_created_on;
    public $tbping_excerpt;
    public $tbping_ip;
    public $tbping_junk_log;
    public $tbping_junk_score;
    public $tbping_junk_status;
    public $tbping_last_moved_on;
    public $tbping_modified_by;
    public $tbping_modified_on;
    public $tbping_source_url;
    public $tbping_tb_id;
    public $tbping_title;
    public $tbping_visible;

    # tbping meta fields generated from perl implementation.
    public $tbping_mt_tbping_meta;

    public function trackback() {
        $col_name = "tbping_tb_id";
        $tb = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $tb_id = $this->$col_name;

            require_once('class.mt_trackback.php');
            $tb = new Trackback;
            $tb->LoadByIntId($tb_id);
        }

        return $tb;
    }
}

// Relations
require_once("class.mt_tbping_meta.php");
ADODB_Active_Record::ClassHasMany('TBPing', 'mt_tbping_meta','tbping_meta_tbping_id', 'TBPingMeta');
?>
