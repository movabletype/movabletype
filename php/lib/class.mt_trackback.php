<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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
?>
