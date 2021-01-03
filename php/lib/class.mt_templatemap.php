<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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

    public function cat_field() {
        $col_name = 'templatemap_cat_field_id';
        return $this->get_content_field($col_name);
    }

    public function dt_field() {
        $col_name = 'templatemap_dt_field_id';
        return $this->get_content_field($col_name);
    }

    private function get_content_field($col_name) {
        if (!isset($this->$col_name) || !is_numeric($this->$col_name)) {
            return null;
        }
        $cf_id = $this->$col_name;
        require_once('class.mt_content_field.php');
        $cf = new ContentField;
        $cf->Load("cf_id = $cf_id");
        return $cf;
    }
}
?>
