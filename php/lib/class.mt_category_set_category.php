<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.mt_category.php");

/***
 * Class for mt_category (Category for Category Set)
 */
class CategorySetCategory extends Category
{
    public function trackback() {
        return null;
    }

    public function pings() {
        return array();
    }

    public function Save() {
        if (empty($this->category_class))
            $this->class = 'category_set_category';
        parent::Save();
    }

    public function entry_count() {
        return 0;
    }

    public function content_data_count($terms = array()) {
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('CategorySetCategory', 'mt_category_meta','category_meta_category_id');

