<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.mt_category.php");

/***
 * Class for mt_category (Folder)
 */
class Folder extends Category
{
    public function Save() {
        if (empty($this->category_class))
            $this->class = 'folder';
        parent::Save();
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Folder', 'mt_category_meta','category_meta_category_id');	
?>
