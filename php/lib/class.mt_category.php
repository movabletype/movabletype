<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_category
 */
class Category extends BaseObject
{
    public $_table = 'mt_category';
    public $_prefix = "category_";
    protected $_has_meta = true;
    private $_children = null;

    # category fields generated from perl implementation.
    public $category_allow_pings;
    public $category_author_id;
    public $category_basename;
    public $category_blog_id;
    public $category_category_set_id;
    public $category_class;
    public $category_created_by;
    public $category_created_on;
    public $category_description;
    public $category_id;
    public $category_label;
    public $category_modified_by;
    public $category_modified_on;
    public $category_parent;
    public $category_ping_urls;

    # category meta fields generated from perl implementation.
    public $category_mt_category_meta;
    public $category_show_fields;

    public function children($val = null) {
        if (!empty($val))
            $this->_children[] = $val;
        return $val;
    }

    public function trackback() {
        $mtdb = MT::get_instance()->db();
        require_once('class.mt_trackback.php');
        $trackback = new Trackback();
        $loaded = $trackback->Load("trackback_category_id = ".
                                                $mtdb->ph('trackback_category_id', $bind, $this->category_id), $bind);
        if (!$loaded)
            $trackback = null;
        return $trackback;
    }

    public function pings() {
        $pings = array();
        
        $tb = $this->trackback();
        if (!empty($tb)) {
            require_once('class.mt_tbping.php');
            $tbping = new TBPing();

            $pings = $tbping->Find("tbping_tb_id = " . $tb->id);
        }

        return $pings;
    }

    public function Save() {
        if (empty($this->category_class))
            $this->class = 'category';
        parent::Save();
    }

    public function entry_count () {
        $child_class = $this->class === 'category' ? 'entry' : 'page';
        $blog_id = $this->blog_id;
        $cat_id = $this->id;

        $where = "entry_status = 2
                  and entry_class = '$child_class'
                  and entry_blog_id = $blog_id";
        $join = array();
        $join['mt_placement'] =
            array(
                'condition' => "placement_entry_id = entry_id and placement_category_id = $cat_id"
            );

        require_once('class.mt_entry.php');
        $entry = new Entry();
        $cnt = $entry->count( array( 'where' => $where, 'join' => $join ) );
        return $cnt;
    }

    public function content_data_count($terms = array()) {
        $mtdb = MT::get_instance()->db();

        if (isset($terms['content_field_id']) && $terms['content_field_id']) {
            $content_field_id = $terms['content_field_id'];
        }

        if (empty($content_field_id) && isset($terms['content_field_name']) && $terms['content_field_name']) {
            $cf_where = 'cf_name = ' . $mtdb->ph('cf_name', $bind, $terms['content_field_name']);
            if (!empty($terms['content_type_id'])) {
                $cf_where .= ' and cf_content_type_id = '.
                                                    $mtdb->ph('cf_content_type_id', $bind, $terms['content_type_id']);
            }
            require_once("class.mt_content_field.php");
            $content_field = new ContentField();
            $content_field->Load($cf_where, $bind);
            if (!$content_field->id) {
                return 0;
            }
            $content_field_id = $content_field->id;
        }

        $bind_cd = [];

        $join = [];

        if (!empty($content_field_id)) {
            $content_field_filter = 'and objectcategory_cf_id = '.
                                                        $mtdb->ph('objectcategory_cf_id', $bind_cd, $content_field_id);
        } else {
            $content_field_filter = '';
        }

        $join['mt_objectcategory'] = [
            'condition' => "cd_id = objectcategory_object_id
            $content_field_filter
            and objectcategory_object_ds = 'content_data'
            and objectcategory_category_id = ". $mtdb->ph('objectcategory_category_id', $bind_cd, $this->id)
        ];

        $where = "cd_status = 2 and cd_blog_id = ". $mtdb->ph('cd_blog_id', $bind_cd, $this->blog_id);

        if (!empty($terms['content_type_id'])) {
            $where = $where. ' and cd_content_type_id = '.
                                                $mtdb->ph('cd_content_type_id', $bind_cd, $terms['content_type_id']);
        }

        require_once("class.mt_content_data.php");
        $content_data = new ContentData();
        $cnt = $content_data->count(
            array(
                'where' => $where,
                'bind' => $bind_cd,
                'join' => $join,
                'distinct' => true,
            )
        );
        return $cnt;
    }
}

// Relations
require_once("class.mt_category_meta.php");
ADODB_Active_Record::ClassHasMany('Category', 'mt_category_meta','category_meta_category_id', 'CategoryMeta');
?>
