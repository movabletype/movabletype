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
    protected $_prefix = "association_";

    public function role () {
        $col_name = "association_role_id";
        $role = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $role_id = $this->$col_name;

            require_once('class.mt_role.php');
            $role = new Role;
            $role->Load("role_id = $role_id");
        }

        return $role;
    }

    public function group () {
        $col_name = "association_group_id";
        $group = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $group_id = $this->$col_name;

            require_once('class.mt_group.php');
            $group = new Group;
            $group->Load("group_id = $group_id");
        }

        return $group;
    }

}
?>
