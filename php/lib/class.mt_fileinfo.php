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
    public $_prefix = "fileinfo_";

    # fileinfo fields generated from perl implementation.
    public $fileinfo_id;
    public $fileinfo_archive_type;
    public $fileinfo_author_id;
    public $fileinfo_blog_id;
    public $fileinfo_category_id;
    public $fileinfo_cd_id;
    public $fileinfo_entry_id;
    public $fileinfo_file_path;
    public $fileinfo_startdate;
    public $fileinfo_template_id;
    public $fileinfo_templatemap_id;
    public $fileinfo_url;
    public $fileinfo_virtual;
    
    public function category () {
        $col_name = "fileinfo_category_id";
        $category = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            require_once('class.mt_category.php');
            $category = new Category;
            $category->LoadByIntId($this->$col_name);
        }

        return $category;
    }

    public function template () {
        $col_name = $this->_prefix . "template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            require_once('class.mt_template.php');
            $template = new Template;
            $template->LoadByIntId($this->$col_name);
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
                $templatemap->LoadByIntId($templatemap_id);
                $this->cache($this->_prefix . ":" . $this->id . ":templatemap:" . $templatemap->id, $templatemap);
            }
        }

        return $templatemap;
    }
}
?>
