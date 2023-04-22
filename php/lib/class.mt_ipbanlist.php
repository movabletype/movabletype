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
    public $_prefix = "ipbanlist_";

    # ipbanlist fields generated from perl implementation.
    public $ipbanlist_id;
    public $ipbanlist_blog_id;
    public $ipbanlist_created_by;
    public $ipbanlist_created_on;
    public $ipbanlist_ip;
    public $ipbanlist_modified_by;
    public $ipbanlist_modified_on;
}
?>
