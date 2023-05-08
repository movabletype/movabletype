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
    public $_prefix = "template_";
    protected $_has_meta = true;

    # template fields generated from perl implementation.
    public $template_id;
    public $template_blog_id;
    public $template_build_dynamic;
    public $template_build_interval;
    public $template_build_type;
    public $template_content_type_id;
    public $template_created_by;
    public $template_created_on;
    public $template_identifier;
    public $template_linked_file;
    public $template_linked_file_mtime;
    public $template_linked_file_size;
    public $template_modified_by;
    public $template_modified_on;
    public $template_name;
    public $template_outfile;
    public $template_rebuild_me;
    public $template_text;
    public $template_type;
    public $template_current_revision;

    # template meta fields generated from perl implementation.
    public $template_mt_template_meta;
    public $template_cache_expire_event;
    public $template_cache_expire_interval;
    public $template_cache_expire_type;
    public $template_cache_path;
    public $template_include_with_ssi;
    public $template_last_rebuild_time;
    public $template_modulesets;
    public $template_page_layout;
    public $template_revision;

    public function blog() {
        if ($this->template_blog_id === 0)
            return null;

        return parent::blog();
    }
}

// Relations
require_once("class.mt_template_meta.php");
ADODB_Active_Record::ClassHasMany('Template', 'mt_template_meta','template_meta_template_id', 'TemplateMeta');
?>
