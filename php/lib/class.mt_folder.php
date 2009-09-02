<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_folder.php 106007 2009-07-01 11:33:43Z ytakayama $

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
