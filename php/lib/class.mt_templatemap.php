<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_templatemap.php 106007 2009-07-01 11:33:43Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_templatemap
 */
class TemplateMap extends BaseObject
{
    public $_table = 'mt_templatemap';
    protected $_prefix = "templatemap_";

    public function template() {
        $col_name = "templatemap_template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $template_id = $this->$col_name;

            require_once('class.mt_template.php');
            $template = new Template;
            $template->Load("template_id = $template_id");
        }

        return $template;
    }
}

