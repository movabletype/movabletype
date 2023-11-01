<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class ContentDataMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $cd_meta_cd_id;
    public $cd_meta_type;
    public $cd_meta_vblob;
    public $cd_meta_vchar_idx;
    public $cd_meta_vchar;
    public $cd_meta_vclob;
    public $cd_meta_vdatetime_idx;
    public $cd_meta_vdatetime;
    public $cd_meta_vfloat_idx;
    public $cd_meta_vfloat;
    public $cd_meta_vinteger_idx;
    public $cd_meta_vinteger;
}
