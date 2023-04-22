<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_objectcategory
 */
class ObjectCategory extends BaseObject
{
    public $_table = 'mt_objectcategory';
    public $_prefix = "objectcategory_";

    # objectcategory fields generated from perl implementation.
    public $objectcategory_id;
    public $objectcategory_blog_id;
    public $objectcategory_category_id;
    public $objectcategory_cf_id;
    public $objectcategory_is_primary;
    public $objectcategory_object_ds;
    public $objectcategory_object_id;
}
?>
