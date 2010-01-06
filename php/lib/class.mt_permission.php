<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_permission
 */
class Permission extends BaseObject
{
    public $_table = 'mt_permission';
    protected $_prefix = "permission_";
}

