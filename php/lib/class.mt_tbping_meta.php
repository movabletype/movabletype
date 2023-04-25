<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class TBPingMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $tbping_meta_tbping_id;
    public $tbping_meta_type;
    public $tbping_meta_vblob;
    public $tbping_meta_vchar_idx;
    public $tbping_meta_vchar;
    public $tbping_meta_vclob;
    public $tbping_meta_vdatetime_idx;
    public $tbping_meta_vdatetime;
    public $tbping_meta_vfloat_idx;
    public $tbping_meta_vfloat;
    public $tbping_meta_vinteger_idx;
    public $tbping_meta_vinteger;
}
