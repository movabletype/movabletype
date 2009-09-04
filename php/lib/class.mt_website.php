<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_blog (website)
 */
class Website extends Blog
{
    function Save() {
        if (empty($this->blog_class))
            $this->blog_class = 'website';
        return parent::Save();
    }

    function blogs() {
        $where = "blog_parent_id = " . $this->id;

        require_once('class.mt_blog.php');
        $blog = new Blog();
        $blogs = $blog->Find($where);
        return $blogs;
    }

    function site_path() {
        return $this->blog_site_path;
    }

    function site_url() {
        return $this->blog_site_url;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Website', 'mt_blog_meta','blog_meta_blog_id');	
