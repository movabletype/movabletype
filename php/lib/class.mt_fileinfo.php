<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_fileinfo
 */
class FileInfo extends BaseObject
{
    public $_table = 'mt_fileinfo';
    protected $_prefix = "fileinfo_";

    public function category () {
        $col_name = "fileinfo_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $category_id = $this->$col_name;

            require_once('class.mt_category.php');
            $category = new Category;
            $category->Load("category_id = $category_id");
        }

        return $category;
    }

    public function template () {
        $col_name = $this->_prefix . "template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $template_id = $this->$col_name;

            require_once('class.mt_template.php');
            $template = new Template;
            $template->Load("template_id = $template_id");
        }

        return $template;
    }

    public function templatemap () {
        $col_name = $this->_prefix . "templatemap_id";
        $templatemap = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name) && $this->$col_name > 0) {
            $templatemap_id = $this->$col_name;

            $templatemap = $this->load_cache($this->_prefix . ":" . $this->id . ":templatemap:" . $templatemap_id);
            if (empty($templatemap)) {
                require_once('class.mt_templatemap.php');
                $templatemap = new TemplateMap;
                $templatemap->Load("templatemap_id = $templatemap_id");
                $this->cache($this->_prefix . ":" . $this->id . ":templatemap:" . $templatemap->id, $templatemap);
            }
        }

        return $templatemap;
    }
}
?>
