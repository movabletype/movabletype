<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_association
 */
class Association extends BaseObject
{
    public $_table = 'mt_association';
    public $_prefix = "association_";

    # association fields generated from perl implementation.
    public $association_id;
    public $association_author_id;
    public $association_blog_id;
    public $association_created_by;
    public $association_created_on;
    public $association_group_id;
    public $association_modified_by;
    public $association_modified_on;
    public $association_role_id;
    public $association_type;
    
    public function role () {
        $col_name = "association_role_id";
        $role = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $role_id = $this->$col_name;

            require_once('class.mt_role.php');
            $role = new Role;
            $role->LoadByIntId($role_id);
        }

        return $role;
    }

    /**
     *
     * @TODO This method is not in use from core and doesn't even work because class.mt_group.php is not implemented.
     */
    public function group () {
        $col_name = "association_group_id";
        $group = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $group_id = $this->$col_name;

            require_once('class.mt_group.php');
            $group = new Group;
            $group->LoadByIntId($group_id);
        }

        return $group;
    }

}
?>
