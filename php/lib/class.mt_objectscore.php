<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_objectscore.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_objectscore
 */
class ObjectScore extends BaseObject
{
    public $_table = 'mt_objectscore';
    protected $_prefix = "objectscore_";

    public function related_object() {
        require_once("class.mt_" . $this->object_ds . ".php");
        $class = $this->object_ds;
        $obj = new $class;
        $obj->Load($this->object_ds . "_id = " . $this->object_id);
        return $obj;
    }

}

