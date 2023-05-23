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
    public $_prefix = "blog_";
    protected $_has_meta = true;

    // blog fields generated from perl implementation.
    public $blog_id;
    public $blog_allow_anon_comments;
    public $blog_allow_comment_html;
    public $blog_allow_commenter_regist;
    public $blog_allow_comments_default;
    public $blog_allow_data_api;
    public $blog_allow_pings;
    public $blog_allow_pings_default;
    public $blog_allow_reg_comments;
    public $blog_allow_unreg_comments;
    public $blog_archive_path;
    public $blog_archive_tmpl_category;
    public $blog_archive_tmpl_daily;
    public $blog_archive_tmpl_individual;
    public $blog_archive_tmpl_monthly;
    public $blog_archive_tmpl_weekly;
    public $blog_archive_type;
    public $blog_archive_type_preferred;
    public $blog_archive_url;
    public $blog_autodiscover_links;
    public $blog_autolink_urls;
    public $blog_basename_limit;
    public $blog_cc_license;
    public $blog_children_modified_on;
    public $blog_class;
    public $blog_content_css;
    public $blog_convert_paras;
    public $blog_convert_paras_comments;
    public $blog_created_by;
    public $blog_created_on;
    public $blog_custom_dynamic_templates;
    public $blog_date_language;
    public $blog_days_on_index;
    public $blog_description;
    public $blog_email_new_comments;
    public $blog_email_new_pings;
    public $blog_entries_on_index;
    public $blog_file_extension;
    public $blog_google_api_key;
    public $blog_internal_autodiscovery;
    public $blog_is_dynamic;
    public $blog_junk_folder_expiry;
    public $blog_junk_score_threshold;
    public $blog_language;
    public $blog_manual_approve_commenters;
    public $blog_moderate_pings;
    public $blog_moderate_unreg_comments;
    public $blog_modified_by;
    public $blog_modified_on;
    public $blog_mt_update_key;
    public $blog_name;
    public $blog_old_style_archive_links;
    public $blog_parent_id;
    public $blog_ping_blogs;
    public $blog_ping_google;
    public $blog_ping_others;
    public $blog_ping_technorati;
    public $blog_ping_weblogs;
    public $blog_remote_auth_token;
    public $blog_require_comment_emails;
    public $blog_sanitize_spec;
    public $blog_server_offset;
    public $blog_site_path;
    public $blog_site_url;
    public $blog_sort_order_comments;
    public $blog_sort_order_posts;
    public $blog_status_default;
    public $blog_theme_id;
    public $blog_use_comment_confirmation;
    public $blog_use_revision;
    public $blog_welcome_msg;
    public $blog_words_in_excerpt;

    # blog meta fields generated from perl implementation.
    public $blog_mt_blog_meta;
    public $blog_allow_to_change_at_upload;
    public $blog_auto_rename_non_ascii;
    public $blog_blog_content_accessible;
    public $blog_captcha_provider;
    public $blog_category_order;
    public $blog_commenter_authenticators;
    public $blog_default_mt_sites_action;
    public $blog_default_mt_sites_sites;
    public $blog_extra_path;
    public $blog_folder_order;
    public $blog_follow_auth_links;
    public $blog_image_default_align;
    public $blog_image_default_constrain;
    public $blog_image_default_link;
    public $blog_image_default_popup;
    public $blog_image_default_thumb;
    public $blog_image_default_width;
    public $blog_image_default_wrap_text;
    public $blog_image_default_wunits;
    public $blog_include_cache;
    public $blog_include_system;
    public $blog_max_revisions_cd;
    public $blog_max_revisions_entry;
    public $blog_max_revisions_template;
    public $blog_nofollow_urls;
    public $blog_normalize_orientation;
    public $blog_nwc_replace_field;
    public $blog_nwc_smart_replace;
    public $blog_operation_if_exists;
    public $blog_page_layout;
    public $blog_publish_empty_archive;
    public $blog_publish_queue;
    public $blog_require_typekey_emails;
    public $blog_template_set;
    public $blog_theme_export_settings;
    public $blog_update_pings;
    public $blog_upload_destination;

    // XXX Because __set/__get don't allow, we declare it in addition to $blog_blog_content_accessible
    public $blog_content_accessible;

    public $folder_order;

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
require_once("class.mt_blog_meta.php");
ADODB_Active_Record::ClassHasMany('Blog', 'mt_blog_meta','blog_meta_blog_id', 'BlogMeta');
?>
