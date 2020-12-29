<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
        if ( 1 == preg_match( '/^[a-zA-Z]:[\\/]/', $raw_path ) )
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

    function _raw_url($url) {
        if( list( $subdomain, $path ) = preg_split( '/\/::\//', $url ) ){
            return array( $subdomain, $path );
        }
        return $url;
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
        require_once('MTUtil.php');
        $url = $this->site_url();
        $site = $this->website();
        if (!empty($site))
            $url = $site->site_url();

        if ( empty($this->blog_archive_url) )
            return $this->site_url();

        if(preg_match('/^https?:\/\//', $this->blog_archive_url))
            return $this->blog_archive_url;

        $paths = $this->_raw_url($this->blog_archive_url);
        if ( count($paths) == 2 ) {
            if( $paths[0] ){
                $url = preg_replace('/^(https?):\/\/(.+)\/$/', "$1://$paths[0]$2/", $url);
            }
            if($paths[1]){
                $url = caturl(array($url, $paths[1]));
            }
        }
        else {
            $url = caturl(array($url, $paths[0]));
        }
        return $url;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('Blog', 'mt_blog_meta','blog_meta_blog_id');
?>
