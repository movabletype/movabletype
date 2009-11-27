<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_author
 */
class Author extends BaseObject
{
    public $_table = 'mt_author';
    protected $_prefix = "author_";
    protected $_has_meta = true;

    public function permissions( $blog_id = null ) {
        require_once('class.mt_permission.php');

        $whereOrder = "permission_author_id = " . $this->id;
        if ( !is_null( $blog_id ) ) {
            if (is_array($blog_id)) {
                $ids = join(',', $blog_id);
                 $whereOrder = $whereOrder . " and permission_blog_id in ( $ids )";
            } else {
                $whereOrder= $whereOrder . " and permission_blog_id = $blog_id";
            }
        }
        $whereOrder = $whereOrder . " order by permission_blog_id";

        $permission = new Permission;
        return $permission->Find($whereOrder);
    }

    public function userpic() {
        $userpic_id = $this->author_userpic_asset_id;

        if (empty($userpic_id) || !is_numeric($userpic_id))
            return;

        require_once('class.mt_asset.php');
        $asset = new Asset;
        $asset->Load("asset_id = $userpic_id");
        return $asset;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Author', 'mt_author_meta','author_meta_author_id');	

