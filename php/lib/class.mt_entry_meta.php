<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class EntryMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $entry_meta_entry_id;
    public $entry_meta_type;
    public $entry_meta_vblob;
    public $entry_meta_vchar_idx;
    public $entry_meta_vchar;
    public $entry_meta_vclob;
    public $entry_meta_vdatetime_idx;
    public $entry_meta_vdatetime;
    public $entry_meta_vfloat_idx;
    public $entry_meta_vfloat;
    public $entry_meta_vinteger_idx;
    public $entry_meta_vinteger;
}
