<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_tag.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_tag
 */
class Tag extends BaseObject
{
    public $_table = 'mt_tag';
    protected $_prefix = "tag_";
}

