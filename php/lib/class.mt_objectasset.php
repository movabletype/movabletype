<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_objectasset
 */
class ObjectAsset extends BaseObject
{
    public $_table = 'mt_objectasset';
    protected $_prefix = "objectasset_";

    public function asset () {
        $col_name = "objectasset_asset_id";
        $asset = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $asset_id = $this->$col_name;

            require_once('class.mt_asset.php');
            $asset = new Asset;
            $asset->Load("asset_id = $asset_id");
        }

        return $asset;
    }

    public function related_object() {
        require_once("class.mt_" . $this->object_ds . ".php");
        $class = $this->object_ds;
        $obj = new $class;
        $obj->Load($this->object_ds . "_id = " . $this->object_id);
        return $obj;
    }
}

