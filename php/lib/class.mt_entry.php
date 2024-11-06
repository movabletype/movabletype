<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_entry
 */
class Entry extends BaseObject
{
    public $_table = 'mt_entry';
    public $_prefix = "entry_";
    protected $_has_meta = true;

    # entry fields generated from perl implementation.
    public $entry_id;
    public $entry_allow_comments;
    public $entry_allow_pings;
    public $entry_atom_id;
    public $entry_author_id;
    public $entry_authored_on;
    public $entry_basename;
    public $entry_blog_id;
    public $entry_category_id;
    public $entry_class;
    public $entry_comment_count;
    public $entry_convert_breaks;
    public $entry_created_by;
    public $entry_created_on;
    public $entry_excerpt;
    public $entry_keywords;
    public $entry_modified_by;
    public $entry_modified_on;
    public $entry_ping_count;
    public $entry_pinged_urls;
    public $entry_status;
    public $entry_tangent_cache;
    public $entry_template_id;
    public $entry_text;
    public $entry_text_more;
    public $entry_title;
    public $entry_to_ping_urls;
    public $entry_unpublished_on;
    public $entry_week_number;
    public $entry_current_revision;

    # entry meta fields generated from perl implementation.
    public $entry_mt_entry_meta;
    public $entry_junk_log;
    public $entry_revision;

    public $entry_max_comment_created_on;

    public function category () {
        $places = $this->placement(true);
        if (empty($places))
            return null;

        $cat = $places[0]->category();
        return $cat;
    }

    public function categories($with_primary = true) {
        $places = $this->placement();
        if (empty($places))
            return null;

        $cats = array();
        foreach($places as $p) {
            if ( !$with_primary && $p->is_primary ) continue;
            $cat = $p->category();
            $cats[] = $cat;
        }
        return $cats;
    }

    public function placement($primary = false) {

        $where = "placement_entry_id = " . $this->id;
        if ($primary) {
            $where .= " and placement_is_primary = 1";
        }

        require_once('class.mt_placement.php');
        $place = new Placement();
        $places = $place->Find($where);
        return $places;
    }

    public function template () {
        $col_name = "entry_template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            require_once('class.mt_template.php');
            $template = new Template;
            $template->LoadByIntId($this->$col_name);
        }

        return $template;
    }

    public function comments () {
        require_once('class.mt_comment.php');
        $comment = new Comment;
        $comments = $comment->Find("comment_entry_id = " . $this->entry_id);
        return $comments;
    }

    public function trackback() {
        if (empty($this->entry_id))
            return null;

        require_once('class.mt_trackback.php');
        $trackback = new Trackback();
        $mtdb = MT::get_instance()->db();
        $loaded = $trackback->Load("trackback_entry_id = ". $mtdb->ph('trackback_entry_id', $bind, $this->entry_id), $bind);
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

	function Save() {
        if (empty($this->entry_class))
            $this->class = 'entry';
        return parent::Save();
    }
}

// Relations
require_once("class.mt_entry_meta.php");
ADODB_Active_Record::ClassHasMany('Entry', 'mt_entry_meta','entry_meta_entry_id', 'EntryMeta');
?>
