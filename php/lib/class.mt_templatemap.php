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
    public $_prefix = "templatemap_";

    # templatemap fields generated from perl implementation.
    public $templatemap_id;
    public $templatemap_archive_type;
    public $templatemap_blog_id;
    public $templatemap_build_interval;
    public $templatemap_build_type;
    public $templatemap_cat_field_id;
    public $templatemap_dt_field_id;
    public $templatemap_file_template;
    public $templatemap_is_preferred;
    public $templatemap_template_id;

    public function template() {
        $col_name = "templatemap_template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            require_once('class.mt_template.php');
            $template = new Template;
            $template->LoadByIntId($this->$col_name);
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
        require_once('class.mt_content_field.php');
        $cf = new ContentField;
        $cf->LoadByIntId($this->$col_name);
        return $cf;
    }
}
?>
