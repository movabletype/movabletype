<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
?>
