<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_trackback.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_trackback
 */
class Trackback extends BaseObject
{
    public $_table = 'mt_trackback';
    protected $_prefix = "trackback_";

    public function category() {
        $col_name = "trackback_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $category_id = $this->$col_name;

            require_once('class.mt_category.php');
            $category = new Category;
            $ret = $category->Load("category_id = $category_id");
            if (!$ret) $category = null;
        }

        return $category;
    }
}

