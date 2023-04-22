<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_notification
 */
class Notification extends BaseObject
{
    public $_table = 'mt_notification';
    public $_prefix = "notification_";

    # notification fields generated from perl implementation.
    public $notification_id;
    public $notification_blog_id;
    public $notification_created_by;
    public $notification_created_on;
    public $notification_email;
    public $notification_modified_by;
    public $notification_modified_on;
    public $notification_name;
    public $notification_url;
}
?>
