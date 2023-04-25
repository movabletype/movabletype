<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class AssetMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $asset_meta_asset_id;
    public $asset_meta_type;
    public $asset_meta_vblob;
    public $asset_meta_vchar_idx;
    public $asset_meta_vchar;
    public $asset_meta_vclob;
    public $asset_meta_vdatetime_idx;
    public $asset_meta_vdatetime;
    public $asset_meta_vfloat_idx;
    public $asset_meta_vfloat;
    public $asset_meta_vinteger_idx;
    public $asset_meta_vinteger;
}
