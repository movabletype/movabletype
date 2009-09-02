<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_template.php 106007 2009-07-01 11:33:43Z ytakayama $

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

