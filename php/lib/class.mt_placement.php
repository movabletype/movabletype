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
    public $_prefix = "placement_";

    # placement fields generated from perl implementation.
    public $placement_id;
    public $placement_blog_id;
    public $placement_category_id;
    public $placement_entry_id;
    public $placement_is_primary;

    public function category() {
        $col_name = "placement_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {

            $entry = $this->entry();
            if (empty($entry))
                return null;

            if ($entry->class === 'entry') {
                require_once('class.mt_category.php');
                $category = new Category;
                $loaded = $category->LoadByIntId($this->$col_name);
            } else {
                require_once('class.mt_folder.php');
                $category = new Folder();
                $loaded = $category->LoadByIntId($this->$col_name);
            }
            if (!$loaded)
                $category = null;
        }

        return $category;
    }
}
?>
