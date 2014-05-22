<?php
# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

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

    function is_blog() {
        return $this->class == 'blog' ? true : false;
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

    function is_site_path_absolute() {
        $raw_path = $this->blog_site_path;
        if ( 1 == preg_match( '/^\//', $raw_path ) )
            return true;
        if ( 1 == preg_match( '/^[a-zA-Z]:'.preg_quote('\\').'/', $raw_path ) )
            return true;
        if ( 1 == preg_match( '/^\\\\[a-zA-Z0-9\.]+/', $raw_path ) )
            return true;
        return false;
    }

    function site_path() {
        if ( $this->is_site_path_absolute() )
            return $this->blog_site_path;

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
        if (empty($site)) {
            $path = $this->blog_site_url;
        }
        else {
            preg_match('/^(https?):\/\/(.+)\/$/', $site->blog_site_url, $matches);
            if ( count($matches) > 1 ) {
                $site_url = preg_split( '/\/::\//', $this->blog_site_url );
                if ( count($site_url) > 0 )
                    $path = $matches[1] . '://' . $site_url[0] . $matches[2] . '/' . $site_url[1];
                else
                    $path = $site->blog_site_url . $this->blog_site_url;
            }
            else {
                $path = $site->blog_site_url . $this->blog_site_url;
            }
        }
        return $path;
    }

    function archive_path() {
        $site = $this->website();
        $path = '';
        if (!empty($site) && !empty($site->blog_archive_path))
            $path = $site->blog_archive_path . DIRECTORY_SEPARATOR;
        $path = $path . $this->blog_archive_path;
        return $path;
    }

    function archive_url() {
        $path = '';
        if ( empty($this->blog_archive_url) ) {
            $path = $this->site_url();
        } else {
            $site = $this->website();
            if (empty($site))
                $this->site_url();
            else {
                preg_match('/^(https?):\/\/(.+)\/$/', $site->blog_site_url, $matches);
                if ( count($matches) > 1 ) {
                    $site_url = preg_split( '/\/::\//', $this->blog_archive_url );
                    if ( count($site_url) > 0 )
                        $path = $matches[1] . '://' . $site_url[0] . $matches[2] . '/' . $site_url[1];
                    else
                        $path = $site->blog_site_url . $this->blog_archive_url;
                }
                else {
                    $path = $site->blog_site_url . $this->blog_archive_url;
                }
            }
        }

        return $path;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Blog', 'mt_blog_meta','blog_meta_blog_id');	
?>
