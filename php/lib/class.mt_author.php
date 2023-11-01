<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_author
 */
class Author extends BaseObject
{
    public $_table = 'mt_author';
    public $_prefix = "author_";
    protected $_has_meta = true;

    # author fields generated from perl implementation.
    public $author_id;
    public $author_api_password;
    public $author_auth_type;
    public $author_basename;
    public $author_can_create_blog;
    public $author_can_view_log;
    public $author_created_by;
    public $author_created_on;
    public $author_date_format;
    public $author_email;
    public $author_entry_prefs;
    public $author_external_id;
    public $author_hint;
    public $author_is_superuser;
    public $author_locked_out_time;
    public $author_modified_by;
    public $author_modified_on;
    public $author_name;
    public $author_nickname;
    public $author_password;
    public $author_preferred_language;
    public $author_public_key;
    public $author_remote_auth_token;
    public $author_remote_auth_username;
    public $author_status;
    public $author_text_format;
    public $author_type;
    public $author_url;
    public $author_userpic_asset_id;

    # author meta fields generated from perl implementation.
    public $author_mt_author_meta;
    public $author_favorite_blogs;
    public $author_favorite_sites;
    public $author_favorite_websites;
    public $author_list_prefs;
    public $author_lockout_recover_salt;
    public $author_password_reset;
    public $author_password_reset_expires;
    public $author_password_reset_return_to;
    public $author_widgets;

    public function permissions( $blog_id = null ) {
        require_once('class.mt_permission.php');

        $whereOrder = "permission_author_id = " . $this->id;
        if ( !is_null( $blog_id ) ) {
            if (is_array($blog_id)) {
                $ids = join(',', $blog_id);
                 $whereOrder = $whereOrder . " and permission_blog_id in ( $ids )";
            } else {
                $whereOrder= $whereOrder . " and permission_blog_id = $blog_id";
            }
        }
        $whereOrder = $whereOrder . " order by permission_blog_id";

        $permission = new Permission;
        return $permission->Find($whereOrder);
    }

    public function userpic() {
        $userpic_id = $this->author_userpic_asset_id;

        if (empty($userpic_id) || !is_numeric($userpic_id))
            return;

        require_once('class.mt_asset.php');
        $asset = new Asset;
        $asset->Load("asset_id = $userpic_id");
        return $asset;
    }
}

// Relations
require_once("class.mt_author_meta.php");
ADODB_Active_Record::ClassHasMany('Author', 'mt_author_meta','author_meta_author_id', 'AuthorMeta');
?>
