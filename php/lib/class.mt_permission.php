<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_permission
 */
class Permission extends BaseObject
{
    public $_table = 'mt_permission';
    public $_prefix = "permission_";

    # permission fields generated from perl implementation.
    public $permission_id;
    public $permission_author_id;
    public $permission_blog_id;
    public $permission_blog_prefs;
    public $permission_created_by;
    public $permission_created_on;
    public $permission_entry_prefs;
    public $permission_modified_by;
    public $permission_modified_on;
    public $permission_page_prefs;
    public $permission_permissions;
    public $permission_restrictions;
    public $permission_role_mask;
    public $permission_template_prefs;
}
?>
