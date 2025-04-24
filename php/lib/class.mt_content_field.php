<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_cf
 */
class ContentField extends BaseObject
{
    public $_table = 'mt_cf';
    public $_prefix = "cf_";

    # content_field fields generated from perl implementation.
    public $cf_id;
    public $cf_blog_id;
    public $cf_content_type_id;
    public $cf_created_by;
    public $cf_created_on;
    public $cf_default;
    public $cf_description;
    public $cf_modified_by;
    public $cf_modified_on;
    public $cf_name;
    public $cf_related_cat_set_id;
    public $cf_related_content_type_id;
    public $cf_required;
    public $cf_type;
    public $cf_unique_id;
}


?>
