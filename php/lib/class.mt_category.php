<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
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
    protected $_prefix = "category_";
    protected $_has_meta = true;
    private $_children = null;

    public function children($val = null) {
        if (!empty($val))
            $this->_children[] = $val;
        return $val;
    }

    public function trackback() {
        require_once('class.mt_trackback.php');
        $trackback = new Trackback();
        $loaded = $trackback->Load("trackback_category_id = " . $this->category_id);
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
        if ($this->class != 'category_set_category') {
            return 0;
        }

        $blog_id = $this->blog_id;
        $cat_id = $this->id;

        $where = "cd_status = 2
                  and cd_blog_id = $blog_id";

        if (isset($terms['content_type_id']) && $terms['content_type_id']) {
            $content_type_id = $terms['content_type_id'];
        }
        if (isset($terms['content_field_id']) && $terms['content_field_id']) {
            $content_field_id = $terms['content_field_id'];
        }

        if (!$content_field_id
            && isset($terms['content_field_name'])
            && $terms['content_field_name']
        ) {
            $content_field_name = $terms['content_field_name'];
            if ($content_type_id) {
                $cf_content_type_filter = "and cf_content_type_id = $content_type_id";
            } else {
                $cf_content_type_filter = "";
            }
            $cf_where = "cf_name = \"$content_field_name\"
                         $cf_content_type_filter";
            require_once("class.mt_content_field.php");
            $content_field = new ContentField();
            $content_field->Load($cf_where);
            if (!$content_field->id) {
                return 0;
            }
            $content_field_id = $content_field->id;
        }

        if ($content_type_id) {
            $content_type_filter = 'and cf_idx_content_type_id = ' . $content_type_id;
        } else {
            $content_type_filter = '';
        }

        if ($content_field_id) {
            $content_field_filter = 'and cf_idx_content_field_id = ' . $content_field_id;
        } else {
            $content_field_filter = '';
        }

        $join = array();
        $join['mt_cf_idx'] =
            array(
                'condition' => "cf_idx_content_data_id = cd_id
                                $content_type_filter
                                $content_field_filter
                                and cf_idx_value_integer = $cat_id"
            );

        require_once("class.mt_content_data.php");
        $content_data = new ContentData();
        $cnt = $content_data->count(
            array(
                'where' => $where,
                'join' => $join,
                'distinct' => true,
            )
        );
        return $cnt;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Category', 'mt_category_meta','category_meta_category_id');	
?>
