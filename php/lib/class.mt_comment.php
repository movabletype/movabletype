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
    protected $_prefix = "comment_";
    protected $_has_meta = true;

    public function commenter() {
        $commenter_id = $this->comment_commenter_id;

        if (empty($commenter_id) || !is_numeric($commenter_id))
            return;

        require_once('class.mt_author.php');
        $author = new Author;
        if ( $author->Load("author_id = $commenter_id") )
            return $author;

        return null;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Comment', 'mt_comment_meta','comment_meta_comment_id');	
?>
