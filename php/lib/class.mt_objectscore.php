<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_objectscore
 */
class ObjectScore extends BaseObject
{
    public $_table = 'mt_objectscore';
    public $_prefix = "objectscore_";

    # objectscore fields generated from perl implementation.
    public $objectscore_id;
    public $objectscore_author_id;
    public $objectscore_created_by;
    public $objectscore_created_on;
    public $objectscore_ip;
    public $objectscore_modified_by;
    public $objectscore_modified_on;
    public $objectscore_namespace;
    public $objectscore_object_ds;
    public $objectscore_object_id;
    public $objectscore_score;

    public function related_object() {
        require_once("class.mt_" . $this->object_ds . ".php");
        $class = $this->object_ds;
        $obj = new $class;
        $obj->LoadByIntId($this->object_id);
        return $obj;
    }

}
?>
