<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_template
 */
class Template extends BaseObject
{
    public $_table = 'mt_template';
    protected $_prefix = "template_";
    protected $_has_meta = true;

    public function blog() {
        if ($this->template_blog_id === 0)
            return null;

        return parent::blog();
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Template', 'mt_template_meta','template_meta_template_id');	
?>
