<?php
# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_blog (website)
 */
class Website extends Blog
{
    public function Save()
    {
        if (empty($this->blog_class)) {
            $this->blog_class = 'website';
        }
        return parent::Save();
    }

    public function blogs()
    {
        $where = "blog_parent_id = " . $this->id;

        require_once('class.mt_blog.php');
        $blog = new Blog();
        $blogs = $blog->Find($where);
        return $blogs;
    }

    public function site_path()
    {
        return $this->blog_site_path;
    }

    public function site_url()
    {
        return $this->blog_site_url;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Website', 'mt_blog_meta', 'blog_meta_blog_id');
