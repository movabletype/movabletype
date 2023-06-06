<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

class TemplateMeta extends ADOdb_Active_Record {

    public $foreignKey;
    public $template_meta_template_id;
    public $template_meta_type;
    public $template_meta_vblob;
    public $template_meta_vchar_idx;
    public $template_meta_vchar;
    public $template_meta_vclob;
    public $template_meta_vdatetime_idx;
    public $template_meta_vdatetime;
    public $template_meta_vfloat_idx;
    public $template_meta_vfloat;
    public $template_meta_vinteger_idx;
    public $template_meta_vinteger;
}
