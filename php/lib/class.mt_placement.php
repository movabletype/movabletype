<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_placement
 */
class Placement extends BaseObject
{
    public $_table = 'mt_placement';
    protected $_prefix = "placement_";

    public function category() {
        $col_name = "placement_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $category_id = $this->$col_name;

            $entry = $this->entry();
            if (empty($entry))
                return null;

            if ($entry->class === 'entry') {
                require_once('class.mt_category.php');
                $category = new Category;
                $loaded = $category->Load("category_id = $category_id");
            } else {
                require_once('class.mt_folder.php');
                $category = new Folder();
                $loaded = $category->Load("category_id = $category_id");
            }
            if (!$loaded)
                $category = null;
        }

        return $category;
    }
}
?>
