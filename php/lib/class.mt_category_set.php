<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_category_set
 */
class CategorySet extends BaseObject
{
    public $_table = 'mt_category_set';
    public $_prefix = "category_set_";

    # category_set fields generated from perl implementation.
    public $category_set_id;
    public $category_set_blog_id;
    public $category_set_created_by;
    public $category_set_created_on;
    public $category_set_modified_by;
    public $category_set_modified_on;
    public $category_set_name;
    public $category_set_order;
}
?>
