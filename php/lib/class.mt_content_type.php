<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_content_type
 */
class ContentType extends BaseObject
{
    public $_table = 'mt_content_type';
    public $_prefix = "content_type_";

    # content_type fields generated from perl implementation.
    public $content_type_id;
    public $content_type_blog_id;
    public $content_type_created_by;
    public $content_type_created_on;
    public $content_type_data_label;
    public $content_type_description;
    public $content_type_fields;
    public $content_type_modified_by;
    public $content_type_modified_on;
    public $content_type_name;
    public $content_type_unique_id;
    public $content_type_user_disp_option;
    public $content_type_version;
}

?>
