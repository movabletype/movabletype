<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.mt_blog.php 107470 2009-07-23 03:29:47Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_blog
 */
class Blog extends BaseObject
{
    public $_table = 'mt_blog';
    protected $_prefix = "blog_";
    protected $_has_meta = true;

	function Save() {
        if (empty($this->blog_class))
            $this->class = 'blog';
        return parent::Save();
    }

    function website() {
        $website_id = $this->parent_id;
        if (empty($website_id))
            return null;

        $where = "blog_id = " . $website_id;

        require_once('class.mt_website.php');
        $website = new Website();
        $sites = $website->Find($where);
        $site = null;
        if (!empty($sites))
            $site = $sites[0];
        return $site;
    }

    function blogs() {
        if ($this->class == 'blog')
            return null;

        $where = "blog_parent_id = " . $this->id;

        $blog = new Blog();
        $blogs = $blog->Find($where);
        return $blogs;
    }

    function site_path() {
        $site = $this->website();
        $path = '';
        if (!empty($site))
            $path = $site->blog_site_path . DIRECTORY_SEPARATOR;
        $path = $path . $this->blog_site_path;
        return $path;
    }

    function site_url() {
        $site = $this->website();
        $path = '';
        if (!empty($site))
            $path = $site->blog_site_url;
        $path = $path . $this->blog_site_url;
        return $path;
    }

    function archive_path() {
        $site = $this->website();
        $path = '';
        if (!empty($site))
            $path = $site->blog_archive_path . DIRECTORY_SEPARATOR;
        $path = $path . $this->blog_archive_path;
        return $path;
    }

    function archive_url() {
        $site = $this->website();
        $path = '';
        if (!empty($site))
            $path = $site->blog_archive_url;
        $path = $path . $this->blog_archive_url;
        return $path;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Blog', 'mt_blog_meta','blog_meta_blog_id');	
