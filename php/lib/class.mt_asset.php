<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_asset
 */
class Asset extends BaseObject
{
    public $_table = 'mt_asset';
    protected $_prefix = "asset_";
    protected $_has_meta = true;
}

// Relations
ADODB_Active_Record::ClassHasMany('Asset', 'mt_asset_meta','asset_meta_asset_id');	
?>
