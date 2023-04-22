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
    public $_prefix = "asset_";
    protected $_has_meta = true;

    # asset fields generated from perl implementation.
    public $asset_id;
    public $asset_blog_id;
    public $asset_class;
    public $asset_created_by;
    public $asset_created_on;
    public $asset_description;
    public $asset_file_ext;
    public $asset_file_name;
    public $asset_file_path;
    public $asset_label;
    public $asset_mime_type;
    public $asset_modified_by;
    public $asset_modified_on;
    public $asset_parent;
    public $asset_url;

    # asset meta fields generated from perl implementation.
    public $asset_mt_asset_meta;

    public $asset_image_height;
    public $asset_image_width;
}

// Relations
require_once("class.mt_meta.php");
ADODB_Active_Record::ClassHasMany('Asset', 'mt_asset_meta','asset_meta_asset_id', 'Meta');
?>
