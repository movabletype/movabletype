<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_touch
 */
class Touch extends BaseObject
{
    public $_table = 'mt_touch';
    public $_prefix = "touch_";

    # touch fields generated from perl implementation.
    public $touch_id;
    public $touch_blog_id;
    public $touch_modified_on;
    public $touch_object_type;
}
?>
