<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
