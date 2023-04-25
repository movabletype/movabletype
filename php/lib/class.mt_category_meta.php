<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class CategoryMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $category_meta_category_id;
    public $category_meta_type;
    public $category_meta_vblob;
    public $category_meta_vchar_idx;
    public $category_meta_vchar;
    public $category_meta_vclob;
    public $category_meta_vdatetime_idx;
    public $category_meta_vdatetime;
    public $category_meta_vfloat_idx;
    public $category_meta_vfloat;
    public $category_meta_vinteger_idx;
    public $category_meta_vinteger;
}
