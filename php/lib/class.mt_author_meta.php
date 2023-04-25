<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class AuthorMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $author_meta_author_id;
    public $author_meta_type;
    public $author_meta_vblob;
    public $author_meta_vchar_idx;
    public $author_meta_vchar;
    public $author_meta_vclob;
    public $author_meta_vdatetime_idx;
    public $author_meta_vdatetime;
    public $author_meta_vfloat_idx;
    public $author_meta_vfloat;
    public $author_meta_vinteger_idx;
    public $author_meta_vinteger;
}
