<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.mt_entry.php");

/***
 * Class for mt_entry (Page)
 */
class Page extends Entry
{
	function Save() {
        if (empty($this->entry_class))
            $this->entry_class = 'page';
        return parent::Save();
    }

    public function folder() {
        return $this->category();
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Page', 'mt_entry_meta','entry_meta_entry_id');	
?>
