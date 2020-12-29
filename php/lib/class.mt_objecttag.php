<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_objecttag
 */
class ObjectTag extends BaseObject
{
    public $_table = 'mt_objecttag';
    protected $_prefix = "objecttag_";

    public function related_object() {
        require_once("class.mt_" . $this->object_datasource . ".php");
        $class = $this->object_datasource;
        $obj = new $class;
        $obj->Load($this->object_datasource . "_id = " . $this->object_id);
        return $obj;
    }

    public function tag () {
        $col_name = "objecttag_tag_id";
        $tag = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $tag_id = $this->$col_name;

            require_once('class.mt_tag.php');
            $tag = new Tag;
            $tag->Load("tag_id = $tag_id");
        }

        return $tag;
    }
}
?>
