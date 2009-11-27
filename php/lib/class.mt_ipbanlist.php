<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_ipbanlist
 */
class IPBanList extends BaseObject
{
    public $_table = 'mt_ipbanlist';
    protected $_prefix = "ipbanlist_";
}

