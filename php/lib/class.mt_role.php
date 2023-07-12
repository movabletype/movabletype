<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_role
 */
class Role extends BaseObject
{
    public $_table = 'mt_role';
    public $_prefix = "role_";

    # role fields generated from perl implementation.
    public $role_id;
    public $role_created_by;
    public $role_created_on;
    public $role_description;
    public $role_is_system;
    public $role_modified_by;
    public $role_modified_on;
    public $role_name;
    public $role_permissions;
    public $role_role_mask;
    public $role_role_mask2;
    public $role_role_mask3;
    public $role_role_mask4;
}
?>
