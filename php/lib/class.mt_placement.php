<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
