<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('adodb-active-record.inc.php');

// Allow dynamic properties for now since the list is not done yet

#[\AllowDynamicProperties]
class Meta extends ADOdb_Active_Record {

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
    public $asset_meta_asset_id;
    public $asset_meta_type;
    public $asset_meta_vblob;
    public $asset_meta_vchar_idx;
    public $asset_meta_vchar;
    public $asset_meta_vclob;
    public $asset_meta_vdatetime_idx;
    public $asset_meta_vdatetime;
    public $asset_meta_vfloat_idx;
    public $asset_meta_vfloat;
    public $asset_meta_vinteger_idx;
    public $asset_meta_vinteger;
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
    public $entry_meta_entry_id;
    public $entry_meta_type;
    public $entry_meta_vblob;
    public $entry_meta_vchar_idx;
    public $entry_meta_vchar;
    public $entry_meta_vclob;
    public $entry_meta_vdatetime_idx;
    public $entry_meta_vdatetime;
    public $entry_meta_vfloat_idx;
    public $entry_meta_vfloat;
    public $entry_meta_vinteger_idx;
    public $entry_meta_vinteger;
    public $category_meta_category_id;
    public $category_meta_type;
    public $category_meta_vblob;
    public $category_meta_vchar_idx;
    public $category_meta_vchar;
    public $category_meta_vclob;
    public $category_meta_vdatetime_idx;
    public $category_meta_vdatetime;
    public $category_meta_vfloat_idx;
    public $category_meta_vfloat;
    public $category_meta_vinteger_idx;
    public $category_meta_vinteger;
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
    public $tbping_meta_tbping_id;
    public $tbping_meta_type;
    public $tbping_meta_vblob;
    public $tbping_meta_vchar_idx;
    public $tbping_meta_vchar;
    public $tbping_meta_vclob;
    public $tbping_meta_vdatetime_idx;
    public $tbping_meta_vdatetime;
    public $tbping_meta_vfloat_idx;
    public $tbping_meta_vfloat;
    public $tbping_meta_vinteger_idx;
    public $tbping_meta_vinteger;
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
    public $cd_meta_cd_id;
    public $cd_meta_type;
    public $cd_meta_vblob;
    public $cd_meta_vchar_idx;
    public $cd_meta_vchar;
    public $cd_meta_vclob;
    public $cd_meta_vdatetime_idx;
    public $cd_meta_vdatetime;
    public $cd_meta_vfloat_idx;
    public $cd_meta_vfloat;
    public $cd_meta_vinteger_idx;
    public $cd_meta_vinteger;
}
