<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_comment
 */
class Comment extends BaseObject
{
    public $_table = 'mt_comment';
    public $_prefix = "comment_";
    protected $_has_meta = true;

    // comment fields generated from perl implementation.
    public $comment_id;
    public $comment_author;
    public $comment_blog_id;
    public $comment_commenter_id;
    public $comment_created_by;
    public $comment_created_on;
    public $comment_email;
    public $comment_entry_id;
    public $comment_ip;
    public $comment_junk_log;
    public $comment_junk_score;
    public $comment_junk_status;
    public $comment_last_moved_on;
    public $comment_modified_by;
    public $comment_modified_on;
    public $comment_parent_id;
    public $comment_text;
    public $comment_url;
    public $comment_visible;

    # comment meta fields generated from perl implementation.
    public $comment_mt_comment_meta;

    public function commenter() {
        $commenter_id = $this->comment_commenter_id;

        if (empty($commenter_id) || !is_numeric($commenter_id))
            return;

        require_once('class.mt_author.php');
        $author = new Author;
        if ($author->LoadByIntId($commenter_id))
            return $author;

        return null;
    }
}

// Relations
require_once("class.mt_comment_meta.php");
ADODB_Active_Record::ClassHasMany('Comment', 'mt_comment_meta','comment_meta_comment_id', 'CommentMeta');
?>
