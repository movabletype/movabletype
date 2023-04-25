<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class BlogMeta extends ADOdb_Active_Record {

    public $blog_meta_blog_id;
    public $blog_meta_type;
    public $blog_meta_vblob;
    public $blog_meta_vchar;
    public $blog_meta_vchar_idx;
    public $blog_meta_vclob;
    public $blog_meta_vdatetime;
    public $blog_meta_vdatetime_idx;
    public $blog_meta_vfloat;
    public $blog_meta_vfloat_idx;
    public $blog_meta_vinteger;
    public $blog_meta_vinteger_idx;
    public $foreignKey;
}
