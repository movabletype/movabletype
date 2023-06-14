<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_rebuild_trigger
 */
class RebuildTrigger extends BaseObject
{
    public $_table = 'mt_rebuild_trigger';
    public $_prefix = "rebuild_trigger_";
    private $_data = array();

    # rebuild_trigger fields generated from perl implementation.
    public $rebuild_trigger_id;
    public $rebuild_trigger_action;
    public $rebuild_trigger_blog_id;
    public $rebuild_trigger_created_by;
    public $rebuild_trigger_created_on;
    public $rebuild_trigger_ct_id;
    public $rebuild_trigger_ct_unique_id;
    public $rebuild_trigger_event;
    public $rebuild_trigger_modified_by;
    public $rebuild_trigger_modified_on;
    public $rebuild_trigger_object_type;
    public $rebuild_trigger_target;
    public $rebuild_trigger_target_blog_id;

    public function data($name = null) {
        if (!empty($name)) {
            $name = strtolower($name);
            return isset($this->_data[$name]) ? $this->_data[$name] : null;
        } else
            return $this->_data;
    }
}
?>
