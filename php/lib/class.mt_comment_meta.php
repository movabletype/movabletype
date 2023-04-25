<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class CommentMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $comment_meta_comment_id;
    public $comment_meta_type;
    public $comment_meta_vblob;
    public $comment_meta_vchar_idx;
    public $comment_meta_vchar;
    public $comment_meta_vclob;
    public $comment_meta_vdatetime_idx;
    public $comment_meta_vdatetime;
    public $comment_meta_vfloat_idx;
    public $comment_meta_vfloat;
    public $comment_meta_vinteger_idx;
    public $comment_meta_vinteger;
}
