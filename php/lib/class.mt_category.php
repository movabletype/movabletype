<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_category
 */
class Category extends BaseObject
{
    public $_table = 'mt_category';
    protected $_prefix = "category_";
    protected $_has_meta = true;
    private $_children = null;

    public function children($val = null) {
        if (!empty($val))
            $this->_children[] = $val;
        return $val;
    }

    public function trackback() {
        require_once('class.mt_trackback.php');
        $trackback = new Trackback();
        $loaded = $trackback->Load("trackback_category_id = " . $this->category_id);
        if (!$loaded)
            $trackback = null;
        return $trackback;
    }

    public function pings() {
        $pings = array();
        
        $tb = $this->trackback();
        if (!empty($tb)) {
            require_once('class.mt_tbping.php');
            $tbping = new TBPing();

            $pings = $tbping->Find("tbping_tb_id = " . $tb->id);
        }

        return $pings;
    }

    public function Save() {
        if (empty($this->category_class))
            $this->class = 'category';
        parent::Save();
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Category', 'mt_category_meta','category_meta_category_id');	
?>
