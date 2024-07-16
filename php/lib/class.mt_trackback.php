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
    public $_prefix = "trackback_";

    # trackback fields generated from perl implementation.
    public $trackback_id;
    public $trackback_blog_id;
    public $trackback_category_id;
    public $trackback_created_by;
    public $trackback_created_on;
    public $trackback_description;
    public $trackback_entry_id;
    public $trackback_is_disabled;
    public $trackback_modified_by;
    public $trackback_modified_on;
    public $trackback_passphrase;
    public $trackback_rss_file;
    public $trackback_title;
    public $trackback_url;

    public function category() {
        $col_name = "trackback_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            require_once('class.mt_category.php');
            $category = new Category;
            $ret = $category->LoadByIntId($this->$col_name);
            if (!$ret) $category = null;
        }

        return $category;
    }
}
?>
